package com.orktek.quebragalho.controller.controller_generica;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.service.TagService;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller para gerenciamento de tags/categorias
 */
@RestController
@RequestMapping("/api/tags")
// @Tag(name = "Tags", description = "Gerenciamento de tags/categorias")
public class TagController {

    @Autowired
    private TagService tagService;

    /**
     * Cria uma nova tag
     * POST /api/tags
     */
    //@Operation(summary = "Cria uma nova tag", description = "Cria uma nova tag com nome e status fornecidos.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Tag criada com sucesso"),
            @ApiResponse(responseCode = "400", description = "Requisição inválida")
    })
    @PostMapping
    public ResponseEntity<Tags> criarTag(@RequestBody Tags tag) {
        Tags novaTag = tagService.criarTag(tag);
        return ResponseEntity.status(201).body(novaTag); // 201 Created
    }

    /**
     * Busca uma tag específica por ID
     * GET /api/tags/{id}
     */
    //@Operation(summary = "Buscar tag por ID", description = "Retorna os detalhes completos de uma tag específica")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Tag encontrada com sucesso", content = @Content(schema = @Schema(implementation = TagDTO.class))),
            @ApiResponse(responseCode = "404", description = "Tag não encontrada"),
            @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
    })
    @GetMapping("/{id}")
    public ResponseEntity<TagDTO> buscarPorId(
            @Parameter(description = "ID da tag a ser buscada", required = true, example = "1") @PathVariable Long id) {

        Tags tag = tagService.buscarPorId(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag não encontrada"));
        
        TagDTO tagDTO = new TagDTO();
        tagDTO.setId(tag.getId());
        tagDTO.setNome(tag.getNome()); 

        return ResponseEntity.ok(tagDTO); // 200 OK
    }

    /**
     * Lista todas as tags ativas
     * GET /api/tags
     */
    //@Operation(summary = "Lista todas as tags ativas", description = "Retorna uma lista de todas as tags com status 'Ativo'")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista de tags retornada com sucesso", content = @Content(array = @ArraySchema(schema = @Schema(implementation = TagDTO.class)))),
            @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
    })
    @GetMapping
    public ResponseEntity<List<TagDTO>> listarTodasAtivas() {
        List<TagDTO> tagsAtivas = tagService.listarTodasAtivas()
                .stream()
                .map(TagDTO::fromEntity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(tagsAtivas);
    }

    /**
     * Atualiza status de uma tag
     * PUT /api/tags/{id}/status
     */
    //@Operation(summary = "Atualiza status de uma tag", description = "Atualiza o status de uma tag existente com base no ID.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Tag atualizada com sucesso"),
            @ApiResponse(responseCode = "404", description = "Tag não encontrada"),
            @ApiResponse(responseCode = "400", description = "Requisição inválida")
    })
    @PutMapping("/{id}/status")
    public ResponseEntity<Tags> atualizarStatus(
            @Parameter(description = "ID da tag a ser atualizada", required = true) @PathVariable Long id,
            @Parameter(description = "Dados atualizados da tag", required = true) @RequestParam Tags tagAtualizada) {
        Tags tag = tagService.atualizarTag(id, tagAtualizada);
        return ResponseEntity.ok(tag); // 200 OK
    }
}