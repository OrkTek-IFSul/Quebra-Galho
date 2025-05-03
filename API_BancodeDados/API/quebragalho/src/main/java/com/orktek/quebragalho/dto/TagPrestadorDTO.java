package com.orktek.quebragalho.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.util.List;
import java.util.stream.Collectors;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Tags;

@Data
@Schema(description = "DTO com Tag e os prestadores associados")
public class TagPrestadorDTO {
    // Atributos básicos
    @Schema(description = "ID da tag", example = "1")
    private Long id;
    private String nome;
    private String status;
    
    // Relacionamento com prestadores
    @Schema(description = "Lista de prestadores")
    private List<PrestadorSimplificadoDTO> prestadores;

    public TagPrestadorDTO(Tags tag) {
        this.id = tag.getId();
        this.nome = tag.getNome();
        this.status = tag.getStatus();
        
        this.prestadores = tag.getPrestadores().stream()
                .map(PrestadorSimplificadoDTO::new)
                .collect(Collectors.toList());
    }
}

@Data
class PrestadorSimplificadoDTO {
    @Schema(description = "ID do prestador", example = "1")
    private Long id;
    
    @Schema(description = "Nome do prestador", example = "João Silva")
    private String nome;

    public PrestadorSimplificadoDTO(Prestador prestador) {
        this.id = prestador.getId();
        this.nome = prestador.getUsuario().getNome();
    }
}


