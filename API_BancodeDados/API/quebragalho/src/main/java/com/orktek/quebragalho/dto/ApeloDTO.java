package com.orktek.quebragalho.dto;

import com.orktek.quebragalho.model.Apelo;

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

    @Schema(description = "Denúncia associada ao apelo")
    private DenunciaDTO denuncia;

    public ApeloDTO(Apelo apelo) {
        this.id = apelo.getId();
        this.justificativa = apelo.getJustificativa();
        this.status = apelo.getStatus();
        this.denuncia = new DenunciaDTO(apelo.getDenuncia());
    }
}
