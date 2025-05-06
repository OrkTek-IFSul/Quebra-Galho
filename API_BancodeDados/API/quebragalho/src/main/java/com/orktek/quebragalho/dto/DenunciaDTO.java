package com.orktek.quebragalho.dto;

import com.orktek.quebragalho.model.Denuncia;
import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Data;

@Data
public class DenunciaDTO {

    @Schema(description = "Identificador único da denúncia", example = "1")
    private Long id;

    @Schema(description = "Tipo da denúncia", example = "Abuso")
    private String tipo;

    @Schema(description = "Motivo da denúncia", example = "Conteúdo impróprio")
    private String motivo;

    @Schema(description = "Status da denúncia", example = "true")
    private Boolean status;

    @Schema(description = "Identificador da avaliação ou resposta relacionada à denúncia", example = "10")
    private String idComentario;

    @Schema(description = "Usuário que realizou a denúncia")
    private UsuarioDTO denunciante;

    @Schema(description = "Usuário que foi denunciado")
    private UsuarioDTO denunciado;

    public DenunciaDTO(Denuncia denuncia) {
        this.id = denuncia.getId();
        this.tipo = denuncia.getTipo();
        this.motivo = denuncia.getMotivo();
        this.status = denuncia.getStatus();
        if (denuncia.getIdComentario() == null)
            this.idComentario = "Não se aplica";
        else
            this.idComentario = Long.toString(denuncia.getIdComentario());
        this.denunciante = new UsuarioDTO(denuncia.getDenunciante());
        this.denunciado = new UsuarioDTO(denuncia.getDenunciado());
    }
}
