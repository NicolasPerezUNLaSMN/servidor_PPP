package com.unla.ppp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.PreguntaVisita;

@Repository
public interface PreguntaVisitaRepository extends JpaRepository <PreguntaVisita, Long>{

	List<PreguntaVisita> findByIntervencionId(Long id);
}
