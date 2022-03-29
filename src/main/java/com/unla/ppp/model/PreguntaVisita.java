package com.unla.ppp.model;

import java.sql.Timestamp;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "preguntas_visita")
@Getter @Setter
public class PreguntaVisita {
	
	public PreguntaVisita(){}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotEmpty(message = "Debe ingresar la pregunta")
	@Column(nullable = false)
	private String pregunta;
	
	@Column(nullable = true)
	private boolean cuestionarioHabitabilidad;	
	
	@Column(nullable = true)
	private String tipoRespuestaA;
	
	@Column(nullable = true)
	private String tipoRespuestaB;
	
	@Column(nullable = true)
	private String tipoRespuestaC;
	
	@Column(nullable = true)
	private boolean esTexto;
	
	@Column(nullable = true)
	private int etapaDeAvance;

	
	@JoinColumn(name = "intervencion_id", nullable = true)
	@ManyToOne(optional = true, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Intervencion intervencion;
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;
	
}
