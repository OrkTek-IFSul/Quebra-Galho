package com.orktek.quebragalho.dto.ServicoDTO;

import java.util.List;

import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorGenericoDTO;
import com.orktek.quebragalho.model.Servico;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um serviço")
public class ServicoDTO {
    @Schema(description = "Identificador único do serviço", example = "1")
    private Long id;

    @Schema(description = "Nome do serviço", example = "Corte de cabelo")
    private String nome;

    @Schema(description = "Descrição do serviço", example = "Corte de cabelo masculino")
    private String descricao;

    @Schema(description = "Preço do serviço", example = "50.0")
    private Double preco;

    @Schema(description = "Prestador responsável pelo serviço")
    private PrestadorGenericoDTO prestador;

    @Schema(description = "Lista de tags associadas ao serviço")
    private List<TagDTO> tags;

    public static ServicoDTO fromEntity(Servico servico) {
        ServicoDTO dto = new ServicoDTO();
        dto.setId(servico.getId());
        dto.setNome(servico.getNome());
        dto.setDescricao(servico.getDescricao());
        dto.setPreco(servico.getPreco());
        dto.setPrestador(PrestadorGenericoDTO.fromEntity(servico.getPrestador()));
        dto.setTags(servico.getTags().stream().map(TagDTO::fromEntity).toList());
        return dto;
    }
}
