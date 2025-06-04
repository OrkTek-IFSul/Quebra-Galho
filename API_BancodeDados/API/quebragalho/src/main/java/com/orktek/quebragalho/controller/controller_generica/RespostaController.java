package com.orktek.quebragalho.controller.controller_generica;
// package com.orktek.quebragalho.controller;

// import io.swagger.v3.oas.annotations.Operation;
// import io.swagger.v3.oas.annotations.tags.Tag;
// import io.swagger.v3.oas.annotations.responses.ApiResponse;
// import io.swagger.v3.oas.annotations.responses.ApiResponses;
// import io.swagger.v3.oas.annotations.Parameter;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;

// import com.orktek.quebragalho.dto.RespostaDTO;
// import com.orktek.quebragalho.model.Resposta;
// import com.orktek.quebragalho.service.RespostaService;

// /**
//  * Controller para respostas às avaliações
//  */
// @RestController
// @RequestMapping("/api/respostas")
// @Tag(name = "Respostas", description = "Endpoints para gerenciar respostas às avaliações")
// public class RespostaController {

//     @Autowired
//     private RespostaService respostaService;

//     /**
//      * Cria resposta para uma avaliação
//      * POST /api/respostas/{avaliacaoId}
//      */
//     @Operation(summary = "Cria uma nova resposta", description = "Cria uma resposta para uma avaliação específica")
//     @ApiResponses(value = {
//         @ApiResponse(responseCode = "201", description = "Resposta criada com sucesso"),
//         @ApiResponse(responseCode = "400", description = "Dados inválidos"),
//         @ApiResponse(responseCode = "404", description = "Avaliação não encontrada")
//     })
//     @PostMapping("/{avaliacaoId}")
//     public ResponseEntity<Resposta> criarResposta(
//             @Parameter(description = "ID da avaliação para a qual a resposta será criada", required = true)
//             @PathVariable Long avaliacaoId,
//             @Parameter(description = "Dados da resposta a ser criada", required = true)
//             @RequestBody Resposta resposta) {
//         Resposta novaResposta = respostaService.criarResposta(resposta, avaliacaoId);
//         return ResponseEntity.status(201).body(novaResposta); // 201 Created
//     }

//     /**
//      * Busca resposta por ID da avaliação
//      * GET /api/respostas/avaliacao/{avaliacaoId}
//      */
//     @Operation(summary = "Busca resposta por ID da avaliação", description = "Retorna a resposta associada a uma avaliação específica")
//     @ApiResponses(value = {
//         @ApiResponse(responseCode = "200", description = "Resposta encontrada"),
//         @ApiResponse(responseCode = "404", description = "Resposta não encontrada")
//     })
//     @GetMapping("/avaliacao/{avaliacaoId}")
//     public ResponseEntity<RespostaDTO> buscarPorAvaliacao(
//             @Parameter(description = "ID da avaliação para buscar a resposta", required = true)
//             @PathVariable Long avaliacaoId) {
//         return respostaService.buscarPorAvaliacao(avaliacaoId)
//                 .map(RespostaDTO::new) 
//                 .map(ResponseEntity::ok) // 200 OK se encontrado
//                 .orElse(ResponseEntity.notFound().build()); // 404 Not Found
//     }

//     /**
//      * Atualiza uma resposta existente
//      * PUT /api/respostas/{id}
//      */
//     @Operation(summary = "Atualiza uma resposta", description = "Atualiza os dados de uma resposta existente")
//     @ApiResponses(value = {
//         @ApiResponse(responseCode = "200", description = "Resposta atualizada com sucesso"),
//         @ApiResponse(responseCode = "400", description = "Dados inválidos"),
//         @ApiResponse(responseCode = "404", description = "Resposta não encontrada")
//     })
//     @PutMapping("/{id}")
//     public ResponseEntity<Resposta> atualizarResposta(
//             @Parameter(description = "ID da resposta a ser atualizada", required = true)
//             @PathVariable Long id,
//             @Parameter(description = "Dados atualizados da resposta", required = true)
//             @RequestBody String resposta) {
//         Resposta atualizada = respostaService.atualizarResposta(id, resposta);
//         return ResponseEntity.ok(atualizada); // 200 OK
//     }

//     /**
//      * Remove uma resposta
//      * DELETE /api/respostas/{id}
//      */
//     @Operation(summary = "Remove uma resposta", description = "Exclui uma resposta existente pelo ID")
//     @ApiResponses(value = {
//         @ApiResponse(responseCode = "204", description = "Resposta removida com sucesso"),
//         @ApiResponse(responseCode = "404", description = "Resposta não encontrada")
//     })
//     @DeleteMapping("/{id}")
//     public ResponseEntity<Void> deletarResposta(
//             @Parameter(description = "ID da resposta a ser removida", required = true)
//             @PathVariable Long id) {
//         respostaService.deletarResposta(id);
//         return ResponseEntity.noContent().build(); // 204 No Content
//     }
// }