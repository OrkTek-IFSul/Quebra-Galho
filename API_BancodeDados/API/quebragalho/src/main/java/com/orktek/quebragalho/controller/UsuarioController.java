package com.orktek.quebragalho.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.Parameter;

import java.util.List;

/**
 * Controller para operações relacionadas a usuários
 */
@RestController
@RequestMapping("/api/usuarios")
@Tag(name = "Usuários", description = "Operações relacionadas a usuários")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    /**
     * Lista todos os usuários cadastrados
     * GET /api/usuarios
     */
    @GetMapping
    @Operation(summary = "Listar todos os usuários", description = "Retorna uma lista de todos os usuários cadastrados")
    @ApiResponse(responseCode = "200", description = "Lista de usuários retornada com sucesso")
    public ResponseEntity<List<Usuario>> listarTodos() {
        List<Usuario> usuarios = usuarioService.listarTodos();
        return ResponseEntity.ok(usuarios); // Retorna 200 OK com a lista
    }

    /**
     * Busca um usuário específico por ID
     * GET /api/usuarios/{id}
     */
    @GetMapping("/{id}")
    @Operation(summary = "Buscar usuário por ID", description = "Retorna um usuário específico pelo ID fornecido")
    @ApiResponse(responseCode = "200", description = "Usuário encontrado com sucesso")
    @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    public ResponseEntity<Usuario> buscarPorId(
            @Parameter(description = "ID do usuário a ser buscado", required = true) @PathVariable Long id) {
        return usuarioService.buscarPorId(id)
                .map(ResponseEntity::ok) // Se encontrado, retorna 200 OK
                .orElse(ResponseEntity.notFound().build()); // Se não, 404 Not Found
    }

    /**
     * Cria um novo usuário
     * POST /api/usuarios
     */
    @PostMapping
    @Operation(summary = "Criar novo usuário", description = "Cria um novo usuário com os dados fornecidos")
    @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso")
    public ResponseEntity<Usuario> criarUsuario(@RequestBody Usuario usuario) {
        Usuario novoUsuario = usuarioService.criarUsuario(usuario);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoUsuario); // Retorna status 201 se criado com sucesso
    }

    /**
     * Atualiza um usuário existente
     * PUT /api/usuarios/{id}
     */
    @PutMapping("/{id}")
    @Operation(summary = "Atualizar usuário", description = "Atualiza os dados de um usuário existente pelo ID fornecido")
    @ApiResponse(responseCode = "200", description = "Usuário atualizado com sucesso")
    public ResponseEntity<Usuario> atualizarUsuario(
            @Parameter(description = "ID do usuário a ser atualizado", required = true) @PathVariable Long id,
            @RequestBody Usuario usuario) {
        Usuario usuarioAtualizado = usuarioService.atualizarUsuario(id, usuario);
        return ResponseEntity.ok(usuarioAtualizado); // Retorna 200 OK
    }

    /**
     * Remove um usuário
     * DELETE /api/usuarios/{id}
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Deletar usuário", description = "Remove um usuário existente pelo ID fornecido")
    @ApiResponse(responseCode = "204", description = "Usuário removido com sucesso")
    public ResponseEntity<Void> deletarUsuario(
            @Parameter(description = "ID do usuário a ser removido", required = true) @PathVariable Long id) {
        usuarioService.deletarUsuario(id);
        return ResponseEntity.noContent().build(); // Retorna 204 No Content
    }

    /**
     * Upload de imagem de perfil
     * POST /api/usuarios/{id}/imagem
     */
    @PostMapping("/{id}/imagem")
    @Operation(summary = "Upload de imagem de perfil", description = "Faz o upload de uma imagem de perfil para o usuário")
    @ApiResponse(responseCode = "200", description = "Imagem de perfil atualizada com sucesso")
    public ResponseEntity<String> uploadImagemPerfil(
            @Parameter(description = "ID do usuário para o qual a imagem será enviada", required = true) @PathVariable Long id,
            @Parameter(description = "Arquivo de imagem a ser enviado", required = true) @RequestParam("file") MultipartFile file) {
        String nomeArquivo = usuarioService.atualizarImagemPerfil(id, file);
        return ResponseEntity.ok(nomeArquivo); // Retorna 200 OK com o nome do arquivo
    }

    /**
     * remover imagem de perfil
     * DELETE /api/usuarios/{id}/removerimagem
     */
    @DeleteMapping("/{id}/removerimagem")
    @Operation(summary = "Remover imagem de perfil", description = "Remove a imagem de perfil do usuário")
    @ApiResponse(responseCode = "204", description = "Imagem de perfil removida com sucesso")
    public ResponseEntity<Void> removerImagemPerfil(
            @Parameter(description = "ID do usuário cuja imagem será removida", required = true) @PathVariable Long id) {
        usuarioService.removerImagemPerfil(id);
        return ResponseEntity.noContent().build();
    }
}
