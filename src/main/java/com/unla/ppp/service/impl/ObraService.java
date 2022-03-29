package com.unla.ppp.service.impl;

import org.springframework.stereotype.Service;

import com.unla.ppp.model.Obra;
import com.unla.ppp.repository.ObraRepository;
import com.unla.ppp.service.IObraService;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ObraService implements IObraService {
	
	private final ObraRepository obraRepository;

	@Override
	public Obra findById(Long id) {
		return obraRepository.findById(id).orElse(null);
	}

}
