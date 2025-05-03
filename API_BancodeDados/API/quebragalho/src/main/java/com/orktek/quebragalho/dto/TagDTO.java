package com.orktek.quebragalho.dto;


import com.orktek.quebragalho.model.Tags;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO básico com apenas os atributos da Tag")
public class TagDTO {
    @Schema(description = "ID da tag", example = "1")
    private Long id;
    
    @Schema(description = "Nome da tag", example = "Design")
    private String nome;
    
    @Schema(description = "Status da tag", example = "Ativo")
    private String status;

    public TagDTO(Tags tag) {
        this.id = tag.getId();
        this.nome = tag.getNome();
        this.status = tag.getStatus();
    }
}