package com.unla.ppp.dto;

import com.unla.ppp.model.RespuestaVisita;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@AllArgsConstructor
public class VisitaDto {
	public VisitaDto() {}

	@JsonProperty(access = Access.READ_ONLY)
	private Long id;
	
	@NotNull(message = "Debe ingresar el numero de visita")
	private int numVisita;
	
	@NotNull(message = "Debe ingresar el numero del informe")
	private int informeId;
	
	@NotNull(message = "Debe ingresar la fecha")
	private LocalDate fecha;
	
	@NotEmpty(message = "Debe ingresar el nombre del Relevador")
	private String nombreRelevador;
	
	private String observaciones;
	
	@NotEmpty(message = "Debe ingresar si es o no visita final")
	private boolean visitaFinal;
	
	@NotNull(message = "Debe ingresar el pdf")
	private String pdfBase64;
	
	@NotNull(message = "Debe ingresar el id de la obra")
	private Long obraId;

	private List<RespuestaVisita> respuestas;
	
	@JsonProperty(access = Access.READ_ONLY)
	private Timestamp createdAt;
}
