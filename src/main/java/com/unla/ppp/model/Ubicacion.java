package com.unla.ppp.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicUpdate;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "ubicaciones")
@Getter @Setter
@DynamicUpdate
public class Ubicacion {
	public Ubicacion() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column
	private String region;

	@Column
	private String provincia;

	@Column
	private String localidad;

	@Column
	private String barrio;

	@Column
	private String direccion;
	
	@Column
	private String planta;
	
	@Column
	private double latitud;

	@Column
	private double longitud;

	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;

	@Override
	public String toString() {
		int idVivienda = -1;

		return "Ubicacion [id=" + id + ", region=" + region + ", provincia=" + provincia + ", localidad=" + localidad
				+ ", barrio=" + barrio + ", direccion=" + direccion + ", planta=" + planta + ", latitud=" + latitud
				+ ", longitud=" + longitud + ", vivienda=" + idVivienda + "]";
	}
	
	
}
