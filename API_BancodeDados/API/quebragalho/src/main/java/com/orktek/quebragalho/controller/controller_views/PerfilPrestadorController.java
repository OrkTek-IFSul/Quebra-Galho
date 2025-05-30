package com.orktek.quebragalho.controller.controller_views;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.PrestadorDTO.AtualizarPrestadorDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorPerfilDTO;
import com.orktek.quebragalho.dto.ServicoDTO.ServicoSimplesDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.PrestadorRepository;
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
        @Autowired
        private PrestadorRepository prestadorRepository;

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

        @Operation(summary = "Desabilita servico", description = "Desabilita um servico e remove tags não utilizadas do prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "servico desabilitado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "servico não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor") })
        @PutMapping("/desabilitar/{idServico}")
        public ResponseEntity<ServicoSimplesDTO> desabilitarServico(
                        @Parameter(description = "Id do servico") @PathVariable Long idServico) {
                Optional<Servico> servico = servicoService.buscarPorId(idServico);
                if (servico.isPresent()) {
                        Servico servicoEncontrado = servico.get();

                        // Guarda as tags do serviço antes de desabilitar
                        List<Tags> tagsDoServico = new ArrayList<>();
                        if (servicoEncontrado.getTags() != null) {
                                tagsDoServico.addAll(servicoEncontrado.getTags());
                        }

                        // Desabilita o serviço
                        servicoEncontrado.setAtivo(false);
                        servicoService.atualizarServico(idServico, servicoEncontrado);

                        // Remove tags que não são mais utilizadas pelo prestador
                        if (!tagsDoServico.isEmpty()) {
                                removerTagsNaoUtilizadas(servicoEncontrado.getPrestador(), tagsDoServico);
                        }

                        return ResponseEntity.ok(ServicoSimplesDTO.fromEntity(servicoEncontrado));
                } else {
                        return ResponseEntity.notFound().build();
                }
        }

        /**
         * Remove tags do prestador que não são mais utilizadas por nenhum serviço ativo
         * 
         * @param prestador         Prestador que pode ter tags removidas
         * @param tagsParaVerificar Lista de tags para verificar se ainda são utilizadas
         */
        private void removerTagsNaoUtilizadas(Prestador prestador, List<Tags> tagsParaVerificar) {
                if (prestador.getTags() == null || prestador.getTags().isEmpty()) {
                        return;
                }

                // Busca todos os serviços ATIVOS do prestador
                List<Servico> servicosAtivos = servicoService.buscarServicosPorPrestadorEStatus(prestador.getId(),
                                true);

                // Coleta todas as tags dos serviços ativos
                Set<String> tagsEmUso = servicosAtivos.stream()
                                .filter(servico -> servico.getTags() != null)
                                .flatMap(servico -> servico.getTags().stream())
                                .map(tag -> tag.getNome().toLowerCase())
                                .collect(Collectors.toSet());

                // Remove do prestador apenas as tags que não estão mais em uso
                List<Tags> tagsParaRemover = new ArrayList<>();
                for (Tags tagParaVerificar : tagsParaVerificar) {
                        if (!tagsEmUso.contains(tagParaVerificar.getNome().toLowerCase())) {
                                // Esta tag não está sendo usada por nenhum serviço ativo
                                tagsParaRemover.add(tagParaVerificar);
                        }
                }

                // Remove as tags não utilizadas do prestador
                if (!tagsParaRemover.isEmpty()) {
                        prestador.getTags().removeIf(tag -> tagsParaRemover.stream()
                                        .anyMatch(tagRemover -> tagRemover.getNome().equalsIgnoreCase(tag.getNome())));

                        // Salva o prestador atualizado
                        prestadorRepository.save(prestador);

                        // Log para debug (opcional)
                        System.out.println("Tags removidas do prestador " + prestador.getId() + ": " +
                                        tagsParaRemover.stream().map(Tags::getNome).collect(Collectors.joining(", ")));
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
