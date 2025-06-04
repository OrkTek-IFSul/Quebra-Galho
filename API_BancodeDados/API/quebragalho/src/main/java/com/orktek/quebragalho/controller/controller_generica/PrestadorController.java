package com.orktek.quebragalho.controller.controller_generica;
// package com.orktek.quebragalho.controller;

// import io.swagger.v3.oas.annotations.Operation;
// import io.swagger.v3.oas.annotations.tags.Tag;
// import io.swagger.v3.oas.annotations.responses.ApiResponse;
// import io.swagger.v3.oas.annotations.responses.ApiResponses;
// import io.swagger.v3.oas.annotations.Parameter;
// import io.swagger.v3.oas.annotations.media.Content;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.HttpStatus;
// import org.springframework.http.MediaType;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;
// import org.springframework.web.server.ResponseStatusException;

// import com.orktek.quebragalho.dto.PrestadorDTO.CriarPrestadorDTO;
// import com.orktek.quebragalho.model.Prestador;
// import com.orktek.quebragalho.service.PrestadorService;

// import java.io.FileNotFoundException;
// import java.io.IOException;
// import java.nio.file.Files;
// import java.nio.file.Path;
// import java.util.List;
// import java.util.stream.Collectors;

// /**
//  * Controller para operações com prestadores de serviço
//  */
// @RestController
// @RequestMapping("/api/prestadores")
// @Tag(name = "Prestadores", description = "Operações relacionadas aos prestadores de serviço")
// public class PrestadorController {

//     @Autowired
//     private PrestadorService prestadorService;

//     /**
//      * Lista todos os prestadores
//      * GET /api/prestadores
//      */
//     @Operation(summary = "Lista todos os prestadores", description = "Retorna uma lista de todos os prestadores cadastrados.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "200", description = "Lista de prestadores retornada com sucesso")
//     })
//     @GetMapping
//     public ResponseEntity<List<CriarPrestadorDTO>> listarTodos() {
//         List<CriarPrestadorDTO> prestadores = prestadorService.listarTodos()
//                 .stream().map(CriarPrestadorDTO::new)
//                 .collect(Collectors.toList());
//         return ResponseEntity.ok(prestadores);
//     }

//     /**
//      * Busca prestador por ID
//      * GET /api/prestadores/{id}
//      */
//     @GetMapping("/{id}")
//     @Operation(summary = "Busca prestador por ID", description = "Retorna os detalhes de um prestador específico pelo ID.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "200", description = "Prestador encontrado com sucesso"),
//             @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
//     })
//     public ResponseEntity<CriarPrestadorDTO> buscarPorId(
//             @Parameter(description = "ID do prestador a ser buscado", required = true) @PathVariable Long id) {
//         return prestadorService.buscarPorId(id)
//                 .map(CriarPrestadorDTO::new)
//                 .map(ResponseEntity::ok)
//                 .orElse(ResponseEntity.notFound().build());
//     }

// //     /**
// //      * Cria novo prestador associado a um usuário
// //      * POST /api/prestadores/{usuarioId}
// //      */
// //     @Operation(summary = "Cria novo prestador", description = "Cria um novo prestador associado a um usuário.")
// //     @ApiResponses({
// //             @ApiResponse(responseCode = "201", description = "Prestador criado com sucesso"),
// //             @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
// //     })
// //     @PostMapping("/{usuarioId}")
// //     public ResponseEntity<Prestador> criarPrestador(
// //             @Parameter(description = "ID do usuário ao qual o prestador será associado", required = true) @PathVariable Long usuarioId,
// //             @RequestBody Prestador prestador) {
// //         Prestador novoPrestador = prestadorService.criarPrestador(prestador, usuarioId);
// //         return ResponseEntity.status(201).body(novoPrestador);
// //     }

// //     /**
// //      * Atualiza dados do prestador
// //      * PUT /api/prestadores/{id}
// //      */
// //     @Operation(summary = "Atualiza dados do prestador", description = "Atualiza as informações de um prestador existente.")
// //     @ApiResponses({
// //             @ApiResponse(responseCode = "200", description = "Prestador atualizado com sucesso"),
// //             @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
// //     })
// //     @PutMapping("/{id}")
// //     public ResponseEntity<Prestador> atualizarPrestador(
// //             @Parameter(description = "ID do prestador a ser atualizado", required = true) @PathVariable Long id,
// //             @RequestBody Prestador prestador) {
// //         Prestador atualizado = prestadorService.atualizarPrestador(id, prestador);
// //         return ResponseEntity.ok(atualizado);
// //     }

//     /**
//      * Remove um prestador
//      * DELETE /api/prestadores/{id}
//      */
//     @Operation(summary = "Remove um prestador", description = "Remove um prestador pelo ID.")
//     @ApiResponses({
//             @ApiResponse(responseCode = "204", description = "Prestador removido com sucesso"),
//             @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
//     })
//     @DeleteMapping("/{id}")
//     public ResponseEntity<Void> deletarPrestador(
//             @Parameter(description = "ID do prestador a ser removido", required = true) @PathVariable Long id) {
//         prestadorService.deletarPrestador(id);
//         return ResponseEntity.noContent().build();
//     }

// /**
//  * Obtém o documento de um prestador
//  * GET /api/prestadores/{id}/documento
//  */
// @GetMapping("/{id}/documento")
// @Operation(summary = "Obtém documento do prestador", description = "Retorna o documento de um prestador")
// @ApiResponses({
//                 @ApiResponse(responseCode = "200", description = "Documento retornado com sucesso", content = @Content(mediaType = "application/*")),
//                 @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
//                 @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
// })
// public ResponseEntity<byte[]> obterDocumento(
//                 @Parameter(description = "ID do prestador", required = true) @PathVariable Long id) {

//         try {
//                 byte[] documentBytes = prestadorService.obterBytesImagem(id);
//                 Path documentPath = prestadorService.getFilePath(id);
//                 String mimeType = Files.probeContentType(documentPath);

//                 return ResponseEntity.ok()
//                                 .contentType(MediaType.parseMediaType(mimeType))
//                                 .body(documentBytes);
//         } catch (FileNotFoundException e) {
//                 throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Documento não encontrado", e);
//         } catch (IOException e) {
//                 throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Erro ao ler o documento", e);
//         }
// }
// }