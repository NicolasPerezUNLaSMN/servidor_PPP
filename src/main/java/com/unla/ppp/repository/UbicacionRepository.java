package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Ubicacion;

@Repository
public interface UbicacionRepository extends JpaRepository <Ubicacion, Long>{

}
