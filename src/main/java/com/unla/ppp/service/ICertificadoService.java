package com.unla.ppp.service;

import java.util.List;

import com.unla.ppp.dto.CertificadoDto;

public interface ICertificadoService {

	CertificadoDto agregar(CertificadoDto certificadoDto);
	List<CertificadoDto> obtenerDatosPorObra(Long obraId);
	List<CertificadoDto> obtenerDatos();
}
