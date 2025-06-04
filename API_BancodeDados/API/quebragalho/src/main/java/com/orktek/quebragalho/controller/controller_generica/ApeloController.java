package com.orktek.quebragalho.controller.controller_generica;

// import java.util.List;
// import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

// import com.orktek.quebragalho.dto.ApeloDTO;
import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.service.ApeloService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

/**
 * Controller para gerenciamento de apelos a denúncias
 */
@RestController
@RequestMapping("/api/apelos")
// @Tag(name = "Apelos", description = "Gerenciamento de apelos a denúncias")
public class ApeloController {

    @Autowired
    private ApeloService apeloService;

    /**
     * Cria um novo apelo para uma denúncia
     * POST /api/apelos/{denunciaId}
     */
    // @Operation(summary = "Cria um novo apelo", description = "Cria um apelo para uma denúncia específica")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Apelo criado com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos"),
        @ApiResponse(responseCode = "404", description = "Denúncia não encontrada")
    })
    @PostMapping("/{denunciaId}")
    public ResponseEntity<Apelo> criarApelo(
            @Parameter(description = "ID da denúncia para a qual o apelo será criado", required = true)
            @PathVariable Long denunciaId,
            @RequestBody Apelo apelo) {
        Apelo novoApelo = apeloService.criarApelo(apelo, denunciaId);
        return ResponseEntity.status(201).body(novoApelo); // 201 Created
    }

    // /**
    //  * Lista todos os apelos pendentes
    //  * GET /api/apelos/pendentes
    //  */
    // @Operation(summary = "Lista apelos pendentes", description = "Retorna uma lista de todos os apelos pendentes")
    // @ApiResponses({
    //     @ApiResponse(responseCode = "200", description = "Lista de apelos pendentes retornada com sucesso")
    // })
    // @GetMapping("/pendentes")
    // public ResponseEntity<List<ApeloDTO>> listarPendentes() {
    //     List<ApeloDTO> apelos = apeloService.listarPendentes()
    //     .stream().map(ApeloDTO::new)
    //     .collect(Collectors.toList());
    //     return ResponseEntity.ok(apelos); // 200 OK
    // }

    /**
     * Resolve um apelo (aceita ou rejeita)
     * PUT /api/apelos/{id}/resolver
     */
    //@Operation(summary = "Resolve um apelo", description = "Aceita ou rejeita um apelo com base no ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Apelo resolvido com sucesso"),
        @ApiResponse(responseCode = "404", description = "Apelo não encontrado")
    })
    @PutMapping("/{id}/resolver")
    public ResponseEntity<Apelo> resolverApelo(
            @Parameter(description = "ID do apelo a ser resolvido", required = true)
            @PathVariable Long id,
            @Parameter(description = "Indica se o apelo será aceito (true) ou rejeitado (false)", required = true)
            @RequestParam boolean aceito) {
        Apelo apelo = apeloService.atualizarStatusApelo(id, aceito);
        return ResponseEntity.ok(apelo); // 200 OK
    }

    // /**
    //  * Busca apelo por ID
    //  * GET /api/apelos/{id}
    //  */
    // //@Operation(summary = "Busca apelo por ID", description = "Retorna os detalhes de um apelo específico pelo ID")
    // @ApiResponses({
    //     @ApiResponse(responseCode = "200", description = "Apelo encontrado"),
    //     @ApiResponse(responseCode = "404", description = "Apelo não encontrado")
    // })
    // @GetMapping("/{id}")
    // public ResponseEntity<ApeloDTO> buscarPorId(
    //         @Parameter(description = "ID do apelo a ser buscado", required = true)
    //         @PathVariable Long id) {
    //     return apeloService.buscarPorId(id)
    //             .map(ApeloDTO::new) 
    //             .map(ResponseEntity::ok) // 200 OK se encontrado
    //             .orElse(ResponseEntity.notFound().build()); // 404 Not Found
    // }
}