package com.unla.ppp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.ppp.model.Certificado;

@Repository
public interface CertificadoRepository extends JpaRepository <Certificado, Long> {
	List<Certificado> findByObraId(Long idObra);
}
