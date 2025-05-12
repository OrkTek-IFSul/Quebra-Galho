package com.orktek.quebragalho.dto;



import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ApeloDTO {

    @Schema(description = "Identificador único do apelo", example = "1")
    private Long id;

    @Schema(description = "Justificativa do apelo", example = "Necessidade de revisão urgente")
    private String justificativa;

    @Schema(description = "Status do apelo", example = "true")
    private Boolean status;
}
