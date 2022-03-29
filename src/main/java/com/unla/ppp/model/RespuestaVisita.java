package com.unla.ppp.model;

import java.sql.Timestamp;

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
@Table(name = "respuestas_visita")
@Getter @Setter
public class RespuestaVisita {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotEmpty(message = "Debe ingresar la respuesta")
	@Column(nullable = false)
	private String respuesta;
	
	@Column(nullable = false)
	private double puntaje = -1;
	
	@Column(nullable = false)
	private boolean pgas = false;

	@Column(nullable = false)
	private Long nroComponente;
	
	@JoinColumn(name = "pregunta_visita_id", nullable = false)
	@ManyToOne(optional = false, fetch = FetchType.EAGER)
	private PreguntaVisita preguntaVisita;
	
	@Column(name = "vivienda_id")
	private Long vivienda;
	
	@Column(name="visita_id")
	private Long visita;
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;
}
