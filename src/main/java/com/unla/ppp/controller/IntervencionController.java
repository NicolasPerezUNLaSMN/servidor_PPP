package com.unla.ppp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.unla.ppp.model.Intervencion;
import com.unla.ppp.service.IIntervencionService;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping(path = "/intervencion")
@AllArgsConstructor
public class IntervencionController {
	@Autowired
	private final IIntervencionService intervencionService;
	
	@GetMapping
	public ResponseEntity<Object> obtenerInformacion() {
		List<Intervencion> lista = null;
		Object body = "Lista vacia";
		HttpStatus status = HttpStatus.CONFLICT;
		try {
			lista = intervencionService.obtenerDatos();
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
