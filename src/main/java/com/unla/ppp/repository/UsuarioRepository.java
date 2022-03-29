package com.unla.ppp.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Usuario;
@Repository
public interface UsuarioRepository extends JpaRepository <Usuario, Long> {
    public List<Usuario> findAll();
    public Optional<Usuario> findByEmail(String email);
}