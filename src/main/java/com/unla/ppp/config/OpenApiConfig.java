package com.unla.ppp.config;

import java.util.Map;
import java.util.TreeMap;

import org.springdoc.core.customizers.OpenApiCustomiser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.media.Schema;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;

@Configuration
public class OpenApiConfig {

	private String title ="Api unla";

	private String description="API creada para poder almacenar informacion sobre las viviendas a relevar.\nPara hacer cualquier prueba debe estar loggeado busque auth-controller.";

	private String version = "1.0";
	
	@Bean
	public OpenApiCustomiser sortSchemasAlphabetically() {
	    return openApi -> {
	        Map<String, Schema> schemas = openApi.getComponents().getSchemas();
	        openApi.getComponents().setSchemas(new TreeMap<>(schemas));
	    };
	}
	
	@Bean
	public OpenAPI customOpenAPI() {
		final String securitySchemeName = "Authorization";
		OpenAPI openApi = new OpenAPI();
		openApi.setInfo(getInfo());
		openApi.addSecurityItem(new SecurityRequirement().addList(securitySchemeName));
		openApi.components(new Components().addSecuritySchemes(securitySchemeName,
											new SecurityScheme()
					                            .name(securitySchemeName)
					                            .type(SecurityScheme.Type.HTTP)
					                            .scheme("Bearer")
					                            .bearerFormat("JWT")));
		return openApi;
	}
	
	private Info getInfo() {
		Info info = new Info();
		info.setTitle(title);
		info.setDescription(description);
		info.setVersion(version);
		return info;
	}
}
