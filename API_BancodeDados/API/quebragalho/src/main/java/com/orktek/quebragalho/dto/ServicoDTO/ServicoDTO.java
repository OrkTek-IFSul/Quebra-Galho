package com.orktek.quebragalho.dto.ServicoDTO;

import java.util.List;

import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.model.Servico;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um serviço")
public class ServicoDTO {

    @Schema(description = "Nome do serviço", example = "Corte de cabelo")
    private String nome;

    @Schema(description = "Descrição do serviço", example = "Corte de cabelo masculino")
    private String descricao;

    @Schema(description = "Preço do serviço", example = "50.0")
    private Double preco;

    @Schema(description = "Duração do serviço em minutos", example = "90")
    private int duracaoMinutos;

    @Schema(description = "Prestador responsável pelo serviço")
    private Long idPrestador;

    @Schema(description = "Lista de tags associadas ao serviço")
    private List<TagDTO> tags;

    public static ServicoDTO fromEntity(Servico servico) {
        ServicoDTO dto = new ServicoDTO();
        dto.setNome(servico.getNome());
        dto.setDescricao(servico.getDescricao());
        dto.setPreco(servico.getPreco());
        dto.setDuracaoMinutos(servico.getDuracaoMinutos());
        dto.setIdPrestador(servico.getPrestador().getId());
        dto.setTags(servico.getTags().stream().map(TagDTO::fromEntity).toList());
        return dto;
    }
}
