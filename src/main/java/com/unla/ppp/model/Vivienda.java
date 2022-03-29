package com.unla.ppp.model;

import java.sql.Timestamp;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicUpdate;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "viviendas")
@Getter @Setter
@DynamicUpdate
public class Vivienda {

	public Vivienda() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(unique = true)
	private String viviendaId;
	
	@Column(unique = true)
	private String aliasRenabap;
	
	@Column
	private int metrosCuadrados;
	
	@Column
	private int ambientes;
	
	@Column
	private boolean directoACalle;
	
	@Column
	private boolean servicioCloacas;
	
	@Column
	private boolean servicioLuz;
	
	@Column
	private boolean servicioAgua;

	@Column
	private boolean servicioGas;

	@Column
	private boolean servicioInternet;
	
	@Column
	private boolean reubicados;
	
	@Column
	private boolean duenosVivienda;
	
	@Column
	private String titular;
	
	@Column
	private String jefeHogarNombre;
	
	@Column
	private String contactoReferencia;

	@Column
	private String contactoJefeHogar;
	
	@Column
	private int cantHabitantes;
	
	@Column
	private int habitantesAdultos;

	@Column
	private int habitantesMenores;

	@Column
	private String pdfCondicionesHabitabilidad;

	@Column
	private int habitantesMayores;

	@Column(nullable = false)
	private boolean preguntasPgas;

	@Column(nullable = false)
	private boolean cuestionarioHabitabilidad;
	
	@OneToOne(cascade=CascadeType.ALL)
	@JoinColumn(name = "ubicacion_id", updatable = false, nullable = false)
	private Ubicacion ubicacion;
	
	@OneToOne(cascade=CascadeType.ALL)
	@JoinColumn(name = "documentacion_tecnica_id", updatable = false, nullable = false)
	private DocumentacionTecnica documentacionTecnica;

	@CreationTimestamp
	@Column(name = "created_at")
	private Timestamp createdAt;


}
