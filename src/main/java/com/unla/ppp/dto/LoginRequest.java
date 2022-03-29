package com.unla.ppp.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {
	
	@Schema(description = "Email del usuario. El usuario de ejemplo solo tiene permisos de lectura.", example = "usuario01@email.com")
    private String email;
	
	@Schema(description = "Clave del usuario.", example = "secreto")
    private String clave;
	
}
