package com.orktek.quebragalho.controller.controller_generica;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

// import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;
// import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
// import java.util.List;
// import java.util.stream.Collectors;

/**
 * Controller para operações relacionadas a usuários
 */
@RestController
@RequestMapping("/api/usuarios")
// @Tag(name = "Usuários", description = "Operações relacionadas a usuários")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

//     /**
//      * Lista todos os usuários cadastrados
//      * GET /api/usuarios
//      */
//     @GetMapping
//     @Operation(summary = "Listar todos os usuários", description = "Retorna uma lista de todos os usuários cadastrados")
//     @ApiResponse(responseCode = "200", description = "Lista de usuários retornada com sucesso")
//     public ResponseEntity<List<CriarUsuarioDTO>> listarTodos() {
//         List<CriarUsuarioDTO> usuarios = usuarioService.listarTodos()
//                 .stream().map(CriarUsuarioDTO::new)
//                 .collect(Collectors.toList());
//         return ResponseEntity.ok(usuarios); // Retorna 200 OK com a lista
//     }

//     /**
//      * Busca um usuário específico por ID
//      * GET /api/usuarios/{id}
//      */
//     @GetMapping("/{id}")
//     @Operation(summary = "Buscar usuário por ID", description = "Retorna um usuário específico pelo ID fornecido")
//     @ApiResponse(responseCode = "200", description = "Usuário encontrado com sucesso")
//     @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
//     public ResponseEntity<CriarUsuarioDTO> buscarPorId(
//             @Parameter(description = "ID do usuário a ser buscado", required = true) @PathVariable Long id) {
//         return usuarioService.buscarPorId(id)
//                 .map(CriarUsuarioDTO::new) // Converte Usuario para UsuarioResponseDTO
//                 .map(ResponseEntity::ok) // Se encontrado, retorna 200 OK
//                 .orElse(ResponseEntity.notFound().build()); // Se não, 404 Not Found
//     }

//     // /**
//     //  * Cria um novo usuário
//     //  * POST /api/usuarios
//     //  */
//     // @PostMapping
//     // @Operation(summary = "Criar novo usuário", description = "Cria um novo usuário com os dados fornecidos")
//     // @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso")
//     // public ResponseEntity<Usuario> criarUsuario(@RequestBody Usuario usuario) {
//     //     Usuario novoUsuario = usuarioService.criarUsuario(usuario);
//     //     return ResponseEntity.status(HttpStatus.CREATED).body(novoUsuario); // Retorna status 201 se criado com sucesso
//     // }

//     /**
//      * Atualiza um usuário existente
//      * PUT /api/usuarios/{id}
//      */
//     @PutMapping("/{id}")
//     @Operation(summary = "Atualizar usuário", description = "Atualiza os dados de um usuário existente pelo ID fornecido")
//     @ApiResponse(responseCode = "200", description = "Usuário atualizado com sucesso")
//     public ResponseEntity<Usuario> atualizarUsuario(
//             @Parameter(description = "ID do usuário a ser atualizado", required = true) @PathVariable Long id,
//             @RequestBody Usuario usuario) {
//         Usuario usuarioAtualizado = usuarioService.atualizarUsuario(id, usuario);
//         return ResponseEntity.ok(usuarioAtualizado); // Retorna 200 OK
//     }

//     /**
//      * Remove um usuário
//      * DELETE /api/usuarios/{id}
//      */
//     @DeleteMapping("/{id}")
//     @Operation(summary = "Deletar usuário", description = "Remove um usuário existente pelo ID fornecido")
//     @ApiResponse(responseCode = "204", description = "Usuário removido com sucesso")
//     public ResponseEntity<Void> deletarUsuario(
//             @Parameter(description = "ID do usuário a ser removido", required = true) @PathVariable Long id) {
//         usuarioService.deletarUsuario(id);
//         return ResponseEntity.noContent().build(); // Retorna 204 No Content
//     }

    /**
     * Obtém a imagem de um usuário
     * GET /api/usuarios/{id}/imagem
     */
    @GetMapping("/{id}/imagem")
    @Operation(summary = "Obtém imagem do usuário", description = "Retorna a imagem de um usuário")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Imagem retornada com sucesso", content = @Content(mediaType = "image/*")),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado"),
            @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
    })
    public ResponseEntity<byte[]> obterImagem(
            @Parameter(description = "ID do usuário", required = true) @PathVariable Long id) {

        try {
            byte[] imageBytes = usuarioService.obterBytesImagem(id);
            Path imagePath = usuarioService.getFilePath(id);
            String mimeType = Files.probeContentType(imagePath);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(mimeType))
                    .body(imageBytes);
        } catch (FileNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Imagem não encontrada", e);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Erro ao ler a imagem", e);
        }
    }
}
