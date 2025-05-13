package com.orktek.quebragalho.controller.controller_views;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.PrestadorDTO.AtualizarPrestadorDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorPerfilDTO;
import com.orktek.quebragalho.dto.ServicoDTO.ServicoSimplesDTO;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.service.PrestadorService;
import com.orktek.quebragalho.service.ServicoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

@RestController
@RequestMapping("/api/prestador/perfil")
@Tag(name = "Tela de perfil do prestador", description = "Operações relacionadas à tela de perfil do prestador")
public class PerfilPrestadorController {

        @Autowired
        private PrestadorService prestadorService;
        @Autowired
        private ServicoService servicoService;

        @Operation(summary = "Informações do perfil do prestador", description = "Retorna um prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "prestador retornado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "prestador não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @GetMapping("/{idPrestador}")
        public ResponseEntity<PrestadorPerfilDTO> listarPedidoAtivo(
                        @Parameter(description = "Id do prestador") @PathVariable Long idPrestador) {
                return prestadorService.buscarPorId(idPrestador)
                                .map(PrestadorPerfilDTO::fromEntity)
                                .map(ResponseEntity::ok)
                                .orElse(ResponseEntity.notFound().build());
        }

        @Operation(summary = "Desabilita servico", description = "Desabilita um servico", responses = {
                        @ApiResponse(responseCode = "200", description = "servico desabilitado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "servico não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @PutMapping("/desabilitar/{idServico}")
        public ResponseEntity<ServicoSimplesDTO> desabilitarServico(
                        @Parameter(description = "Id do servico") @PathVariable Long idServico) {
                Optional<Servico> servico = servicoService.buscarPorId(idServico);
                if (servico.isPresent()) {
                        servico.get().setAtivo(false);
                        servicoService.atualizarServico(idServico, servico.get());
                        return ResponseEntity.ok(ServicoSimplesDTO.fromEntity(servico.get()));
                } else {
                        return ResponseEntity.notFound().build();
                }
        }

        @Operation(summary = "Atualiza Prestador", description = "Atualiza Prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "Prestador atualizado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @PutMapping("/{idPrestador}")
        public ResponseEntity<AtualizarPrestadorDTO> AtualizarPrestador(
                        @Parameter(description = "Id do servico") @PathVariable Long idPrestador,
                        @Parameter(description = "Dados do prestador") @RequestBody AtualizarPrestadorDTO atualizarPrestadorDTO) {
                prestadorService.atualizarPrestador(idPrestador, atualizarPrestadorDTO);
                return ResponseEntity.ok(atualizarPrestadorDTO);
        }
}
