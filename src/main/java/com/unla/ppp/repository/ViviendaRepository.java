package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Vivienda;

@Repository
public interface ViviendaRepository extends JpaRepository <Vivienda, Long>{

}
