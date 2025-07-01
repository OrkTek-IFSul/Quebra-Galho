package com.orktek.quebragalho.dto.DenunciaDTO;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;


@Data
public class CriarDenunciaDTO {

    @Schema(description = "Tipo do conteudo denunciado (Conta, Resposta ou Avaliação)", example = "Conta, Resposta ou Avaliação")
    private String tipo;

    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;

    @Schema(description = "Identificador do conteúdo denunciado", example = "10")
    private Long idConteudoDenunciado;

    @Schema(description = "Id do usuário que realizou a denúncia" , example = "5")
    private Long denunciante;

    @Schema(description = "Id do Usuário que foi denunciado", example = "3")
    private Long denunciado;
}
