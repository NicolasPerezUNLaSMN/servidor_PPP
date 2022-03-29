package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.RespuestaVisita;


@Repository
public interface RespuestaVisitaRepository extends JpaRepository <RespuestaVisita, Long> {
}
