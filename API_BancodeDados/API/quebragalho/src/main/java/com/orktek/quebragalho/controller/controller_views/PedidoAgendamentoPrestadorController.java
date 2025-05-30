package com.orktek.quebragalho.controller.controller_views;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.orktek.quebragalho.dto.AgendamentoDTO.PedidoAgendamentoServicoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.service.AgendamentoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

@RestController
@RequestMapping("/api/prestador/pedidoservico")
@Tag(name = "Tela de Pedido de agendamento do prestador", description = "Operações relacionadas à tela de pedidos de agendamento do prestador")
public class PedidoAgendamentoPrestadorController {

        @Autowired
        AgendamentoService agendamentoService = new AgendamentoService();

        @Operation(summary = "Lista com os pedidos de serviços do prestador", description = "Retorna todos os agendamentos pendentes feitos à um prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "Lista de agendamentos retornada com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Agendamentos não encontrados"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
        })
        @GetMapping("/{idPrestador}")
        public ResponseEntity<List<PedidoAgendamentoServicoDTO>> listarPedidosAtivos(
                        @Parameter(description = "Id do prestador que abrirá esta tela") @PathVariable Long idPrestador) {
                List<PedidoAgendamentoServicoDTO> agendamentos = agendamentoService
                                .listarPorPrestador(idPrestador)
                                .stream().map(PedidoAgendamentoServicoDTO::fromEntity)
                                .collect(Collectors.toList());
                return ResponseEntity.ok(agendamentos);
        }

        @Operation(summary = "Pedido de serviço do prestador", description = "Retorna um agendamento pendente feito à um prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "Agendamento retornado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Agendamento não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @GetMapping("pedido/{idAgendamento}")
        public ResponseEntity<PedidoAgendamentoServicoDTO> listarPedidoAtivo(
                        @Parameter @PathVariable Long idAgendamento) {
                return agendamentoService.buscarPorId(idAgendamento)
                                .map(PedidoAgendamentoServicoDTO::fromEntity)
                                .map(ResponseEntity::ok)
                                .orElse(ResponseEntity.notFound().build());
        }

        @Operation(summary = "Aceitar pedido de serviço do prestador", description = "Aceita o pedido de agendamento", responses = {
                        @ApiResponse(responseCode = "200", description = "Agendamento retornado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Agendamento não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @PutMapping("/{idAgendamento}/aceitar")
        public ResponseEntity<PedidoAgendamentoServicoDTO> aceitarPedido(
                        @Parameter @PathVariable Long idAgendamento) {
                Agendamento agendamentoNovo = agendamentoService.atualizarStatusAceitoAgendamento(idAgendamento, true);
                return ResponseEntity.ok(PedidoAgendamentoServicoDTO.fromEntity(agendamentoNovo));
        }

        @Operation(summary = "Recusar pedido de serviço do prestador", description = "Recusar o pedido de agendamento", responses = {
                        @ApiResponse(responseCode = "200", description = "Agendamento retornado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Agendamento não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @PutMapping("/{idAgendamento}/recusar")
        public ResponseEntity<PedidoAgendamentoServicoDTO> recusarPedido(
                        @Parameter @PathVariable Long idAgendamento) {
                Agendamento agendamentoNovo = agendamentoService.atualizarStatusAceitoAgendamento(idAgendamento, false);
                return ResponseEntity.ok(PedidoAgendamentoServicoDTO.fromEntity(agendamentoNovo));
        }
}
