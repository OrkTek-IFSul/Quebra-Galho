package com.orktek.quebragalho.dto;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.util.List;
import java.util.stream.Collectors;
import com.orktek.quebragalho.model.Servico; // Added import for Servico class

import com.orktek.quebragalho.model.Tags;

@Data
@Schema(description = "DTO com Tag e os serviços associados")
public class TagServicoDTO {
    // Atributos básicos
    @Schema(description = "ID da tag", example = "1")
    private Long id;
    private String nome;
    private String status;
    
    // Relacionamento com serviços
    @Schema(description = "Lista simplificada de serviços")
    private List<ServicoSimplificadoDTO> servicos;

    public TagServicoDTO(Tags tag) {
        this.id = tag.getId();
        this.nome = tag.getNome();
        this.status = tag.getStatus();
        
        this.servicos = tag.getServicos().stream()
                .map(ServicoSimplificadoDTO::new)
                .collect(Collectors.toList());
    }
}

@Data
class ServicoSimplificadoDTO {
    @Schema(description = "ID do serviço", example = "1")
    private Long id;
    
    @Schema(description = "Nome do serviço", example = "Criação de Logo")
    private String nome;
    
    @Schema(description = "Categoria", example = "Design")
    private String prestador;

    public ServicoSimplificadoDTO(Servico servico) {
        this.id = servico.getId();
        this.nome = servico.getNome();
        this.prestador = servico.getPrestador().getUsuario().getNome(); 
    }
}