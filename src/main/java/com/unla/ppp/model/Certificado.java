package com.unla.ppp.model;

import java.sql.Timestamp;
import java.time.LocalDate;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "certificados")
@Getter @Setter
public class Certificado {

	public Certificado() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotNull(message = "Debe ingresar el valor")
	@Column(nullable = false)
	private double monto;
	
	@NotNull(message = "Debe ingresar el valor")
	@Column(nullable = false)
	private LocalDate fecha;
	
	@NotEmpty(message = "Debe ingresar el valor")
	@Column(nullable = false)
	private String pdf;
	
	@JoinColumn(name = "obra_id", nullable = false)
	@ManyToOne(optional = false, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Obra obra;
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;

}
