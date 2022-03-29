package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.ObraIntervencion;

@Repository
public interface ObraIntervencionRepository extends JpaRepository <ObraIntervencion, Long>{

}
