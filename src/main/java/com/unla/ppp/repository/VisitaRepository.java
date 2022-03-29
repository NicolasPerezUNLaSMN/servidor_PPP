package com.unla.ppp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Visita;

@Repository
public interface VisitaRepository extends JpaRepository <Visita, Long>{

	List<Visita> findByObraId(Long idObra);
}
