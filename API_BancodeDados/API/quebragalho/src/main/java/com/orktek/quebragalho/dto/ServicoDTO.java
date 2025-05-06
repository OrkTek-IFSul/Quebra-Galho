package com.orktek.quebragalho.dto;

import java.util.List;

import com.orktek.quebragalho.model.Servico;
import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Data;

@Data
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
    private PrestadorDTO prestador;

    @Schema(description = "Lista de agendamentos associados ao serviço")
    private List<AgendamentoDTO> agendamentos;

    @Schema(description = "Lista de tags associadas ao serviço")
    private List<TagDTO> tags;

    public ServicoDTO(Servico servico) {
        this.id = servico.getId();
        this.nome = servico.getNome();
        this.descricao = servico.getDescricao();
        this.preco = servico.getPreco();
        this.prestador = new PrestadorDTO(servico.getPrestador());
        this.agendamentos = servico.getAgendamentos().stream()
                .map(AgendamentoDTO::new)
                .toList();
        this.tags = servico.getTags().stream()
                .map(TagDTO::new)
                .toList();
    }
}
