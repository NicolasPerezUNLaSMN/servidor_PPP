package com.unla.ppp.service.impl;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.unla.ppp.dto.CertificadoDto;
import com.unla.ppp.model.Certificado;
import com.unla.ppp.model.Obra;
import com.unla.ppp.repository.CertificadoRepository;
import com.unla.ppp.repository.ObraRepository;
import com.unla.ppp.service.ICertificadoService;
import com.unla.ppp.util.FilesUtil;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CertificadoService implements ICertificadoService{
	
	private final CertificadoRepository certificadoRepository;
	private final ObraRepository obraRepository;
	@Override
	public CertificadoDto agregar(CertificadoDto certificadoDto) {
		Certificado certificado = this.mapToEntity(certificadoDto);
		try {
			certificadoDto = this.mapToDto(certificadoRepository.save(certificado));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return certificadoDto;
	}

	@Override
	public List<CertificadoDto> obtenerDatosPorObra(Long obraId) {
		return certificadoRepository.findByObraId(obraId).stream().map(t -> {
			try {
				return mapToDto(t);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}).collect(Collectors.toList());
	}
	
	@Override
	public List<CertificadoDto> obtenerDatos() {
		return certificadoRepository.findAll().stream().map(t -> {
			try {
				return mapToDto(t);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}).collect(Collectors.toList());
	}
	private CertificadoDto mapToDto(Certificado certificado) throws IOException {
		CertificadoDto certificadoDto = new CertificadoDto();
		String pdfBase64 = FilesUtil.encodeFile(certificado.getPdf());
		certificadoDto.setPdfBase64(pdfBase64);
		certificadoDto.setId(certificado.getId());
		certificadoDto.setMonto(certificado.getMonto());
		certificadoDto.setFecha(certificado.getFecha());
		certificadoDto.setObraId(certificado.getObra().getId());
		certificadoDto.setCreatedAt(certificado.getCreatedAt());
		return certificadoDto;
	}
	private Certificado mapToEntity(CertificadoDto certificadoDto) {
		Certificado certificado = new Certificado();
		String ubicacionArchivo = "";
		String nombreArchivo = "cerficado_" + certificadoDto.getFecha() + ".pdf";
		try {
			ubicacionArchivo = FilesUtil.decodeFile(certificadoDto.getPdfBase64(), nombreArchivo);
		} catch (IOException e) {
			e.printStackTrace();
		}
		Obra obra = obraRepository.findById(certificadoDto.getObraId()).orElse(null);

		certificado.setFecha(certificadoDto.getFecha());
		certificado.setMonto(certificadoDto.getMonto());
		certificado.setPdf(ubicacionArchivo);
		certificado.setObra(obra);
		return certificado;
	}

}
