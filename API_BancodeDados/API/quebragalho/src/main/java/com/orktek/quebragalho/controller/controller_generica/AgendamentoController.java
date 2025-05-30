package com.orktek.quebragalho.controller.controller_generica;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.service.AgendamentoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

/**
 * Controller para agendamentos de serviços
 */
@RestController
@RequestMapping("/api/agendamentos")
// @Tag(name = "Agendamentos", description = "Gerenciamento de agendamentos de serviços")
public class AgendamentoController {

    @Autowired
    private AgendamentoService agendamentoService;

//     /**
//      * Cria novo agendamento
//      * POST /api/agendamentos
//      */
//     @Operation(summary = "Cria um novo agendamento", description = "Cria um novo agendamento para um serviço e usuário específicos", responses = {
//             @ApiResponse(responseCode = "201", description = "Agendamento criado com sucesso"),
//             @ApiResponse(responseCode = "400", description = "Dados inválidos"),
//             @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
//     })
//     @PostMapping
//     public ResponseEntity<Agendamento> criarAgendamento(
//             @Parameter(description = "ID do serviço a ser agendado", required = true) @RequestParam Long servicoId,
//             @Parameter(description = "ID do usuário que está agendando", required = true) @RequestParam Long usuarioId,
//             @Parameter(description = "Detalhes do agendamento", required = true) @RequestBody Agendamento agendamento) {
//         Agendamento novoAgendamento = agendamentoService.criarAgendamento(agendamento, servicoId, usuarioId);
//         return ResponseEntity.status(201).body(novoAgendamento);
//     }

//     /**
//      * Lista agendamentos de um usuário
//      * GET /api/agendamentos/usuario/{usuarioId}
//      */
//     @Operation(summary = "Lista agendamentos de um usuário", description = "Retorna todos os agendamentos associados a um usuário específico", responses = {
//             @ApiResponse(responseCode = "200", description = "Lista de agendamentos retornada com sucesso"),
//             @ApiResponse(responseCode = "404", description = "Usuário não encontrado"),
//             @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
//     })
//     @GetMapping("/usuario/{usuarioId}")
//     public ResponseEntity<List<CriarAgendamentoDTO>> listarPorUsuario(
//             @Parameter(description = "ID do usuário cujos agendamentos serão listados", required = true) @PathVariable Long usuarioId) {
//         List<CriarAgendamentoDTO> agendamentos = agendamentoService.listarPorUsuario(usuarioId)
//                 .stream().map(CriarAgendamentoDTO::new)
//                 .collect(Collectors.toList());
//         return ResponseEntity.ok(agendamentos);
//     }

//     /**
//      * Lista agendamentos de um prestador
//      * GET /api/agendamentos/prestador/{prestadorId}
//      */
//     @Operation(summary = "Lista agendamentos de um prestador", description = "Retorna todos os agendamentos associados a um prestador específico", responses = {
//             @ApiResponse(responseCode = "200", description = "Lista de agendamentos retornada com sucesso"),
//             @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
//             @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
//     })
//     @GetMapping("/prestador/{prestadorId}")
//     public ResponseEntity<List<CriarAgendamentoDTO>> listarPorPrestador(
//             @Parameter(description = "ID do prestador cujos agendamentos serão listados", required = true) @PathVariable Long prestadorId) {
//         List<CriarAgendamentoDTO> agendamentos = agendamentoService.listarPorPrestador(prestadorId)
//                 .stream().map(CriarAgendamentoDTO::new)
//                 .collect(Collectors.toList());
//         return ResponseEntity.ok(agendamentos);
//     }

    /**
     * Cancela um agendamento
     * DELETE /api/agendamentos/{id}
     */
    @Operation(summary = "Cancela um agendamento", description = "Cancela um agendamento específico pelo ID", responses = {
            @ApiResponse(responseCode = "204", description = "Agendamento cancelado com sucesso"),
            @ApiResponse(responseCode = "404", description = "Agendamento não encontrado"),
            @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> cancelarAgendamento(
            @Parameter(description = "ID do agendamento a ser cancelado", required = true) @PathVariable Long id) {
        agendamentoService.deletarAgendamento(id);
        return ResponseEntity.noContent().build();
    }
}
