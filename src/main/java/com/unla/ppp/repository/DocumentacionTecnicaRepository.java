package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.DocumentacionTecnica;

@Repository
public interface DocumentacionTecnicaRepository extends JpaRepository <DocumentacionTecnica, Long> {

}
