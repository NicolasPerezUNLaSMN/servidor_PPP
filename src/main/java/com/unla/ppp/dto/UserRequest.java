package com.unla.ppp.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;
import com.unla.ppp.model.Rol;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class UserRequest {
    private String nombre;
    private String apellido;
    private String email;
    @JsonProperty(access = Access.WRITE_ONLY)
    private String clave;
    private String descripcion;
    private Rol rolId;
    @JsonProperty(access = Access.WRITE_ONLY)
    private String nombreRol;
}
