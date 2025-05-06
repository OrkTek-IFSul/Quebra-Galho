package com.orktek.quebragalho.dto;

import java.time.LocalDate;

import com.orktek.quebragalho.model.Resposta;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class RespostaDTO {
    @Schema(description = "Identificador único da resposta", example = "1")
    private Long id;

    @Schema(description = "Comentário da resposta", example = "Esta é uma resposta.")
    private String resposta;

    @Schema(description = "Data da resposta", example = "2023-10-01")
    private LocalDate data;

    @Schema(description = "Avaliação associada à resposta")
    private AvaliacaoDTO avaliacao;

    public RespostaDTO(Resposta resposta) {
        this.id = resposta.getId();
        this.resposta = resposta.getResposta();
        this.data = resposta.getData();
        this.avaliacao = new AvaliacaoDTO(resposta.getAvaliacao());
    }
}
