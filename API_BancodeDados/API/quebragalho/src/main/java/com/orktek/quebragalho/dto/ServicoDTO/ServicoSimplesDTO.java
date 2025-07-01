package com.orktek.quebragalho.dto.ServicoDTO;

import java.util.List;

import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.model.Servico;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um serviço")
public class ServicoSimplesDTO {
    @Schema(description = "Identificador único do serviço", example = "1")
    private Long id;

    @Schema(description = "Nome do serviço", example = "Corte de cabelo")
    private String nome;

    @Schema(description = "Descrição do serviço", example = "Corte de cabelo masculino")
    private String descricao;
    
    @Schema(description = "Preço do serviço", example = "90")
    private int duracao;

    @Schema(description = "Duracao do serviço", example = "50.0")
    private Double preco;

    @Schema(description = "Lista de tags do serviço")
    private List<TagDTO> tags;

    public static ServicoSimplesDTO fromEntity(Servico servico) {
        ServicoSimplesDTO dto = new ServicoSimplesDTO();
        dto.setId(servico.getId());
        dto.setNome(servico.getNome());
        dto.setDescricao(servico.getDescricao());
        dto.setDuracao(servico.getDuracaoMinutos());
        dto.setPreco(servico.getPreco());
        dto.setTags(servico.getTags().stream()
                .map(TagDTO::fromEntity)
                .toList());
        return dto;
    }
}
