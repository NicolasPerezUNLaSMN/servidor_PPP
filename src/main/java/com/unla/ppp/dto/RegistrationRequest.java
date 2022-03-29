package com.unla.ppp.dto;

import javax.validation.constraints.NotNull;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@RequiredArgsConstructor
@EqualsAndHashCode
@ToString
public class RegistrationRequest {
	
    @NotNull
    @Schema(description = "Nombre del usuario", example = "Laura")
    private final String nombre;
    
    @NotNull
    @Schema(description = "Apellido del usuario", example = "Gomez")
    private final String apellido;
    
    @NonNull
    @NotNull
    @Schema(description = "Email", example = "admin20@email.com")
    private String email;
    
    @NotNull
    @Schema(description = "Clave del usuario", example = "hola123")
    private final String clave;
    
    @NotNull
    @Schema(description = "Descripcion del usuario", example = "Encargado de subir las viviendas")
    private final String descripcion;
    
    @Schema(description = "Rol del usuario. Si no ingresa ninguno sera visitante por defecto. // 'ROL_ADMIN': rol admin // 'ROL_USER': rol visitante // 'ROL_RELEVADOR': rol relevador", example = "1")
    private final String nombreRol;
    
}
