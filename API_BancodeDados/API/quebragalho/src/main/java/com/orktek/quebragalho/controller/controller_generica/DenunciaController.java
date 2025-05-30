package com.orktek.quebragalho.controller.controller_generica;
// package com.orktek.quebragalho.controller;

// import java.util.List;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;

// import com.orktek.quebragalho.dto.DenunciaDTO;
// import com.orktek.quebragalho.model.Denuncia;
// import com.orktek.quebragalho.service.DenunciaService;

// import io.swagger.v3.oas.annotations.Operation;
// import io.swagger.v3.oas.annotations.tags.Tag;
// import io.swagger.v3.oas.annotations.responses.ApiResponse;
// import io.swagger.v3.oas.annotations.responses.ApiResponses;
// import io.swagger.v3.oas.annotations.Parameter;

// /**
//  * Controller para denúncias no sistema
//  */
// @RestController
// @RequestMapping("/api/denuncias")
// @Tag(name = "Denúncias", description = "Gerenciamento de denúncias no sistema")
// public class DenunciaController {

//     @Autowired
//     private DenunciaService denunciaService;

//     /**
//      * Cria nova denúncia
//      * POST /api/denuncias
//      * POST Request Body Example:
//      * {
//      * "tipo": "Spam",
//      * "motivo": "Publicação repetitiva",
//      * "status": true,
//      * "idComentario": 123,
//      * "denunciante": {
//      * "id": 1
//      * },
//      * "denunciado": {
//      * "id": 2
//      * }
//      * }
//      */
//     @PostMapping
//     @Operation(summary = "Cria uma nova denúncia", description = "Cria uma denúncia associando um denunciante e um denunciado.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "201", description = "Denúncia criada com sucesso"),
//             @ApiResponse(responseCode = "400", description = "Requisição inválida")
//     })
//     public ResponseEntity<Denuncia> criarDenuncia(
//             @Parameter(description = "ID do denunciante") @RequestParam Long denuncianteId,
//             @Parameter(description = "ID do denunciado") @RequestParam Long denunciadoId,
//             @RequestBody Denuncia denuncia) {
//         Denuncia novaDenuncia = denunciaService.criarDenuncia(denuncia, denuncianteId, denunciadoId);
//         return ResponseEntity.status(201).body(novaDenuncia);
//     }

//     /**
//      * Lista denúncias pendentes
//      * GET /api/denuncias/pendentes
//      */
//     @GetMapping("/pendentes")
//     @Operation(summary = "Lista denúncias pendentes", description = "Retorna uma lista de todas as denúncias que estão pendentes.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "200", description = "Lista de denúncias pendentes retornada com sucesso"),
//             @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
//     })
//     public ResponseEntity<List<DenunciaDTO>> listarPendentes() {
//         List<DenunciaDTO> denuncias = denunciaService.listarPendentes()
//                 .stream()
//                 .map(DenunciaDTO::new) // Converte para DTO
//                 .toList(); // Coleta em uma lista
//         return ResponseEntity.ok(denuncias);
//     }

//     /**
//      * Resolve uma denúncia
//      * PUT /api/denuncias/{id}/resolver
//      */
//     @PutMapping("/{id}/resolver")
//     @Operation(summary = "Resolve uma denúncia", description = "Atualiza o status de uma denúncia para resolvida.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "200", description = "Denúncia resolvida com sucesso"),
//             @ApiResponse(responseCode = "404", description = "Denúncia não encontrada")
//     })
//     public ResponseEntity<Denuncia> resolverDenuncia(
//             @Parameter(description = "ID da denúncia a ser resolvida") @PathVariable Long id) {
//         Denuncia denuncia = denunciaService.atualizarStatusDenuncia(id, true);
//         return ResponseEntity.ok(denuncia);
//     }
// }