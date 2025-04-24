package com.orktek.quebragalho.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.service.PrestadorService;

import java.util.List;

/**
 * Controller para operações com prestadores de serviço
 */
@RestController
@RequestMapping("/api/prestadores")
@Tag(name = "Prestadores", description = "Operações relacionadas aos prestadores de serviço")
public class PrestadorController {

    @Autowired
    private PrestadorService prestadorService;

    /**
     * Lista todos os prestadores
     * GET /api/prestadores
     */
    @Operation(summary = "Lista todos os prestadores", description = "Retorna uma lista de todos os prestadores cadastrados.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Lista de prestadores retornada com sucesso")
    })
    @GetMapping
    public ResponseEntity<List<Prestador>> listarTodos() {
        List<Prestador> prestadores = prestadorService.listarTodos();
        return ResponseEntity.ok(prestadores);
    }

    /**
     * Busca prestador por ID
     * GET /api/prestadores/{id}
     */
    @Operation(summary = "Busca prestador por ID", description = "Retorna os detalhes de um prestador específico pelo ID.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Prestador encontrado com sucesso"),
        @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
    })
    @GetMapping("/{id}")
    public ResponseEntity<Prestador> buscarPorId(
            @Parameter(description = "ID do prestador a ser buscado", required = true)
            @PathVariable Long id) {
        return prestadorService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Cria novo prestador associado a um usuário
     * POST /api/prestadores/{usuarioId}
     */
    @Operation(summary = "Cria novo prestador", description = "Cria um novo prestador associado a um usuário.")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Prestador criado com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
    })
    @PostMapping("/{usuarioId}")
    public ResponseEntity<Prestador> criarPrestador(
            @Parameter(description = "ID do usuário ao qual o prestador será associado", required = true)
            @PathVariable Long usuarioId,
            @RequestBody Prestador prestador) {
        Prestador novoPrestador = prestadorService.criarPrestador(prestador, usuarioId);
        return ResponseEntity.status(201).body(novoPrestador);
    }

    /**
     * Atualiza dados do prestador
     * PUT /api/prestadores/{id}
     */
    @Operation(summary = "Atualiza dados do prestador", description = "Atualiza as informações de um prestador existente.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Prestador atualizado com sucesso"),
        @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
    })
    @PutMapping("/{id}")
    public ResponseEntity<Prestador> atualizarPrestador(
            @Parameter(description = "ID do prestador a ser atualizado", required = true)
            @PathVariable Long id,
            @RequestBody Prestador prestador) {
        Prestador atualizado = prestadorService.atualizarPrestador(id, prestador);
        return ResponseEntity.ok(atualizado);
    }

    /**
     * Remove um prestador
     * DELETE /api/prestadores/{id}
     */
    @Operation(summary = "Remove um prestador", description = "Remove um prestador pelo ID.")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Prestador removido com sucesso"),
        @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarPrestador(
            @Parameter(description = "ID do prestador a ser removido", required = true)
            @PathVariable Long id) {
        prestadorService.deletarPrestador(id);
        return ResponseEntity.noContent().build();
    }
}