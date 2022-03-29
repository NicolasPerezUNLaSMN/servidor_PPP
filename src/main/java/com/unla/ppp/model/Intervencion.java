package com.unla.ppp.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

import org.hibernate.annotations.CreationTimestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "intervenciones")
@Getter @Setter
@AllArgsConstructor
public class Intervencion {
	public Intervencion() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotEmpty(message = "Debe ingresar el nombre de la intervencion")
	@Column(nullable = false)
	private String nombre;
	
	@Column(nullable = true)
	private boolean esPgas;
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;

	public Intervencion(String nombre, boolean esPgas) {
		super();
		this.nombre = nombre;
		this.esPgas = esPgas;
	}
	
	public Intervencion(String nombre) {
		super();
		this.nombre = nombre;
		this.esPgas = false;
	}
	
	
}
