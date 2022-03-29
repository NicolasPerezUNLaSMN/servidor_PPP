package com.unla.ppp.dto;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;
@Getter @Setter
public class ObraIntervencionRequest {
    @NotNull(message = "Debe ingresar el valor")
    private int nroComponente;
    private Long obraId;
    private Long intervencionId;
}
