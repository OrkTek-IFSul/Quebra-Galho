package com.orktek.quebragalho.dto.ApeloDTO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CriarApeloDTO {

    @Schema(description = "Id da denuncia correspondente ao apelo", example = "1")
    private Long id_denuncia;

    @Schema(description = "Justificativa do apelo", example = "Necessidade de revisão urgente")
    private String justificativa;
}
