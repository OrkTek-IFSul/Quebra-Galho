package com.orktek.quebragalho.controller.controller_views;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.SetOptions;
import com.google.firebase.cloud.FirestoreClient;

import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.FieldValue;
import com.orktek.quebragalho.dto.AgendamentoDTO.PedidoAgendamentoServicoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.AgendamentoService;
import com.orktek.quebragalho.service.FirebaseMessagingService;

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

        @Autowired
        private FirebaseMessagingService firebaseService;

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

                // 2. Obter os participantes do chat
                Usuario cliente = agendamentoNovo.getUsuario();
                Usuario prestadorUsuario = agendamentoNovo.getServico().getPrestador().getUsuario();

                // 3. O ID do chat será o próprio ID do agendamento
                String chatId = agendamentoNovo.getId().toString();

                // 4. Criar o documento do chat no Firestore
                try {
                        Firestore db = FirestoreClient.getFirestore();
                        DocumentReference chatRef = db.collection("chats").document(chatId);

                        // 5. Preparar os dados para salvar no documento do chat
                        Map<String, Object> chatData = new HashMap<>();
                        chatData.put("agendamentoId", agendamentoNovo.getId());
                        chatData.put("nomeServico", agendamentoNovo.getServico().getNome());
                        chatData.put("participants",
                                        Arrays.asList(cliente.getId().toString(), prestadorUsuario.getId().toString()));
                        // Adicionar nomes e fotos para facilitar a exibição na lista de chats no
                        // Flutter
                        chatData.put("clienteNome", cliente.getNome());
                        chatData.put("clienteFotoUrl", cliente.getImgPerfil());
                        chatData.put("prestadorNome", prestadorUsuario.getNome());
                        chatData.put("prestadorFotoUrl", prestadorUsuario.getImgPerfil());
                        chatData.put("lastMessage", "Chat iniciado. Dê um olá!"); // Mensagem inicial opcional
                        chatData.put("lastMessageTimestamp", FieldValue.serverTimestamp());

                        // Escreve os dados no Firestore. Se o documento já existir, ele mescla os
                        // dados.
                        chatRef.set(chatData, SetOptions.merge());

                } catch (Exception e) {
                        // Lidar com possíveis erros de conexão com o Firebase
                        e.printStackTrace();
                        // (Opcional) Considerar uma lógica para tentar novamente mais tarde
                }

                // Envia a notificação para o usuario que solicitou o agendamento
                Usuario clienteNotificado = agendamentoNovo.getUsuario(); // O destinatário da notificação
                String titulo = "Pedido de Agendamento Aceito!";
                String corpo = agendamentoNovo.getServico().getPrestador().getUsuario().getNome() + " aceitou seu pedido de agendamento do serviço '"
                                + agendamentoNovo.getServico().getNome()
                                + "' para o dia " + agendamentoNovo.getDataHora().toLocalDate() + " às "
                                + agendamentoNovo.getDataHora().toLocalTime() + ".";
                String link = "/api/usuario/solicitacoes/agendamento/" + agendamentoNovo.getId(); // Link para a tela
                                                                                            // específica no app

                // Chama o método genérico que faz tudo
                firebaseService.enviarNotificacaoCompleta(clienteNotificado, titulo, corpo, link);

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
