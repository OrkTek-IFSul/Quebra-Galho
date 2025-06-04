package com.orktek.quebragalho.dto.RespostaDTO;

import java.time.LocalDate;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CriarRespostaDTO {

    @Schema(description = "Comentário da resposta", example = "Esta é uma resposta.")
    private String resposta;

    @Schema(description = "Data da resposta", example = "2023-10-01")
    private LocalDate data;
    
}
