package com.unla.ppp.model;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "visitas")
@Getter @Setter
public class Visita {
	
	public Visita() {}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@JsonProperty(access = Access.READ_ONLY)
	private Long id;
	
	@NotNull(message = "Debe ingresar el numero de visita")
	@Column(nullable = false)
	private int numVisita;
	
	@NotNull(message = "Debe ingresar el numero del informe")
	@Column(nullable = false)
	private int informeId;
	
	@NotNull(message = "Debe ingresar la fecha")
	@Column(nullable = false)
	private LocalDate fecha;
	
	@NotEmpty(message = "Debe ingresar el nombre del Relevador")
	@Column(nullable = false)
	private String nombreRelevador;
	
	
	@Column(nullable = false)
	private String observaciones;
	
	@NotNull(message = "Debe ingresar si es o no visita final")
	@Column(nullable = false)
	private boolean visitaFinal;
	
	@NotNull(message = "Debe ingresar el pdf")
	@Column(nullable = false)
	private String pdfInformeVisita;
	
	@JoinColumn(name = "obra_id", nullable = false)
	@ManyToOne(optional = false, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JsonProperty(access = Access.READ_ONLY)
	private Obra obra;

	@OneToMany(cascade=CascadeType.ALL)
  	@JoinColumn(name="visita_id", referencedColumnName="id")
	private List<RespuestaVisita> respuestas;
	
	@CreationTimestamp
	@Column(name = "created_at")
	private Timestamp createdAt;
	

	public Visita(int numVisita,
			int informeId,
			LocalDate fecha,
			String nombreRelevador,
			String observaciones,
			boolean visitaFinal,
			String pdfInformeVisita, Obra obra) {
		super();
		this.numVisita = numVisita;
		this.informeId = informeId;
		this.fecha = fecha;
		this.nombreRelevador = nombreRelevador;
		this.observaciones = observaciones;
		this.visitaFinal = visitaFinal;
		this.pdfInformeVisita = pdfInformeVisita;
		this.obra = obra;
	}
	
	
}
