package com.orktek.quebragalho.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.service.TagService;

import java.util.List;

/**
 * Controller para gerenciamento de tags/categorias
 */
@RestController
@RequestMapping("/api/tags")
@Tag(name = "Tags", description = "Gerenciamento de tags/categorias")
public class TagController {

    @Autowired
    private TagService tagService;

    /**
     * Cria uma nova tag
     * POST /api/tags
     */
    @Operation(summary = "Cria uma nova tag", description = "Cria uma nova tag com nome e status fornecidos.")
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
     * Lista todas as tags ativas
     * GET /api/tags
     */
    @Operation(summary = "Lista todas as tags ativas", description = "Retorna uma lista de todas as tags com status ativo.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de tags retornada com sucesso"),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
    })
    @GetMapping
    public ResponseEntity<List<Tags>> listarTodas() {
        List<Tags> tags = tagService.listarTodas();
        return ResponseEntity.ok(tags); // 200 OK
    }

    /**
     * Atualiza status de uma tag
     * PUT /api/tags/{id}/status
     */
    @Operation(summary = "Atualiza status de uma tag", description = "Atualiza o status de uma tag existente com base no ID.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Tag atualizada com sucesso"),
        @ApiResponse(responseCode = "404", description = "Tag não encontrada"),
        @ApiResponse(responseCode = "400", description = "Requisição inválida")
    })
    @PutMapping("/{id}/status")
    public ResponseEntity<Tags> atualizarStatus(
            @Parameter(description = "ID da tag a ser atualizada", required = true)
            @PathVariable Long id,
            @Parameter(description = "Dados atualizados da tag", required = true)
            @RequestParam Tags tagAtualizada) {
        Tags tag = tagService.atualizarTag(id, tagAtualizada);
        return ResponseEntity.ok(tag); // 200 OK
    }
}