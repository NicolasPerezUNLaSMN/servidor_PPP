package com.unla.ppp.service;

import java.util.List;

import com.unla.ppp.dto.VisitaDto;
import com.unla.ppp.model.RespuestaVisita;
import com.unla.ppp.model.Visita;

public interface IVisitaService {

	Visita agregar(VisitaDto visita);
	List<VisitaDto> obtenerDatosPorObra(Long idObra);
	List<VisitaDto> obtenerDatos();
	void agregarRespuestas(Visita visita, List<RespuestaVisita> respuestas, Long obraId);
	
}
