package com.orktek.quebragalho.dto.PrestadorDTO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.service.PrestadorService;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para prestador na homepage do Cliente")
public class PrestadorHomePageDoUsuarioDTO {

    @Autowired
    private PrestadorService prestadorService;

    @Schema(description = "Identificador único do prestador", example = "1")
    private Long id;

    @Schema(description = "Identificador único do prestador", example = "1")
    private String nome;

    @Schema(description = "Imagem de perfil do prestador", example = "api/usuarios/1/imagem")
    private String imagemPerfil;

    @Schema(description = "Tags do prestador")
    private List<TagDTO> tags;

    @Schema(description = "Média das avaliações do prestador", example = "4.5")
    private Double mediaAvaliacoes;

    public static PrestadorHomePageDoUsuarioDTO fromEntity(Prestador prestador, PrestadorService prestadorService) {
        PrestadorHomePageDoUsuarioDTO dto = new PrestadorHomePageDoUsuarioDTO();
        dto.setId(prestador.getId());
        dto.setNome(prestador.getUsuario().getNome());
        dto.setImagemPerfil("api/usuarios/" + prestador.getUsuario().getId() + "/imagem");
        dto.setTags(prestador.getTags().stream().map(TagDTO::fromEntity).toList());
        dto.setMediaAvaliacoes(prestadorService.mediaNotaPrestador(prestador.getId()));
        return dto;
    }
}
