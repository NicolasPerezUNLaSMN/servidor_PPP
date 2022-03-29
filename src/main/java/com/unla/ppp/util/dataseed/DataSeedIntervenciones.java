package com.unla.ppp.util.dataseed;

import org.springframework.stereotype.Component;

import com.unla.ppp.model.Intervencion;
import com.unla.ppp.repository.IntervencionRepository;
import lombok.RequiredArgsConstructor;
@Component
@RequiredArgsConstructor
public class DataSeedIntervenciones {

	private final IntervencionRepository intervencionRepository;
	
	private boolean dataIsEmpty() {
		return intervencionRepository.count() == 0;
	}
	
	public void loadData() {
		if(dataIsEmpty()) {
			cargarIntervencionesObra();
			cargarPGAS();
		}
	}

	private void cargarIntervencionesObra() {
		intervencionRepository.save(new Intervencion("Mejoramiento cubierta de chapa"));
		intervencionRepository.save(new Intervencion("Mejoramiento envolvente exterior"));
		intervencionRepository.save(new Intervencion("Subdivisión y/o ampliación de ambientes"));
		intervencionRepository.save(new Intervencion("Mejoramiento de pisos"));
		intervencionRepository.save(new Intervencion("Conexión a agua potable"));
		intervencionRepository.save(new Intervencion("Conexión a red cloacal y/o instalación de  pozo séptico"));
		intervencionRepository.save(new Intervencion("Conexión a red eléctrica"));
		intervencionRepository.save(new Intervencion("Ampliacion habitacional 9m2"));
	}

	private void cargarPGAS() {
		intervencionRepository.save(new Intervencion("Programa de Comunicación", true));
		intervencionRepository.save(new Intervencion("Mecanismo de Atención de Reclamos y Resolución de conflictos", true));
		intervencionRepository.save(new Intervencion("Programa de capacitación", true));
		intervencionRepository.save(new Intervencion("Programa de Gestión de Residuos", true));
		intervencionRepository.save(new Intervencion("Programa de Retiro, Desocupación y Rehabilitación de Sitio", true));
		intervencionRepository.save(new Intervencion("Programa de Contingencias", true));
		intervencionRepository.save(new Intervencion("Programa de Seguridad e Higiene", true));
	}
}
