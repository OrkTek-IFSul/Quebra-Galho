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

    public static TagDTO fromEntity (Tags tag) {
        TagDTO dto = new TagDTO();
        dto.setId(tag.getId());
        dto.setNome(tag.getNome());
        return dto;
    }

    public Object toEntity() {
        Tags tag = new Tags();
        tag.setId(this.id);
        tag.setNome(this.nome);
        tag.setStatus("Ativo");
        return tag;
    }
}