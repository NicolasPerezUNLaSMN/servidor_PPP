package com.unla.ppp.service;

import java.util.List;

import com.unla.ppp.dto.PreguntaVisitaRequest;
import com.unla.ppp.dto.PreguntaVisitaResponse;
import com.unla.ppp.model.PreguntaVisita;

public interface IPreguntaVisitaService {

	List<PreguntaVisitaResponse>obtenerDatos();
	PreguntaVisita agregar(PreguntaVisitaRequest preguntaRequest);
	List<PreguntaVisita>agregarPreguntas(List<PreguntaVisitaRequest>lista);
}
