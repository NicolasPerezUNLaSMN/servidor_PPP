package com.unla.ppp.model;

import java.sql.Timestamp;
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

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicUpdate;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "documentaciones")
@Getter @Setter
@DynamicUpdate
public class DocumentacionTecnica {
	public DocumentacionTecnica() {}
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column
	private String datos;

	@Column
	private String computo;

	@Column
	private String planosDeObra;

	@Column
	private String cuadrillaDeTrabajadores;

	@Column
	private String sintesisDiagnosticoDeViviendas;

	@Column
	private String certificadoAvanceObra;

	@Column
	private String planDeObra;

	@Column
	private String diagramaGantt;
	
	@JoinColumn(name = "obra_id", nullable = false)
	@ManyToOne(optional = false, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private Obra obra;
	
	
	@Column(name = "created_at")
	@CreationTimestamp
	private Timestamp createdAt;

	@Override
	public String toString() {
		int idVivienda = -1;
	
		return "DocumentacionTecnica [id=" + id + ", datos=" + datos + ", computo=" + computo + ", planosDeObra="
				+ planosDeObra + ", cuadrillaDeTrabajadores=" + cuadrillaDeTrabajadores
				+ ", sintesisDiagnosticoDeViviendas=" + sintesisDiagnosticoDeViviendas + ", certificadoAvanceObra="
				+ certificadoAvanceObra + ", planDeObra=" + planDeObra + ", diagramaGantt=" + diagramaGantt + ", obra="
				+ obra + ", vivienda=" + idVivienda + "]";
	}
	
	
}
