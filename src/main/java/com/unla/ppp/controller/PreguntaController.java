package com.unla.ppp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.unla.ppp.dto.PreguntaVisitaRequest;
import com.unla.ppp.dto.PreguntaVisitaResponse;
import com.unla.ppp.model.PreguntaVisita;
import com.unla.ppp.service.IPreguntaVisitaService;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping(path = "/pregunta")
@AllArgsConstructor
public class PreguntaController {
	@Autowired
	private final IPreguntaVisitaService preguntaService;
	
	@PostMapping
	public ResponseEntity<Object> agregar(@RequestBody PreguntaVisitaRequest pregunta) {
		PreguntaVisita preguntaAgregada = preguntaService.agregar(pregunta);
		Object body = "No pudo agregarse";
		HttpStatus status = HttpStatus.CONFLICT;
		
		if(preguntaAgregada != null) {
			body = preguntaAgregada;
			status = HttpStatus.CREATED;
		}
		
		return ResponseEntity.status(status).body(body);
	}
	
	@PostMapping(value = "/lista")
	public ResponseEntity<Object> agregarLista(@RequestBody List<PreguntaVisitaRequest> lista) {
		List<PreguntaVisita> listaAgregada = preguntaService.agregarPreguntas(lista);
		Object body = "No pudo agregarse";
		HttpStatus status = HttpStatus.CONFLICT;
		
		if(listaAgregada != null) {
			body = listaAgregada;
			status = HttpStatus.CREATED;
		}
		
		return ResponseEntity.status(status).body(body);
	}
	
	@GetMapping
	public ResponseEntity<Object> obtenerInformacion() {
		List<PreguntaVisitaResponse> lista = null;
		Object body = "Lista vacia";
		HttpStatus status = HttpStatus.OK;
		try {
			lista = preguntaService.obtenerDatos();
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
