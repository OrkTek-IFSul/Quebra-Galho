package com.orktek.quebragalho.dto.AgendamentoDTO;

import com.orktek.quebragalho.model.Agendamento;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "DTO para criar um agendamento")
public class PedidoAgendamentoServicoDTO {

    @Schema(description = "Nome do usuário que está fazendo o pedido de agendamento", example = "João Silva")
    private String nomeDoUsuario;

    @Schema(description = "Endereço da foto do usuário", example = "/api/usuarios/1/imagem")
    private String fotoPerfilUsuario;

    @Schema(description = "Data e hora do agendamento", example = "2023-10-01T10:00:00")
    private String dataHoraAgendamento;

    @Schema(description = "Nome do servico", example = "Corte de cabelo")
    private String nomeServico;
    
    @Schema(description = "Preço do servico", example = "50.00")
    private Double precoServico;

    @Schema(description = "ID do serviço", example = "1")
    private Long idServico;

    @Schema(description = "ID do agendamento", example = "1")
    private Long idAgendamento;

    @Schema(description = "ID do usuario", example = "1")
    private Long idUsuario;

    @Schema(description = "Status do pedido do agendamento (Null = pendente / True = aceito / False = recusado)", example = "true")
    public Boolean statusPedidoAgendamento;

    public static PedidoAgendamentoServicoDTO fromEntity(Agendamento agendamento) {
        PedidoAgendamentoServicoDTO dto = new PedidoAgendamentoServicoDTO();
        dto.nomeDoUsuario = agendamento.getUsuario().getNome();
        if (agendamento.getUsuario().getImgPerfil() != null) {
            dto.fotoPerfilUsuario = "/api/usuarios/" + agendamento.getUsuario().getId() + "/imagem";
        } else {
            dto.fotoPerfilUsuario = null;
        }
        dto.statusPedidoAgendamento = agendamento.getStatusAceito();
        dto.dataHoraAgendamento = agendamento.getDataHora().toString();
        dto.idAgendamento = agendamento.getId();
        dto.idServico = agendamento.getServico().getId();
        dto.idUsuario = agendamento.getUsuario().getId();
        dto.nomeServico = agendamento.getServico().getNome();
        dto.precoServico = agendamento.getServico().getPreco();
        return dto;
    }
}
