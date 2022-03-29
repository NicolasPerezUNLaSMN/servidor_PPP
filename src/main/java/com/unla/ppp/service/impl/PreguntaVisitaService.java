package com.unla.ppp.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.unla.ppp.dto.PreguntaVisitaRequest;
import com.unla.ppp.dto.PreguntaVisitaResponse;
import com.unla.ppp.model.Intervencion;
import com.unla.ppp.model.PreguntaVisita;
import com.unla.ppp.repository.IntervencionRepository;
import com.unla.ppp.repository.PreguntaVisitaRepository;
import com.unla.ppp.service.IPreguntaVisitaService;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PreguntaVisitaService implements IPreguntaVisitaService{
	
	private final PreguntaVisitaRepository repositorio;
	private final IntervencionRepository repositorioIntervencion;
	
	@Override
	public List<PreguntaVisitaResponse> obtenerDatos() {
		List<PreguntaVisitaResponse> lista = repositorio.findAll().stream().map(this::mapToDTO).collect(Collectors.toList());
		return lista;
	}

	@Override
	public PreguntaVisita agregar(PreguntaVisitaRequest preguntaRequest) {
		return repositorio.save(this.mapToEntity(preguntaRequest));
	}

	@Override
	public List<PreguntaVisita> agregarPreguntas(List<PreguntaVisitaRequest> lista) {
		List<PreguntaVisita> listaPreguntas = lista.stream().map(this::mapToEntity).collect(Collectors.toList());
		List<PreguntaVisita> preguntasGuardadas = null;
		System.out.println("Cantidad de preguntas " + listaPreguntas.size());
		try {
			preguntasGuardadas = repositorio.saveAll(listaPreguntas);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return preguntasGuardadas;
	}

	private PreguntaVisita mapToEntity(PreguntaVisitaRequest preguntaRequest) {
		PreguntaVisita pregunta = new PreguntaVisita();
		Intervencion intervencion = null;
		if(preguntaRequest.getIntervencionId() != 0) {
			intervencion = repositorioIntervencion.getById(preguntaRequest.getIntervencionId());
		}
		System.out.println(intervencion);
		pregunta.setId(preguntaRequest.getId());
		pregunta.setPregunta(preguntaRequest.getPregunta());
		pregunta.setTipoRespuestaA(preguntaRequest.getTipoRespuestaA());
		pregunta.setTipoRespuestaB(preguntaRequest.getTipoRespuestaB());
		pregunta.setTipoRespuestaC(preguntaRequest.getTipoRespuestaC());
		pregunta.setEsTexto(preguntaRequest.isEsTexto());
		pregunta.setEtapaDeAvance(preguntaRequest.getEtapaDeAvance());
		pregunta.setCuestionarioHabitabilidad(preguntaRequest.isCuestionarioHabitabilidad());
		pregunta.setIntervencion(intervencion);
		return pregunta;
	}
	
	private PreguntaVisitaResponse mapToDTO(PreguntaVisita pregunta) {
		PreguntaVisitaResponse preguntaReponse = new PreguntaVisitaResponse();
		Long intervencionId = 0L;
		if(pregunta.getIntervencion() != null) {
			intervencionId = pregunta.getIntervencion().getId();
		}
		preguntaReponse.setId(pregunta.getId());
		preguntaReponse.setPregunta(pregunta.getPregunta());
		preguntaReponse.setTipoRespuestaA(pregunta.getTipoRespuestaA());
		preguntaReponse.setTipoRespuestaB(pregunta.getTipoRespuestaB());
		preguntaReponse.setTipoRespuestaC(pregunta.getTipoRespuestaC());
		preguntaReponse.setEsTexto(pregunta.isEsTexto());
		preguntaReponse.setEtapaDeAvance(pregunta.getEtapaDeAvance());
		preguntaReponse.setCuestionarioHabitabilidad(pregunta.isCuestionarioHabitabilidad());
		preguntaReponse.setIntervencionId(intervencionId);
		return preguntaReponse;
	}
}
