package com.orktek.quebragalho.controller.controller_views;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.orktek.quebragalho.dto.PrestadorDTO.CriarPrestadorDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorGenericoDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.CriarUsuarioDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioGenericoDTO;
import com.orktek.quebragalho.service.PrestadorService;
import com.orktek.quebragalho.service.UsuarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Controller para operações da tela de cadastro
 * de usuários e prestadores
 */
@RestController
@RequestMapping("/api/cadastro")
@Tag(name = "Cadastro Controller", description = "Operações relacionadas ao cadastro de usuários e prestadores")
public class CadastroController {

        @Autowired
        private UsuarioService usuarioService;

        @Autowired
        private PrestadorService prestadorService;

        @PostMapping("/usuario")
        @Operation(summary = "Cadastrar usuario", description = "Cadastra um novo usuario")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Usuario cadastrado com sucesso"),
                        @ApiResponse(responseCode = "409", description = "Email ou Documento já cadastrado", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE)),
        })
        public ResponseEntity<UsuarioGenericoDTO> CriarUsuario(
                        @Parameter(description = "Usuario que vai ser criado", required = true) @RequestBody CriarUsuarioDTO usuarioDTO) {
                UsuarioGenericoDTO usuarioCadastrado = usuarioService.criarUsuario(usuarioDTO);// Cria o usuário
                return ResponseEntity.status(HttpStatus.CREATED).body(usuarioCadastrado); // Retorna status 201 se
                                                                                          // criado com
                                                                                          // sucesso
        }

        @Operation(summary = "Cadastrar prestador", description = "Cadastra um novo prestador")
        @PostMapping(value = "/prestador", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Prestador cadastrado com sucesso"),
                        @ApiResponse(responseCode = "409", description = "Email ou Documento já cadastrado", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE))
        })
        public ResponseEntity<PrestadorGenericoDTO> criarPrestador(
                        @Parameter(description = "Dados do prestador", content = @Content(mediaType = "application/json", schema = @Schema(implementation = CriarPrestadorDTO.class))) @RequestPart("prestadorDTO") String prestadorDTOJson,

                        @Parameter(description = "Arquivo do documento (CPF/CNPJ)") @RequestPart("imagemDocumento") MultipartFile imagemDocumento) {

                // 1. Converter JSON para DTO manualmente
                ObjectMapper objectMapper = new ObjectMapper();
                CriarPrestadorDTO criarPrestadorDTO;
                try {
                        criarPrestadorDTO = objectMapper.readValue(prestadorDTOJson, CriarPrestadorDTO.class);
                } catch (JsonProcessingException e) {
                        return ResponseEntity.badRequest().build();
                }

                // 2. Processar como antes
                UsuarioGenericoDTO usuarioCadastrado = usuarioService.criarUsuario(criarPrestadorDTO.getUsuario());
                PrestadorGenericoDTO prestadorCadastrado = prestadorService.criarPrestador(usuarioCadastrado,
                                criarPrestadorDTO.getDescricao());
                prestadorService.enviarImagemDocumento(prestadorCadastrado.getId(), imagemDocumento);

                return ResponseEntity.status(HttpStatus.CREATED).body(prestadorCadastrado);
        }

}
