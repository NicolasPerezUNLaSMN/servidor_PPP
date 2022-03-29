package com.unla.ppp.service.impl;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;

import com.unla.ppp.model.Obra;
import com.unla.ppp.model.ObraIntervencion;
import com.unla.ppp.model.Ubicacion;
import com.unla.ppp.model.Vivienda;
import com.unla.ppp.repository.ViviendaRepository;
import com.unla.ppp.service.IViviendaService;
import com.unla.ppp.util.FilesUtil;

import lombok.AllArgsConstructor;
@Service
@AllArgsConstructor
public class ViviendaService implements IViviendaService{
	
	private final ViviendaRepository viviendaRepository;
	
	@Override
	public Vivienda agregar(Vivienda vivienda) {
		return viviendaRepository.save(vivienda);
	}
	@Override
	public Vivienda actualizar(Vivienda viviendaDatosNuevos, Long id) {
		Vivienda viviendaAActualizar = viviendaRepository.findById(id).orElse(null);
		// ACTUALIZAR INFO VIVIVIENDA
		if(viviendaDatosNuevos.getAliasRenabap() != null)
			viviendaAActualizar.setAliasRenabap(viviendaDatosNuevos.getAliasRenabap());
		// ACTUALIZAR INFO DEL BARRIO
		if(viviendaDatosNuevos.getUbicacion() != null) {
			Ubicacion ubicacion = viviendaAActualizar.getUbicacion();
			if(viviendaDatosNuevos.getUbicacion().getProvincia() != null)
				ubicacion.setProvincia(viviendaDatosNuevos.getUbicacion().getProvincia());
			if(viviendaDatosNuevos.getUbicacion().getLocalidad() != null)
				ubicacion.setLocalidad(viviendaDatosNuevos.getUbicacion().getLocalidad());
			if(viviendaDatosNuevos.getUbicacion().getBarrio() != null)
				ubicacion.setBarrio(viviendaDatosNuevos.getUbicacion().getBarrio());
			if(viviendaDatosNuevos.getUbicacion().getDireccion() != null)
				ubicacion.setDireccion(viviendaDatosNuevos.getUbicacion().getDireccion());
		}
		// ACTUALIZAR INFO DOCUMENTACION TECNICA
		if(viviendaDatosNuevos.getDocumentacionTecnica() != null) {
			Obra obraNueva = viviendaDatosNuevos.getDocumentacionTecnica().getObra();
			// ACTUALIZAR INFO OBRA
			if(obraNueva != null) {
				Obra obraActual = viviendaAActualizar.getDocumentacionTecnica().getObra();
				
				if(obraNueva.getNombreRepresentanteOSC() != null)
					obraActual.setNombreRepresentanteOSC(obraNueva.getNombreRepresentanteOSC());
				// Falta actualizar las intervenciones	
			}
		}
		return viviendaRepository.save(viviendaAActualizar);
	}
	
	@Override
	public List<Vivienda> obtenerDatos() {
		return viviendaRepository.findAll();
	}

	@Override
	public String agregarCuestionarioPdf(String pdfBase64, Long id) throws IOException {
		Vivienda vivienda = viviendaRepository.findById(id).orElse(null);
		String nombreArchivo = "cuestionarioHabitabilidad" + vivienda.getId() + "_" + LocalDate.now() + ".pdf";
		String ubicacionArchivo = FilesUtil.decodeFile(pdfBase64, nombreArchivo);
		vivienda.setPdfCondicionesHabitabilidad(ubicacionArchivo);
		viviendaRepository.save(vivienda);
		return ubicacionArchivo;
	}

	@Override
	public List<Vivienda> agregarViviendas(List<Vivienda> lista) {
		return viviendaRepository.saveAll(lista);
	}

}
