package com.unla.ppp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Rol;
@Repository
public interface RolRepository extends JpaRepository<Rol, Long> {
    public Rol findByName(String name);
}
