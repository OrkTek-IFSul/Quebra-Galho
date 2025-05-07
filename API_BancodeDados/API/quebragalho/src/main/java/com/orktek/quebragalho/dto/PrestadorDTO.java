package com.orktek.quebragalho.dto;

import java.util.List;
import java.util.stream.Collectors;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Tags;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class PrestadorDTO {

    @Schema(description = "ID do prestador", example = "1")
    private Long id;

    @Schema(description = "Nome do prestador", example = "João Silva")
    private String nome;

    @Schema(description = "Email do prestador", example = "lorem@ipsum.com")
    private String email;

    @Schema(description = "Descricao do prestador", example = "Especialista em encanamento")
    private String descricao;

    @Schema(description = "Path da imagem de perfil do prestador", example = "/img/prestador123.jpeg")
    private String imagemPerfilUrl;

    @Schema(description = "Caminho do documento do prestador", example = "/img/prestador123.jpeg")
    private String documentoPath;

    @Schema(description = "Lista de tags associadas ao prestador")
    private List<TagSimplificadaDTO> tags;

    @Schema(description = "Lista de serviços")
    private List<ServicoSimplificadoDTO> servicos;

    public PrestadorDTO(Prestador prestador) {
        this.id = prestador.getId();
        this.nome = prestador.getUsuario().getNome();
        this.email = prestador.getUsuario().getEmail();
        this.descricao = prestador.getDescricao();
        this.imagemPerfilUrl = "/api/usuario/" + prestador.getUsuario().getId() + "/imagem";
        this.documentoPath = "/api/prestador/" + prestador.getId() + "/documento";
        this.tags = prestador.getTags().stream()
                .map(TagSimplificadaDTO::new)
                .collect(Collectors.toList());
        this.servicos = prestador.getServicos().stream()
                .map(ServicoSimplificadoDTO::new)
                .collect(Collectors.toList());
    }

    @Data
    class TagSimplificadaDTO {
        @Schema(description = "ID da tag", example = "1")
        private Long id;

        @Schema(description = "Nome da tag", example = "Encanamento")
        private String nome;

        public TagSimplificadaDTO(Tags tag) {
            this.id = tag.getId();
            this.nome = tag.getNome();
        }
    }
}