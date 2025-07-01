package com.orktek.quebragalho.dto.ApeloDTO;
import com.orktek.quebragalho.dto.DenunciaDTO.CarregarDenunciaDTO;
import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.model.Denuncia;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CarregarApeloDTO {

    @Schema(description = "Identificador único do apelo", example = "1")
    private Long apeloId;

    @Schema(description = "Justificativa do apelo", example = "Necessidade de revisão urgente")
    private String justificativa;

    @Schema(description = "Status do apelo", example = "true")
    private Boolean status;

    @Schema(description = "Denuncia associada ao apelo")
    private CarregarDenunciaDTO denuncia;

    public static CarregarApeloDTO fromEntity(Apelo apelo) {
        CarregarApeloDTO dto = new CarregarApeloDTO();
        dto.setApeloId(apelo.getId());
        dto.setJustificativa(apelo.getJustificativa());
        dto.setStatus(apelo.getStatus());
        if (apelo.getDenuncia() != null) {
            Denuncia denuncia = apelo.getDenuncia();
            dto.setDenuncia(CarregarDenunciaDTO.fromEntity(denuncia));
        } else {
            dto.setDenuncia(null);
        }
        return dto;
    }
}
