package com.orktek.quebragalho.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.orktek.quebragalho.dto.PortfolioDTO;
import com.orktek.quebragalho.model.Portfolio;
import com.orktek.quebragalho.service.PortfolioService;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller para portfólios de prestadores
 */
@RestController
@RequestMapping("/api/portfolio")
@Tag(name = "Portfolio", description = "Gerenciamento do portfólio de prestadores")
public class PortfolioController {

    @Autowired
    private PortfolioService portfolioService;

    /**
     * Adiciona item ao portfólio
     * POST /api/portfolio/{prestadorId}
     */
    @PostMapping("/{prestadorId}")
    @Operation(summary = "Adiciona item ao portfólio", description = "Adiciona um novo item ao portfólio de um prestador")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Item adicionado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Erro na requisição"),
            @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
    })
    public ResponseEntity<Portfolio> adicionarItem(
            @Parameter(description = "ID do prestador", required = true) @PathVariable Long prestadorId,
            @Parameter(description = "Arquivo a ser adicionado ao portfólio", required = true) @RequestParam("file") MultipartFile arquivo) {
        Portfolio item = portfolioService.adicionarAoPortfolio(arquivo, prestadorId);
        return ResponseEntity.status(201).body(item);
    }

    /**
     * Lista itens do portfólio de um prestador
     * GET /api/portfolio/prestador/{prestadorId}
     */
    @GetMapping("/prestador/{prestadorId}")
    @Operation(summary = "Lista itens do portfólio", description = "Lista todos os itens do portfólio de um prestador")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Itens listados com sucesso"),
            @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
            @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
    })
    public ResponseEntity<List<PortfolioDTO>> listarPorPrestador(
            @Parameter(description = "ID do prestador", required = true) @PathVariable Long prestadorId) {
        List<PortfolioDTO> itens = portfolioService.listarPorPrestador(prestadorId)
                .stream().map(PortfolioDTO::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(itens);
    }

    /**
     * Remove item do portfólio
     * DELETE /api/portfolio/{id}
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Remove item do portfólio", description = "Remove um item do portfólio pelo ID")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Item removido com sucesso"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado"),
            @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
    })
    public ResponseEntity<Void> removerItem(
            @Parameter(description = "ID do item a ser removido", required = true) @PathVariable Long id) {
        portfolioService.removerDoPortfolio(id);
        return ResponseEntity.noContent().build();
    }
}
