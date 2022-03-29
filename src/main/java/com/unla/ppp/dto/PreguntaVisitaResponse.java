package com.unla.ppp.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
@Getter @Setter
public class PreguntaVisitaResponse {
	private Long id;
	
	private String pregunta;
	
	private boolean cuestionarioHabitabilidad;	
	
	private String tipoRespuestaA;
	
	private String tipoRespuestaB;
	
	private String tipoRespuestaC;
	
	private boolean esTexto;
	
	private int etapaDeAvance;
	
	private boolean visitaFinal;
	
	private Long intervencionId;
	
	private Timestamp createdAt;
}
