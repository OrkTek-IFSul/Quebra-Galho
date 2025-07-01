package com.orktek.quebragalho.dto.DenunciaDTO;

import com.orktek.quebragalho.model.Denuncia;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class AnalisarDenunciaDTO {

    @Schema(description = "Identificador único da denúncia", example = "1")
    private Long denunciaId;

    @Schema(description = "Tipo do conteúdo denunciado", example = "Conta, Resposta, Avaliação")
    private String tipo;

    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;

    @Schema(description = "Identificador do conteúdo denunciado", example = "10")
    private Long idConteudoDenunciado;

    @Schema(description = "Conteúdo denunciado")
    private String conteudoDenunciado;

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

    public static AnalisarDenunciaDTO fromEntity(Denuncia denuncia) {
        AnalisarDenunciaDTO dto = new AnalisarDenunciaDTO();
        dto.setDenunciaId(denuncia.getId());
        dto.setTipo(denuncia.getTipo());
        dto.setMotivo(denuncia.getMotivo());
        dto.setIdConteudoDenunciado(denuncia.getIdComentario());
        if (dto.getTipo().equals("Conta")) {
            dto.setConteudoDenunciado("/api/usuario/perfil/" + denuncia.getIdComentario());
        } else if (dto.getTipo().equals("Resposta")) {
            dto.setConteudoDenunciado("/api/avaliacoesprestador/resposta/"+ denuncia.getIdComentario());
        } else if (dto.getTipo().equals("Avaliação")) {
            dto.setConteudoDenunciado("/api/avaliacoesprestador/avaliacao/"+ denuncia.getIdComentario());
        } else {
            dto.setConteudoDenunciado("Conteúdo não especificado");
        }
        dto.setDenuncianteId(denuncia.getDenunciante().getId());
        dto.setNomeDenunciante(denuncia.getDenunciante().getNome());
        dto.setDenunciadoId(denuncia.getDenunciado().getId());
        dto.setNomeDenunciado(denuncia.getDenunciado().getNome());
        dto.setStatus(denuncia.getStatus());
        return dto;
    }
}
