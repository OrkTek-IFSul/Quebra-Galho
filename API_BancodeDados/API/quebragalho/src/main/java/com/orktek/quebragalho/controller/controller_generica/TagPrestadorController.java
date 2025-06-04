package com.orktek.quebragalho.controller.controller_generica;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.service.TagPrestadorService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

/**
 * Controller específico para gestão do relacionamento entre tags e prestadores
 */
@RestController
@RequestMapping("/api/tag-prestador")
// @Tag(name = "TagPrestador", description = "Gerenciamento do relacionamento entre tags e prestadores")
public class TagPrestadorController {

    @Autowired
    private TagPrestadorService tagPrestadorService;

    /**
     * Adiciona tag a um prestador
     * POST /api/tag-prestador/{tagId}/{prestadorId}
     */
    @PostMapping("/{tagId}/{prestadorId}")
    //@Operation(summary = "Adiciona uma tag a um prestador", description = "Associa uma tag existente a um prestador específico.")
    @ApiResponse(responseCode = "200", description = "Tag adicionada com sucesso.")
    @ApiResponse(responseCode = "400", description = "Requisição inválida.")
    @ApiResponse(responseCode = "404", description = "Tag ou prestador não encontrado.")
    public ResponseEntity<Void> adicionarTag(
            @Parameter(description = "ID da tag a ser associada", required = true) @PathVariable Long tagId,
            @Parameter(description = "ID do prestador ao qual a tag será associada", required = true) @PathVariable Long prestadorId) {
        tagPrestadorService.adicionarTagAoPrestador(tagId, prestadorId);
        return ResponseEntity.ok().build();
    }

    /**
     * Remove tag de um prestador
     * DELETE /api/tag-prestador/{tagId}/{prestadorId}
     */
    @DeleteMapping("/{tagId}/{prestadorId}")
    //@Operation(summary = "Remove uma tag de um prestador", description = "Desassocia uma tag de um prestador específico.")
    @ApiResponse(responseCode = "204", description = "Tag removida com sucesso.")
    @ApiResponse(responseCode = "400", description = "Requisição inválida.")
    @ApiResponse(responseCode = "404", description = "Tag ou prestador não encontrado.")
    public ResponseEntity<Void> removerTag(
            @Parameter(description = "ID da tag a ser desassociada", required = true) @PathVariable Long tagId,
            @Parameter(description = "ID do prestador do qual a tag será desassociada", required = true) @PathVariable Long prestadorId) {
        tagPrestadorService.removerTagDoPrestador(tagId, prestadorId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Lista tags de um prestador
     * GET /api/tag-prestador/prestador/{prestadorId}
     */
    @GetMapping("/prestador/{prestadorId}")
    //@Operation(summary = "Lista tags de um prestador", description = "Retorna uma lista de IDs de tags associadas a um prestador específico.")
    @ApiResponse(responseCode = "200", description = "Lista de tags retornada com sucesso.")
    @ApiResponse(responseCode = "400", description = "Requisição inválida.")
    @ApiResponse(responseCode = "404", description = "Prestador não encontrado.")
    public ResponseEntity<List<Long>> listarTagsPorPrestador(
            @Parameter(description = "ID do prestador cujas tags serão listadas", required = true) @PathVariable Long prestadorId) {
        List<Long> tags = tagPrestadorService.listarTagsPorPrestador(prestadorId);
        return ResponseEntity.ok(tags);
    }
}