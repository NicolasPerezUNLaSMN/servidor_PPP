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

import com.unla.ppp.dto.VisitaDto;
import com.unla.ppp.model.Visita;
import com.unla.ppp.service.IVisitaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
@Tag(name = "Visitas")
@RestController
@RequestMapping(path = "/visita")
@AllArgsConstructor
public class VisitaController {
	
	@Autowired
	private final IVisitaService visitaService;
	@Operation(summary="Agrega una nueva visita. Es utilizado desde la aplicacion movil.")
	@PostMapping
	public ResponseEntity<Object> agregar(@RequestBody VisitaDto visita) {
		Visita visitaAgregada = visitaService.agregar(visita);
		Object body = "No pudo agregarse";
		HttpStatus status = HttpStatus.CONFLICT;
		
		if(visitaAgregada != null) {
			body = visitaAgregada;
			status = HttpStatus.CREATED;
		}
		
		return ResponseEntity.status(status).body(body);
	}
	
	@GetMapping
	public ResponseEntity<Object> obtenerInformacion(@RequestParam(name="obraId", required = false) String obraId) {
		List<VisitaDto> lista = null;
		Object body = "Lista vacia";
		HttpStatus status = HttpStatus.OK;
		try {
			if(obraId != null) {
				lista = visitaService.obtenerDatosPorObra(Long.valueOf(obraId));
			}
			else {
				lista = visitaService.obtenerDatos();
			}
		} 
		catch(NumberFormatException e1) {
			body = "Ingrese un id valido";
			status = HttpStatus.CONFLICT;
		}
		catch (Exception e) {
			e.printStackTrace();
			body = e.getMessage();
			status = HttpStatus.CONFLICT;
		}
		if(lista != null) {
			body = lista;
		}
		return ResponseEntity.status(status).body(body);
	}

}
