package com.unla.ppp.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Getter;
import lombok.Setter;



@Entity
@Table(name = "obra_intervencion")
@Getter @Setter
public class ObraIntervencion {
	
	

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
   
    @Column(name = "nro_componente")
    private int nroComponente;

    @ManyToOne
    @JoinColumn(name="intervencion_id", nullable = false)
    private Intervencion intervencion;
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;
	
	public ObraIntervencion() {}

    @Override
    public String toString() {
        return "{" +
            " nroComponente='" + getNroComponente() + "'" +
            ", intervencion='" + getIntervencion() + "'" +
            ", obra='" + "'" +
            ", createdAt='" + getCreatedAt() + "'" +
            "}";
    }
}
