package com.orktek.quebragalho.controller.controller_views;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.AgendamentoDTO.AgendamentoMinhasSolicitacoesDTO;
import com.orktek.quebragalho.dto.AvaliacaoDTO.CarregarAvaliacaoDTO;
import com.orktek.quebragalho.dto.AvaliacaoDTO.CriarAvaliacaoDTO;
import com.orktek.quebragalho.model.Agendamento;
import com.orktek.quebragalho.model.Avaliacao;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.service.AgendamentoService;
import com.orktek.quebragalho.service.AvaliacaoService;
import com.orktek.quebragalho.service.PrestadorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * Controller para operações da tela de solicitações do usuario
 */
@RestController
@RequestMapping("/api/usuario/solicitacoes")
@Tag(name = "Solicitações enviadas pelo usuario", description = "Solicitações enviadas pelo usuario ")
public class MinhasSoliticacoesController {

    @Autowired
    private PrestadorService prestadorService;
    @Autowired
    private AgendamentoService agendamentoService;
    @Autowired
    private AvaliacaoService avaliacaoService;

    @Operation(summary = "Lista todos os agendamentos do usuário", description = "Retorna uma lista de solicitações (agendamentos) feitas pelo usuário informado.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista de agendamentos retornada com sucesso", content = @Content(mediaType = "application/json", schema = @Schema(implementation = AgendamentoMinhasSolicitacoesDTO.class))),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @GetMapping("/{usuarioId}")
    public ResponseEntity<List<AgendamentoMinhasSolicitacoesDTO>> carregaAgendamentos(
            @Parameter(description = "ID do usuário para buscar as solicitações", required = true, example = "1") @PathVariable Long usuarioId) {
        // Cria Lista de DTOs
        List<AgendamentoMinhasSolicitacoesDTO> agendamentosDTO = new ArrayList<>();

        for (Agendamento agendamentos : agendamentoService.listarPorUsuario(usuarioId)) {
            // Verifica se o prestador existe
            Prestador prestador = prestadorService.buscarPorId(agendamentos.getServico().getPrestador().getId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
            // usa o prestador e o agendamento para criar o DTO
            AgendamentoMinhasSolicitacoesDTO agendamentoDTO = AgendamentoMinhasSolicitacoesDTO.fromEntity(agendamentos,
                    prestador);
            // Adiciona o DTO à lista
            agendamentosDTO.add(agendamentoDTO);
        }
        // Retorna a lista de DTOs
        return ResponseEntity.ok(agendamentosDTO);
    }

    @Operation(summary = "Busca detalhes de um agendamento específico", description = "Retorna os detalhes de uma solicitação (agendamento) específica pelo seu ID.", tags = {
            "Solicitações enviadas pelo usuario" })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Agendamento retornado com sucesso", content = @Content(mediaType = "application/json", schema = @Schema(implementation = AgendamentoMinhasSolicitacoesDTO.class))),
            @ApiResponse(responseCode = "404", description = "Agendamento não encontrado")
    })
    @GetMapping("/agendamento/{agendamentoId}")
    public ResponseEntity<AgendamentoMinhasSolicitacoesDTO> carregaAgendamento(
            @Parameter(description = "ID do agendamento para buscar os detalhes", required = true, example = "1") @PathVariable Long agendamentoId) {
        // Busca o agendamento pelo ID
        Agendamento agendamento = agendamentoService.buscarPorId(agendamentoId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        // Busca o prestador pelo ID
        Prestador prestador = prestadorService.buscarPorId(agendamento.getServico().getPrestador().getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        // Cria o DTO a partir do agendamento e do prestador
        AgendamentoMinhasSolicitacoesDTO agendamentoDTO = AgendamentoMinhasSolicitacoesDTO.fromEntity(agendamento,
                prestador);
        return ResponseEntity.ok(agendamentoDTO);
    }

    @PostMapping("/agendamento/{agendamentoId}/avaliacao")
    @Operation(summary = "Avalia um agendamento", description = "Permite que o usuário avalie um agendamento específico pelo seu ID.")
        @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Avaliacao criada com sucesso", content = @Content(mediaType = "application/json", schema = @Schema(implementation = CriarAvaliacaoDTO.class))),
            @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
            @ApiResponse(responseCode = "404", description = "Agendamento não encontrado")
    })
    public ResponseEntity<CarregarAvaliacaoDTO> criarAvaliacao(
        @Parameter(description = "ID do agendamento que será avaliado", required = true, example = "1") @PathVariable Long agendamentoId, 
        @Parameter(description = "Informações da avaliação", required = true) @RequestBody CriarAvaliacaoDTO avaliacaoDTO) {
            Avaliacao avaliacao = new Avaliacao();

            avaliacao.setAgendamento(agendamentoService.buscarPorId(agendamentoId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND)));

            avaliacao.setNota(avaliacaoDTO.getNota());
            avaliacao.setComentario(avaliacaoDTO.getComentario());
            avaliacao.setData(LocalDate.now());
            avaliacaoService.criarAvaliacao(avaliacao);

            CarregarAvaliacaoDTO retornoAvaliacaoDTO = CarregarAvaliacaoDTO.fromEntity(avaliacao);

        return ResponseEntity.ok(retornoAvaliacaoDTO);
    }

}
