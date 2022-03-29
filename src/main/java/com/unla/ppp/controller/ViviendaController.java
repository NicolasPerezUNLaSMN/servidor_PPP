package com.unla.ppp.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.unla.ppp.model.Vivienda;
import com.unla.ppp.service.IViviendaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;

@Tag(name = "Viviendas")
@RestController
@RequestMapping(path = "/vivienda")
@AllArgsConstructor
public class ViviendaController {
	
	private final IViviendaService viviendaService;
	
	@PostMapping
	public ResponseEntity<Object> agregar(@RequestBody Vivienda vivienda){

		Object body = "";
		HttpStatus status = HttpStatus.CONFLICT;
		Vivienda viviendaAgregada = viviendaService.agregar(vivienda);
		try {
			viviendaAgregada = viviendaService.agregar(vivienda);
			body = viviendaAgregada;
			status = HttpStatus.CREATED;
		} catch (Exception e) {
			body = "Error de la excepcion: " + e.getMessage(); 
		}
		return ResponseEntity.status(status).body(body);
	}
	
	@PatchMapping(value = "/{id}")
	public ResponseEntity<Object> actualizar(@RequestBody Vivienda vivienda, @PathVariable String id){
		Vivienda viviendaActualizada;
		Object body = "";
		HttpStatus status = HttpStatus.CONFLICT;

		try {
			viviendaActualizada= viviendaService.actualizar(vivienda, Long.valueOf(id));
			status = HttpStatus.OK;
			body = viviendaActualizada;
		} catch (NumberFormatException e) {
			body = "Ingrese un numero valido.";
		}
		catch(Exception exception) {
			body = "Error de la excepcion: " + exception.getMessage();
		}

		return ResponseEntity.status(status).body(body);
	}
	
	@Operation(summary="Agrega una lista de viviendas", description = "Devuelve la lista de viviendas agregadas")
	@PostMapping(value = "/lista")
	public ResponseEntity<Object> agregarLista(@RequestBody List<Vivienda> lista) {
		List<Vivienda> listaAgregada = viviendaService.agregarViviendas(lista);
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
		System.out.print("ESTOY ACAAAAAAAA");
		List<Vivienda> lista = viviendaService.obtenerDatos();
		Object body = "Lista vacia";
		HttpStatus status = HttpStatus.OK;
		if(lista != null) {
			body = lista;
		}
		return ResponseEntity.status(status).body(body);
	}
	
	@Operation(summary="Agrega el cuestionario de habitabilidad. Es utilizado desde la aplicacion movil.", description = "Si fue agregado devuelve la ubicacion del archivo, si no devuelve un mensaje de error")
	@PostMapping(value = "/{id}/habitabilidad")
	public ResponseEntity<Object> agregarCuestionarioPdf(@RequestBody String pdfBase64, @PathVariable String id){
		Object body = "";
		HttpStatus status = HttpStatus.CONFLICT;
		String ubicacionArchivo = null;	
		try {
			ubicacionArchivo = viviendaService.agregarCuestionarioPdf(pdfBase64, Long.valueOf(id));
		} catch (NumberFormatException e) {
			body = "Ingrese un numero valido.";
		}
		catch (IOException e1) {
			body = "El archivo no pudo guardarse.";
		}

		if(ubicacionArchivo != null) {
			body = "Ubicacion archivo vivienda " + id + " : " + ubicacionArchivo;
			status = HttpStatus.OK;
		}
		return ResponseEntity.status(status).body(body);
	}
}
