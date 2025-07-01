package com.orktek.quebragalho.dto.PrestadorDTO;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(name = "CriarPrestadorUsuarioExistenteDTO", description = "DTO para criação de prestador com usuário existente")
public class CriarPrestadorUsuarioExistenteDTO {

    @Schema(description = "Descrição do prestador", example = "Especialista em encanamento residencial")
    private String descricao;
}