package com.orktek.quebragalho.dto.DenunciaDTO;

import com.orktek.quebragalho.model.Denuncia;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CarregarDenunciaDTO {

    @Schema(description = "Identificador único da denúncia", example = "1")
    private Long denunciaId;

    @Schema(description = "Tipo da denúncia", example = "Abuso")
    private String tipo;

    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;

    @Schema(description = "Identificador da avaliação ou resposta relacionada à denúncia", example = "10")
    private Long idComentario;

    @Schema(description = "Id do usuário que realizou a denúncia", example = "5")
    private Long denuncianteId;

    @Schema(description = "Nome do usuario que denunciou")
    private String nomeDenunciante;

    @Schema(description = "Id do Usuário que foi denunciado", example = "3")
    private Long denunciadoId;

    @Schema(description = "Nome do usuario denunciado")
    private String nomeDenunciado;

    @Schema(description = "Status da denúncia", example = "null")
    private Boolean status;

    public static CarregarDenunciaDTO fromEntity(Denuncia denuncia) {
        CarregarDenunciaDTO dto = new CarregarDenunciaDTO();
        dto.setDenunciaId(denuncia.getId());
        dto.setTipo(denuncia.getTipo());
        dto.setMotivo(denuncia.getMotivo());
        dto.setIdComentario(denuncia.getIdComentario());
        dto.setDenuncianteId(denuncia.getDenunciante().getId());
        dto.setNomeDenunciante(denuncia.getDenunciante().getNome());
        dto.setDenunciadoId(denuncia.getDenunciado().getId());
        dto.setNomeDenunciado(denuncia.getDenunciado().getNome());
        dto.setStatus(denuncia.getStatus());
        return dto;
    }
}
