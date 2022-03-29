package com.unla.ppp.service;

import java.io.IOException;
import java.util.List;

import com.unla.ppp.model.Vivienda;

public interface IViviendaService {

	Vivienda agregar(Vivienda vivienda);
	List<Vivienda> obtenerDatos();
	String agregarCuestionarioPdf(String pdfBase64, Long id) throws IOException;
	List<Vivienda> agregarViviendas(List<Vivienda> lista);
	Vivienda actualizar(Vivienda viviendaDatosNuevos, Long id);
}
