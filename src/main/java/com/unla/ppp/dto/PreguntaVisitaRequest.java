package com.unla.ppp.dto;

import javax.validation.constraints.NotEmpty;

import lombok.Getter;
import lombok.Setter;
@Getter @Setter
public class PreguntaVisitaRequest {
	private Long id;
	
	@NotEmpty(message = "Debe ingresar el valor")
	private String pregunta;
	
	private boolean cuestionarioHabitabilidad;	
	
	private String tipoRespuestaA;
	
	private String tipoRespuestaB;
	
	private String tipoRespuestaC;
	
	private boolean esTexto;
	
	private int etapaDeAvance;
	
	private Long intervencionId;
}
