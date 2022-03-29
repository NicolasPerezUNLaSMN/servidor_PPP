package com.unla.ppp.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.unla.ppp.model.Intervencion;
import com.unla.ppp.repository.IntervencionRepository;
import com.unla.ppp.service.IIntervencionService;

import lombok.AllArgsConstructor;
@Service
@AllArgsConstructor
public class IntervencionService implements IIntervencionService{

	private final IntervencionRepository intervencionRepository;
	@Override
	public List<Intervencion> obtenerDatos() {
		return intervencionRepository.findAll();
	}

}
