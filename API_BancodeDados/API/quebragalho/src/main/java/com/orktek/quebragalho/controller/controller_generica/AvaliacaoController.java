package com.orktek.quebragalho.controller.controller_generica;
// package com.orktek.quebragalho.controller;

// import java.util.List;
// import java.util.stream.Collectors;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;

// import com.orktek.quebragalho.dto.AvaliacaoDTO;
// import com.orktek.quebragalho.model.Avaliacao;
// import com.orktek.quebragalho.service.AvaliacaoService;

// import io.swagger.v3.oas.annotations.Operation;
// import io.swagger.v3.oas.annotations.tags.Tag;
// import io.swagger.v3.oas.annotations.responses.ApiResponse;
// import io.swagger.v3.oas.annotations.responses.ApiResponses;
// import io.swagger.v3.oas.annotations.Parameter;

// /**
//  * Controller para avaliações de serviços
//  */
// @RestController
// @RequestMapping("/api/avaliacoes")
// @Tag(name = "Avaliações", description = "Gerenciamento de avaliações de serviços")
// public class AvaliacaoController {

//     @Autowired
//     private AvaliacaoService avaliacaoService;

//     /**
//      * Cria nova avaliação para um agendamento
//      * POST /api/avaliacoes/{agendamentoId}
//      * POST Request Body:
//      * {
//      * "nota": 5,
//      * "comentario": "Excelente serviço!",
//      * "data": "2023-10-01",
//      * "agendamento": {
//      * "id": 1
//      * }
//      * }
//      */
//     @PostMapping("/{agendamentoId}")
//     @Operation(summary = "Cria uma nova avaliação", description = "Cria uma avaliação para um agendamento específico")
//     @ApiResponses({
//         @ApiResponse(responseCode = "201", description = "Avaliação criada com sucesso"),
//         @ApiResponse(responseCode = "400", description = "Dados inválidos"),
//         @ApiResponse(responseCode = "404", description = "Agendamento não encontrado")
//     })
//     public ResponseEntity<Avaliacao> criarAvaliacao(
//             @Parameter(description = "ID do agendamento para o qual a avaliação será criada", required = true)
//             @PathVariable Long agendamentoId,
//             @RequestBody Avaliacao avaliacao) {
//         Avaliacao novaAvaliacao = avaliacaoService.criarAvaliacao(avaliacao, agendamentoId);
//         return ResponseEntity.status(201).body(novaAvaliacao);
//     }

//     /**
//      * Lista avaliações de um serviço
//      * GET /api/avaliacoes/servico/{servicoId}
//      */
//     @GetMapping("/servico/{servicoId}")
//     @Operation(summary = "Lista avaliações por serviço", description = "Retorna todas as avaliações de um serviço específico")
//     @ApiResponses({
//         @ApiResponse(responseCode = "200", description = "Lista de avaliações retornada com sucesso"),
//         @ApiResponse(responseCode = "404", description = "Serviço não encontrado")
//     })
//     public ResponseEntity<List<AvaliacaoDTO>> listarPorServico(
//             @Parameter(description = "ID do serviço para listar as avaliações", required = true)
//             @PathVariable Long servicoId) {
//         List<AvaliacaoDTO> avaliacoes = avaliacaoService.listarPorServico(servicoId)
//                 .stream().map(AvaliacaoDTO::new)
//                 .collect(Collectors.toList());
//         return ResponseEntity.ok(avaliacoes);
//     }

//     /**
//      * Remove uma avaliação
//      * DELETE /api/avaliacoes/{id}
//      */
//     @DeleteMapping("/{id}")
//     @Operation(summary = "Remove uma avaliação", description = "Exclui uma avaliação com base no ID fornecido")
//     @ApiResponses({
//         @ApiResponse(responseCode = "204", description = "Avaliação removida com sucesso"),
//         @ApiResponse(responseCode = "404", description = "Avaliação não encontrada")
//     })
//     public ResponseEntity<Void> deletarAvaliacao(
//             @Parameter(description = "ID da avaliação a ser removida", required = true)
//             @PathVariable Long id) {
//         avaliacaoService.deletarAvaliacao(id);
//         return ResponseEntity.noContent().build();
//     }
// }
