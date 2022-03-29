package com.unla.ppp.model;

import java.sql.Timestamp;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "obras")
@Getter @Setter
public class Obra {
	public Obra() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
    @OneToMany(
            cascade = CascadeType.ALL,
            fetch = FetchType.EAGER
        )
	private List<ObraIntervencion> intervenciones;
    
	@Column(nullable = true)
	private String nombreRepresentanteOSC;
    
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;

	@Override
	public String toString() {
		return "Obra [id=" + id + ", organizacion="  + ", intervenciones=" + intervenciones
				+ ", createdAt=" + createdAt + "]";
	}
	
	
}
