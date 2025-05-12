package com.orktek.quebragalho.controller.controller_views;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.orktek.quebragalho.dto.ServicoDTO.ServicoDTO;
import com.orktek.quebragalho.model.Servico;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.service.ServicoService;

import io.swagger.v3.oas.annotations.Operation;
import jakarta.persistence.EntityNotFoundException;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.parameters.RequestBody;

@Tag(name = "Criar e Alterar Serviços", description = "Operações relacionadas a criação e ateração de serviços")
@RestController
@RequestMapping("/api/prestador/servico")
public class CriarAlterarServicoController {
    @Autowired
    private ServicoService servicoService;

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
        // Salva as Tags
        List<Tags> tags = servicoDTO.getTags().stream()
                .map(tagDTO -> {
                    Tags tag = new Tags();
                    tag.setId(tagDTO.getId());
                    tag.setNome(tagDTO.getNome());
                    return tag;
                })
                .collect(Collectors.toList());
        servico.setTags(tags);
        // Salva o serviço
        servicoService.criarServico(servico, idPrestador);

        return ResponseEntity.ok(servicoDTO);
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
                .orElseThrow(() -> new EntityNotFoundException("Serviço não encontrado para este prestador"));

        // Atualiza os dados básicos
        servicoExistente.setNome(servicoDTO.getNome());
        servicoExistente.setDescricao(servicoDTO.getDescricao());
        servicoExistente.setPreco(servicoDTO.getPreco());

        // Atualiza as tags
        List<Tags> tagsAtualizadas = servicoDTO.getTags().stream()
                .map(tagDTO -> {
                    Tags tag = new Tags();
                    tag.setId(tagDTO.getId());
                    tag.setNome(tagDTO.getNome());
                    return tag;
                })
                .collect(Collectors.toList());

        servicoExistente.setTags(tagsAtualizadas);

        // Persiste as alterações
        Servico servicoAtualizado = servicoService.atualizarServico(idServico, servicoExistente);

        // Converte para DTO e retorna
        ServicoDTO resposta = ServicoDTO.fromEntity(servicoAtualizado);
        return ResponseEntity.ok(resposta);
    }
}
