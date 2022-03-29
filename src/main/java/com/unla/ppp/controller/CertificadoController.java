package com.unla.ppp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.unla.ppp.dto.CertificadoDto;
import com.unla.ppp.service.ICertificadoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
@Tag(name = "Certificados")
@RestController
@RequestMapping(path = "/certificado")
@AllArgsConstructor
public class CertificadoController {
	@Autowired
	private final ICertificadoService certificadoService;
	@Operation(summary="Agrega un nuevo certificado. Es utilizado desde la aplicacion movil.")
	@PostMapping
	public ResponseEntity<Object> agregar(@RequestBody CertificadoDto certificado) {
		CertificadoDto certificadoAgregado = certificadoService.agregar(certificado);
		Object body = "No pudo agregarse";
		HttpStatus status = HttpStatus.CONFLICT;
		
		if(certificadoAgregado != null) {
			body = certificadoAgregado;
			status = HttpStatus.CREATED;
		}
		
		return ResponseEntity.status(status).body(body);
	}
	
	@GetMapping
	public ResponseEntity<Object> obtenerInformacion(@RequestParam(name="obraId", required = false) String obraId) {
		List<CertificadoDto> lista = null;
		Object body = "Lista vacia";
		HttpStatus status = HttpStatus.CONFLICT;
		try {
			if(obraId != null) {
				lista = certificadoService.obtenerDatosPorObra(Long.valueOf(obraId));
			}
			else {
				lista = certificadoService.obtenerDatos();
			}
		} 
		catch(NumberFormatException e1) {
			body = "Ingrese un id valido";
		}
		catch (Exception e) {
			e.printStackTrace();
			body = e.getMessage();
			status = HttpStatus.CONFLICT;
		}
		if(lista != null) {
			status = HttpStatus.OK;
			body = lista;
		}
		return ResponseEntity.status(status).body(body);
	}
}
