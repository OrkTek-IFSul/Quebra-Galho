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

// import com.orktek.quebragalho.dto.ServicoDTO.ServicoDTO;
// import com.orktek.quebragalho.model.Servico;
// import com.orktek.quebragalho.service.ServicoService;

// import java.util.List;
// import java.util.stream.Collectors;

// /**
//  * Controller para operações com serviços oferecidos
//  */
// @RestController
// @RequestMapping("/api/servicos")
// @Tag(name = "Serviços", description = "Endpoint para gerenciamento de serviços")
// public class ServicoController {

//         @Autowired
//         private ServicoService servicoService;

//         /**
//          * Lista todos os serviços
//          * GET /api/servicos
//          */
//         @Operation(summary = "Listar todos os serviços", description = "Retorna uma lista de todos os serviços disponíveis")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "200", description = "Lista de serviços retornada com sucesso")
//         })
//         @GetMapping
//         public ResponseEntity<List<ServicoDTO>> listarTodos() {
//                 List<ServicoDTO> servicos = servicoService.listarTodos()
//                                 .stream().map(ServicoDTO::new)
//                                 .collect(Collectors.toList());
//                 return ResponseEntity.ok(servicos);
//         }

//         /**
//          * Lista um serviço específico por ID
//          * GET /api/servicos/{servicoId}
//          */
//         @GetMapping("/{servicoId}")
//         @Operation(summary = "Listar um serviço específico", description = "Retorna um serviço específico se disponível")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "200", description = "Serviço retornado com sucesso")
//         })
//         public ResponseEntity<ServicoDTO> buscarPorId(
//                         @Parameter(description = "ID do serviço a ser buscado", required = true) @PathVariable Long servicoId) {
//                 return servicoService.buscarPorId(servicoId)
//                                 .map(servico -> ResponseEntity.ok(new ServicoDTO(servico)))
//                                 .orElse(ResponseEntity.notFound().build());
//         }

//         /**
//          * Lista serviços de um prestador específico
//          * GET /api/servicos/prestador/{prestadorId}
//          */
//         @Operation(summary = "Listar serviços por prestador", description = "Retorna uma lista de serviços de um prestador específico")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "200", description = "Lista de serviços retornada com sucesso"),
//                         @ApiResponse(responseCode = "404", description = "Prestador não encontrado")
//         })
//         @GetMapping("/prestador/{prestadorId}")
//         public ResponseEntity<List<ServicoDTO>> listarPorPrestador(
//                         @Parameter(description = "ID do prestador cujos serviços serão listados", required = true) @PathVariable Long prestadorId) {
//                 List<ServicoDTO> servicos = servicoService.listarPorPrestador(prestadorId)
//                                 .stream().map(ServicoDTO::new)
//                                 .collect(Collectors.toList());
//                 return ResponseEntity.ok(servicos);
//         }

//         /**
//          * Cria novo serviço associado a um prestador
//          * POST /api/servicos/{prestadorId}
//          */
//         @Operation(summary = "Criar novo serviço", description = "Cria um novo serviço associado a um prestador")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "201", description = "Serviço criado com sucesso"),
//                         @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
//         })
//         @PostMapping("/{prestadorId}")
//         public ResponseEntity<Servico> criarServico(
//                         @Parameter(description = "ID do prestador ao qual o serviço será associado", required = true) @PathVariable Long prestadorId,
//                         @Parameter(description = "Dados do serviço a ser criado", required = true) @RequestBody Servico servico) {
//                 Servico novoServico = servicoService.criarServico(servico, prestadorId);
//                 return ResponseEntity.status(201).body(novoServico);
//         }

//         /**
//          * Atualiza um serviço existente
//          * PUT /api/servicos/{id}
//          */
//         @Operation(summary = "Atualizar serviço", description = "Atualiza os dados de um serviço existente")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "200", description = "Serviço atualizado com sucesso"),
//                         @ApiResponse(responseCode = "404", description = "Serviço não encontrado"),
//                         @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
//         })
//         @PutMapping("/{id}")
//         public ResponseEntity<Servico> atualizarServico(
//                         @Parameter(description = "ID do serviço a ser atualizado", required = true) @PathVariable Long id,
//                         @Parameter(description = "Dados atualizados do serviço", required = true) @RequestBody Servico servico) {
//                 Servico atualizado = servicoService.atualizarServico(id, servico);
//                 return ResponseEntity.ok(atualizado);
//         }

//         /**
//          * Remove um serviço
//          * DELETE /api/servicos/{id}
//          */
//         @Operation(summary = "Deletar serviço", description = "Remove um serviço existente")
//         @ApiResponses({
//                         @ApiResponse(responseCode = "204", description = "Serviço removido com sucesso"),
//                         @ApiResponse(responseCode = "404", description = "Serviço não encontrado")
//         })
//         @DeleteMapping("/{id}")
//         public ResponseEntity<Void> deletarServico(
//                         @Parameter(description = "ID do serviço a ser removido", required = true) @PathVariable Long id) {
//                 servicoService.deletarServico(id);
//                 return ResponseEntity.noContent().build();
//         }
// }