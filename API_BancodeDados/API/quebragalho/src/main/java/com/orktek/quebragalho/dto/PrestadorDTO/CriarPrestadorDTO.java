package com.orktek.quebragalho.dto.PrestadorDTO;

import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;
import com.orktek.quebragalho.model.Prestador;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(name = "CriarPrestadorDTO", description = "DTO para criação de prestador")
public class CriarPrestadorDTO {

    @Schema(description = "Dados do usuário", example = "{\"nome\":\"João Silva\",\"email\":\"joao@email.com\"}")
    private CriarUsuarioDTO usuario;

    @Schema(description = "Descrição do prestador", example = "Especialista em encanamento residencial")
    private String descricao;

    public static CriarPrestadorDTO fromEntity(Prestador prestador) {
        CriarPrestadorDTO dto = new CriarPrestadorDTO();
        dto.setUsuario(CriarUsuarioDTO.fromEntity(prestador.getUsuario()));
        dto.setDescricao(prestador.getDescricao());
        return dto;
    }
}