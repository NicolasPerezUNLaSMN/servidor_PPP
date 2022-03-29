package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Obra;

@Repository
public interface ObraRepository extends JpaRepository <Obra, Long>{

}
