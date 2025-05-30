package com.orktek.quebragalho.controller.controller_generica;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.service.TagServicoService;

import java.util.List;

/**
 * Controller específico para gestão do relacionamento entre tags e serviços
 */
@RestController
@RequestMapping("/api/tag-servico")
// @Tag(name = "TagServico", description = "Gerenciamento do relacionamento
// entre tags e serviços")
public class TagServicoController {

    @Autowired
    private TagServicoService tagServicoService;

    /**
     * Adiciona tag a um serviço
     * POST /api/tag-servico/{tagId}/{servicoId}
     */
    @PostMapping("/{tagId}/{servicoId}")
    // @Operation(
    // summary = "Adiciona uma tag a um serviço",
    // description = "Associa uma tag existente a um serviço específico pelo ID.",
    // responses = {
    // @ApiResponse(responseCode = "200", description = "Tag adicionada com
    // sucesso"),
    // @ApiResponse(responseCode = "400", description = "Requisição inválida"),
    // @ApiResponse(responseCode = "404", description = "Tag ou serviço não
    // encontrado")
    // }
    // )
    public ResponseEntity<Void> adicionarTag(
            @Parameter(description = "ID da tag a ser associada", required = true) @PathVariable Long tagId,
            @Parameter(description = "ID do serviço ao qual a tag será associada", required = true) @PathVariable Long servicoId) {
        tagServicoService.adicionarTagAoServico(tagId, servicoId);
        return ResponseEntity.ok().build();
    }

    /**
     * Remove tag de um serviço
     * DELETE /api/tag-servico/{tagId}/{servicoId}
     */
    @DeleteMapping("/{tagId}/{servicoId}")
    // @Operation(
    // summary="Remove uma tag de um serviço",description="Desassocia uma tag de um serviço específico pelo ID.",responses=

    // {
    //         @ApiResponse(responseCode = "204", description = "Tag removida com sucesso"),
    //         @ApiResponse(responseCode = "400", description = "Requisição inválida"),
    //         @ApiResponse(responseCode = "404", description = "Tag ou serviço não encontrado")
    //     })

    public ResponseEntity<Void> removerTag(
            @Parameter(description = "ID da tag a ser removida", required = true) @PathVariable Long tagId,
            @Parameter(description = "ID do serviço do qual a tag será removida", required = true) @PathVariable Long servicoId) {
        tagServicoService.removerTagDoServico(tagId, servicoId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Lista tags de um serviço
     * GET /api/tag-servico/servico/{servicoId}
     */
    @GetMapping("/servico/{servicoId}")
    // @Operation(
    // summary="Lista tags de um serviço",description="Retorna uma lista de IDs de tags associadas a um serviço específico.",responses=

    // {
    //         @ApiResponse(responseCode = "200", description = "Lista de tags retornada com sucesso"),
    //         @ApiResponse(responseCode = "400", description = "Requisição inválida"),
    //         @ApiResponse(responseCode = "404", description = "Serviço não encontrado")
    //     })

    public ResponseEntity<List<Long>> listarTagsPorServico(
            @Parameter(description = "ID do serviço cujas tags serão listadas", required = true) @PathVariable Long servicoId) {
        List<Long> tags = tagServicoService.listarTagsPorServico(servicoId);
        return ResponseEntity.ok(tags);
    }
}