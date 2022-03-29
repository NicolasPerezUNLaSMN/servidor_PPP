package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Intervencion;

@Repository
public interface IntervencionRepository extends JpaRepository <Intervencion, Long>{

}
