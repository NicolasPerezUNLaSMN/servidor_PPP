package com.unla.ppp.service.impl;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.unla.ppp.dto.VisitaDto;
import com.unla.ppp.model.Obra;
import com.unla.ppp.model.RespuestaVisita;
import com.unla.ppp.model.Visita;
import com.unla.ppp.repository.ObraRepository;
import com.unla.ppp.repository.RespuestaVisitaRepository;
import com.unla.ppp.repository.VisitaRepository;
import com.unla.ppp.service.IVisitaService;
import com.unla.ppp.util.FilesUtil;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class VisitaService implements IVisitaService {
	
	private final VisitaRepository visitaRepository;
	private final RespuestaVisitaRepository respuestaRepository;
	private final ObraRepository obraRepository;
	
	@Override
	public Visita agregar(VisitaDto visitaDto) {
		Visita visita = null;
		try {
			visita = this.mapToEntity(visitaDto);
			visita = visitaRepository.save(visita);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return visita;
	}

	@Override
	public List<VisitaDto> obtenerDatosPorObra(Long idObra) {
		return visitaRepository.findByObraId(idObra).stream().map(t -> {
			try {
				return mapToDto(t);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}).collect(Collectors.toList());
	}
	
	@Override
	public List<VisitaDto> obtenerDatos() {
		return visitaRepository.findAll().stream().map(t -> {
			try {
				return mapToDto(t);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}).collect(Collectors.toList());
	}
	
	@Override
	public void agregarRespuestas(Visita visita, List<RespuestaVisita> respuestas, Long obraId) {
		Obra obra = obraRepository.findById(obraId).orElse(null);
		visita.setObra(obra);
		visita = visitaRepository.save(visita);
		for(RespuestaVisita respuesta : respuestas) {
			respuestaRepository.save(respuesta);
		}
	}
	
	private VisitaDto mapToDto(Visita visita) throws IOException {
		VisitaDto visitaDto = new VisitaDto();
		String pdfBase64 = FilesUtil.encodeFile(visita.getPdfInformeVisita());
		visitaDto.setId(visita.getId());
		visitaDto.setNumVisita(visita.getNumVisita());
		visitaDto.setInformeId(visita.getInformeId());
		visitaDto.setFecha(visita.getFecha());
		visitaDto.setCreatedAt(visita.getCreatedAt());
		visitaDto.setNombreRelevador(visita.getNombreRelevador());
		visitaDto.setObservaciones(visita.getObservaciones());
		visitaDto.setVisitaFinal(visita.isVisitaFinal());
		visitaDto.setPdfBase64(pdfBase64);
		visitaDto.setObraId(visita.getObra().getId());
		visitaDto.setRespuestas(visita.getRespuestas());
		
		return visitaDto;
	}
	
	private Visita mapToEntity(VisitaDto visitaDto) throws IOException {
		String nombreArchivo = "Obra" + visitaDto.getObraId() + "_informeVisita" + visitaDto.getNumVisita() + "_" + visitaDto.getFecha() + ".pdf";
		String ubicacionArchivo = "";
		System.out.println(visitaDto.getObraId());
		Obra obra = obraRepository.findById(visitaDto.getObraId()).orElse(null);

		ubicacionArchivo = FilesUtil.decodeFile(visitaDto.getPdfBase64(), nombreArchivo);
		Visita visita = new Visita(visitaDto.getNumVisita(), visitaDto.getInformeId(), visitaDto.getFecha(),
			visitaDto.getNombreRelevador(),
			visitaDto.getObservaciones(), visitaDto.isVisitaFinal(),
			ubicacionArchivo, obra);
		
		visita.setRespuestas(visitaDto.getRespuestas());
		return visita;
	}

}
