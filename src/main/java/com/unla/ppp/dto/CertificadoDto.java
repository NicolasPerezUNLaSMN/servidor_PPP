package com.unla.ppp.dto;

import java.sql.Timestamp;
import java.time.LocalDate;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@AllArgsConstructor
public class CertificadoDto {
	public CertificadoDto() {}
	@JsonProperty(access = Access.READ_ONLY)
	private Long id;
	@NotNull(message = "Debe ingresar el monto")
	private double monto;
	
	@NotNull(message = "Debe ingresar la fecha")
	private LocalDate fecha;
	
	@NotNull(message = "Debe ingresar el pdf")
	private String pdfBase64;
	@NotNull(message = "Debe ingresar la obra")
	private Long obraId;
	
	@JsonProperty(access = Access.READ_ONLY)
	private Timestamp createdAt;
}
