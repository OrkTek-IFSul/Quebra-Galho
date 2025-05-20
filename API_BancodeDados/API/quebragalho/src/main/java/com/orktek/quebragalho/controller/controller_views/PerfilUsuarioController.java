package com.orktek.quebragalho.controller.controller_views;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.orktek.quebragalho.dto.UsuarioDTO.AtualizarUsuarioDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.PerfilUsuarioDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioGenericoDTO;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * Controller para operações da tela de cadastro
 * de usuários e prestadores
 */
@RestController
@RequestMapping("/api/usuario/perfil")
@Tag(name = "Perfil do usuario", description = "Operações relacionadas ao perfil do usuario")
public class PerfilUsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    /**
     * Carrega informações do perfil do usuario
     * GET /api/usuarios/perfil/{usuarioId}
     */
    @GetMapping("/{usuarioId}")
    @Operation(summary = "Carregar informações do perfil do usuario", description = "Carregar informações do perfil do usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuario enviado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Usuario não encontrado"),
    })
    public ResponseEntity<PerfilUsuarioDTO> BuscarUsuario(
            @Parameter(description = "Usuario que vai ser encontrado", required = true) @PathVariable Long usuarioId) {
        return usuarioService.buscarPorId(usuarioId).map(PerfilUsuarioDTO::fromEntity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Upload de imagem de perfil
     * POST /api/usuarios/perfil/{id}/imagem
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
     * DELETE /api/usuarios/perfil/{id}/removerimagem
     */
    @DeleteMapping("/{id}/removerimagem")
    @Operation(summary = "Remover imagem de perfil", description = "Remove a imagem de perfil do usuário")
    @ApiResponse(responseCode = "204", description = "Imagem de perfil removida com sucesso")
    public ResponseEntity<Void> removerImagemPerfil(
            @Parameter(description = "ID do usuário cuja imagem será removida", required = true) @PathVariable Long id) {
        usuarioService.removerImagemPerfil(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("atualizar/{usuarioId}")
    @Operation(summary = "Atualizar informações do usuário", description = "Atualiza as informações do usuário com os dados fornecidos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuário atualizado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    public ResponseEntity<UsuarioGenericoDTO> atualizarUsuario(
            @Parameter(description = "Id do usuario") @PathVariable Long usuarioId,
            @Parameter(description = "Informações atualizadas") @RequestBody AtualizarUsuarioDTO usuarioAtualizado) {
        UsuarioGenericoDTO usuario = usuarioService.alterarUsuario(usuarioId, usuarioAtualizado);

        return ResponseEntity.ok(usuario);
    }
}
