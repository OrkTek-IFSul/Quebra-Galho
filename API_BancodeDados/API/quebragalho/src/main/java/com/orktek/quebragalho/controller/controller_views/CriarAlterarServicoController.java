package com.orktek.quebragalho.controller.controller_views;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.dto.ServicoDTO.ServicoDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.service.ServicoService;
import com.orktek.quebragalho.service.TagService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.persistence.EntityNotFoundException;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

@Tag(name = "Criar e Alterar Serviços", description = "Operações relacionadas a criação e ateração de serviços")
@RestController
@RequestMapping("/api/prestador/servico")
public class CriarAlterarServicoController {
        @Autowired
        private ServicoService servicoService;

        @Autowired
        private TagService tagService;

        @Autowired
        private PrestadorRepository prestadorRepository;
        
        @Operation(summary = "Cria um serviço vinculado a um prestador", description = "Cria um serviço vinculado a um prestador", responses = {
                        @ApiResponse(responseCode = "200", description = "Servico criado com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Prestador não encontrados"),
                        @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
        })
        @PostMapping("/{idPrestador}")
        public ResponseEntity<ServicoDTO> criarServico(
                        @Parameter(description = "Id do prestador") @PathVariable Long idPrestador,
                        @Parameter(description = "Dados do serviço") @RequestBody ServicoDTO servicoDTO) {
                // Cria o serviço
                Servico servico = new Servico();
                servico.setNome(servicoDTO.getNome());
                servico.setDescricao(servicoDTO.getDescricao());
                servico.setPreco(servicoDTO.getPreco());
                servico.setAtivo(true);
                servico.setDuracaoMinutos(servicoDTO.getDuracaoMinutos());
                
                // Adiciona as tags do DTO em uma lista para o serviço
                List<Tags> tagsSalvar = new ArrayList<>();
                if (servicoDTO.getTags() != null) {
                        servicoDTO.getTags().forEach(tagDTO -> {
                                tagService.buscarPorId(tagDTO.getId()).ifPresent(tagsSalvar::add);
                        });
                }
                servico.setTags(tagsSalvar);

                // Salva o serviço
                Servico servicoCriado = servicoService.criarServico(servico, idPrestador);

                // Adiciona as tags do serviço ao prestador, sem duplicar
                Prestador prestador = servicoCriado.getPrestador();
                if (prestador != null && tagsSalvar != null && !tagsSalvar.isEmpty()) {
                        if (prestador.getTags() == null) {
                                prestador.setTags(new ArrayList<>());
                        }
                        for (Tags tag : tagsSalvar) {
                                boolean jaPossui = prestador.getTags().stream()
                                        .anyMatch(t -> t.getNome().equalsIgnoreCase(tag.getNome()));
                                if (!jaPossui) {
                                        prestador.getTags().add(tag);
                                }
                        }
                        // Salva o prestador atualizado
                        prestadorRepository.save(prestador);
                }

                // Converte para DTO e retorna
                ServicoDTO resposta = ServicoDTO.fromEntity(servicoCriado);
                return ResponseEntity.ok(resposta);
        }

                @Operation(summary = "Atualiza um serviço do prestador", description = "Atualiza os dados de um serviço existente vinculado a um prestador", responses = {
                                @ApiResponse(responseCode = "200", description = "Serviço atualizado com sucesso"),
                                @ApiResponse(responseCode = "404", description = "Prestador ou serviço não encontrado"),
                                @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
                })
                @PutMapping("/{idPrestador}/{idServico}")
                public ResponseEntity<ServicoDTO> atualizarServico(
                                @Parameter(description = "ID do prestador") @PathVariable Long idPrestador,
                                @Parameter(description = "ID do serviço") @PathVariable Long idServico,
                                @Parameter(description = "Dados atualizados do serviço") @RequestBody ServicoDTO servicoDTO) {

                        // Verifica se o serviço existe e pertence ao prestador
                        Servico servicoExistente = servicoService.buscarPorIdEPrestador(idServico, idPrestador)
                                        .orElseThrow(() -> new EntityNotFoundException(
                                                        "Serviço não encontrado para este prestador"));

                        // Guarda a tag antiga (se houver)
                        final Tags tagAntiga;
                        if (servicoExistente.getTags() != null && !servicoExistente.getTags().isEmpty()) {
                                tagAntiga = servicoExistente.getTags().get(0);
                        } else {
                                tagAntiga = null;
                        }

                        // Atualiza os dados básicos
                        servicoExistente.setNome(servicoDTO.getNome());
                        servicoExistente.setDescricao(servicoDTO.getDescricao());
                        servicoExistente.setPreco(servicoDTO.getPreco());
                        servicoExistente.setDuracaoMinutos(servicoDTO.getDuracaoMinutos());

                        // Adiciona as tags do DTO em uma lista para o serviço
                        List<Tags> tagsAtualizadas = new ArrayList<>();
                        final Tags tagNova;
                        if (servicoDTO.getTags() != null && !servicoDTO.getTags().isEmpty()) {
                                // Considera apenas a primeira tag como "nova" para lógica de atualização
                                tagNova = tagService.buscarPorId(servicoDTO.getTags().get(0).getId()).orElse(null);
                                // Adiciona todas as tags do DTO ao serviço
                                servicoDTO.getTags().forEach(tagDTO -> {
                                        tagService.buscarPorId(tagDTO.getId()).ifPresent(tagsAtualizadas::add);
                                });
                        } else {
                                tagNova = null;
                        }
                        servicoExistente.setTags(tagsAtualizadas);

                        // Persiste as alterações
                        Servico servicoAtualizado = servicoService.atualizarServico(idServico, servicoExistente);

                        // Atualiza as tags do prestador
                        Prestador prestador = servicoAtualizado.getPrestador();
                        if (prestador != null) {
                                // Remove a tag antiga do prestador se nenhum outro serviço dele usar essa tag
                                if (tagAntiga != null && (tagNova == null || !tagAntiga.getId().equals(tagNova.getId()))) {
                                        boolean algumOutroServicoUsaTagAntiga = prestador.getServicos().stream()
                                                .filter(s -> !s.getId().equals(servicoAtualizado.getId()))
                                                .anyMatch(s -> s.getTags() != null && s.getTags().stream()
                                                        .anyMatch(t -> t.getId().equals(tagAntiga.getId())));
                                        if (!algumOutroServicoUsaTagAntiga) {
                                                if (prestador.getTags() != null) {
                                                        prestador.getTags().removeIf(t -> t.getId().equals(tagAntiga.getId()));
                                                }
                                        }
                                }
                                // Adiciona a tag nova ao prestador se ainda não estiver presente
                                if (tagNova != null) {
                                        boolean jaPossui = prestador.getTags() != null &&
                                                prestador.getTags().stream().anyMatch(t -> t.getId().equals(tagNova.getId()));
                                        if (!jaPossui) {
                                                if (prestador.getTags() == null) {
                                                        prestador.setTags(new ArrayList<>());
                                                }
                                                prestador.getTags().add(tagNova);
                                        }
                                }
                                prestadorRepository.save(prestador);
                        }

                        // Converte para DTO e retorna
                        ServicoDTO resposta = ServicoDTO.fromEntity(servicoAtualizado);
                        return ResponseEntity.ok(resposta);
                }
        }
