package com.orktek.quebragalho.dto.AvaliacaoDTO;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CriarAvaliacaoDTO {

    @Schema(description = "Nota da avaliação", example = "5")
    private Integer nota;

    @Schema(description = "Comentário da avaliação", example = "Ótimo serviço!")
    private String comentario;
}
