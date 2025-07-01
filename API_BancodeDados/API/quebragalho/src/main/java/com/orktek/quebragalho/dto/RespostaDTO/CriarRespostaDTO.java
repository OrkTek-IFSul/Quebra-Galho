package com.orktek.quebragalho.dto.RespostaDTO;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CriarRespostaDTO {

    @Schema(description = "Comentário da resposta", example = "Esta é uma resposta.")
    private String resposta;
    
}
