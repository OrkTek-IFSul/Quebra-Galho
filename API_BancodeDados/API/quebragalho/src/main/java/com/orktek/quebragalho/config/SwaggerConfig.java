package com.orktek.quebragalho.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.media.Schema;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.orktek.quebragalho.dto.PrestadorDTO.CriarPrestadorDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;

@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .components(new Components()
                .addSchemas("CriarPrestadorDTO", new Schema<CriarPrestadorDTO>())
                .addSchemas("CriarUsuarioDTO", new Schema<CriarUsuarioDTO>())
            );
    }
}
