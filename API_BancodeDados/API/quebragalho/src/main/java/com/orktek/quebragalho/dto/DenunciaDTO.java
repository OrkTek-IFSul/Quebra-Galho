package com.orktek.quebragalho.dto;

import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class DenunciaDTO {

    @Schema(description = "Identificador único da denúncia", example = "1")
    private Long id;

    @Schema(description = "Tipo da denúncia", example = "Abuso")
    private String tipo;

    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;

    @Schema(description = "Status da denúncia", example = "true")
    private Boolean status;

    @Schema(description = "Identificador da avaliação ou resposta relacionada à denúncia", example = "10")
    private String idComentario;

    @Schema(description = "Usuário que realizou a denúncia")
    private CriarUsuarioDTO denunciante;

    @Schema(description = "Usuário que foi denunciado")
    private CriarUsuarioDTO denunciado;
}
