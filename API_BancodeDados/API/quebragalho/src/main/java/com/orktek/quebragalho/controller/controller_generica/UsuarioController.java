package com.orktek.quebragalho.controller.controller_generica;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Usuario;
// import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;
// import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
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

    // /**
    // * Lista todos os usuários cadastrados
    // * GET /api/usuarios
    // */
    // @GetMapping
    // @Operation(summary = "Listar todos os usuários", description = "Retorna uma
    // lista de todos os usuários cadastrados")
    // @ApiResponse(responseCode = "200", description = "Lista de usuários retornada
    // com sucesso")
    // public ResponseEntity<List<CriarUsuarioDTO>> listarTodos() {
    // List<CriarUsuarioDTO> usuarios = usuarioService.listarTodos()
    // .stream().map(CriarUsuarioDTO::new)
    // .collect(Collectors.toList());
    // return ResponseEntity.ok(usuarios); // Retorna 200 OK com a lista
    // }

    // /**
    // * Busca um usuário específico por ID
    // * GET /api/usuarios/{id}
    // */
    // @GetMapping("/{id}")
    // @Operation(summary = "Buscar usuário por ID", description = "Retorna um
    // usuário específico pelo ID fornecido")
    // @ApiResponse(responseCode = "200", description = "Usuário encontrado com
    // sucesso")
    // @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    // public ResponseEntity<CriarUsuarioDTO> buscarPorId(
    // @Parameter(description = "ID do usuário a ser buscado", required = true)
    // @PathVariable Long id) {
    // return usuarioService.buscarPorId(id)
    // .map(CriarUsuarioDTO::new) // Converte Usuario para UsuarioResponseDTO
    // .map(ResponseEntity::ok) // Se encontrado, retorna 200 OK
    // .orElse(ResponseEntity.notFound().build()); // Se não, 404 Not Found
    // }

    // // /**
    // // * Cria um novo usuário
    // // * POST /api/usuarios
    // // */
    // // @PostMapping
    // // @Operation(summary = "Criar novo usuário", description = "Cria um novo
    // usuário com os dados fornecidos")
    // // @ApiResponse(responseCode = "201", description = "Usuário criado com
    // sucesso")
    // // public ResponseEntity<Usuario> criarUsuario(@RequestBody Usuario usuario)
    // {
    // // Usuario novoUsuario = usuarioService.criarUsuario(usuario);
    // // return ResponseEntity.status(HttpStatus.CREATED).body(novoUsuario); //
    // Retorna status 201 se criado com sucesso
    // // }

    // /**
    // * Atualiza um usuário existente
    // * PUT /api/usuarios/{id}
    // */
    // @PutMapping("/{id}")
    // @Operation(summary = "Atualizar usuário", description = "Atualiza os dados de
    // um usuário existente pelo ID fornecido")
    // @ApiResponse(responseCode = "200", description = "Usuário atualizado com
    // sucesso")
    // public ResponseEntity<Usuario> atualizarUsuario(
    // @Parameter(description = "ID do usuário a ser atualizado", required = true)
    // @PathVariable Long id,
    // @RequestBody Usuario usuario) {
    // Usuario usuarioAtualizado = usuarioService.atualizarUsuario(id, usuario);
    // return ResponseEntity.ok(usuarioAtualizado); // Retorna 200 OK
    // }

    // /**
    // * Remove um usuário
    // * DELETE /api/usuarios/{id}
    // */
    // @DeleteMapping("/{id}")
    // @Operation(summary = "Deletar usuário", description = "Remove um usuário
    // existente pelo ID fornecido")
    // @ApiResponse(responseCode = "204", description = "Usuário removido com
    // sucesso")
    // public ResponseEntity<Void> deletarUsuario(
    // @Parameter(description = "ID do usuário a ser removido", required = true)
    // @PathVariable Long id) {
    // usuarioService.deletarUsuario(id);
    // return ResponseEntity.noContent().build(); // Retorna 204 No Content
    // }

    /**
     * Obtém a imagem de um usuário
     * GET /api/usuarios/{id}/imagem
     */
    @GetMapping("/{id}/imagem")
    @Operation(summary = "Obtém imagem do usuário", description = "Retorna a imagem de um usuário")
    public ResponseEntity<byte[]> obterImagem(@PathVariable Long id) {
        try {
            // Primeiro busca o usuário
            Usuario usuario = usuarioService.buscarPorId(id)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

            byte[] imageBytes;
            String mimeType;

            // Verifica se há imagem personalizada
            if (usuario.getImgPerfil() != null && !usuario.getImgPerfil().isBlank()) {
                Path imagePath = usuarioService.getFilePath(id);
                if (Files.exists(imagePath)) {
                    imageBytes = Files.readAllBytes(imagePath);
                    mimeType = Files.probeContentType(imagePath);
                } else {
                    // Fallback para imagem padrão
                    ClassPathResource defaultImage = new ClassPathResource("images/Default_pfp.jpg");
                    imageBytes = defaultImage.getInputStream().readAllBytes();
                    mimeType = "image/jpeg";
                }
            } else {
                // Sem imagem definida, usa padrão direto
                ClassPathResource defaultImage = new ClassPathResource("images/Default_pfp.jpg");
                imageBytes = defaultImage.getInputStream().readAllBytes();
                mimeType = "image/jpeg";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(mimeType))
                    .body(imageBytes);

        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Erro ao carregar a imagem", e);
        }
    }

}
