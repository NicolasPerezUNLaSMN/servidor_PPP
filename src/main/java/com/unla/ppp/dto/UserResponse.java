package com.unla.ppp.dto;

import com.unla.ppp.model.Rol;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
@Getter @Setter
@AllArgsConstructor
public class UserResponse {
    public UserResponse() {}
	private Long id;
	private String nombre;
    private String apellido;
    private String email;
    private String descripcion;
    private Rol rolId;
}
