package com.orktek.quebragalho.dto.PrestadorDTO;

import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioGenericoDTO;
import com.orktek.quebragalho.model.Prestador;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para resposta genérica de prestador")
public class PrestadorGenericoDTO {

    @Schema(description = "Identificador único do prestador", example = "1")
    private Long id;

    @Schema(description = "Descrição do prestador", example = "Prestador especializado em serviços elétricos")
    private String descricao;

    @Schema(description = "Usuario do prestador")
    private UsuarioGenericoDTO usuario;

    public static PrestadorGenericoDTO fromEntity(Prestador prestador) {
        PrestadorGenericoDTO dto = new PrestadorGenericoDTO();
        dto.setId(prestador.getId());
        dto.setDescricao(prestador.getDescricao());
        dto.setUsuario(UsuarioGenericoDTO.fromEntity(prestador.getUsuario()));
        return dto;
    }
}
