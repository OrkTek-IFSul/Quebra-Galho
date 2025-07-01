package com.orktek.quebragalho.controller.controller_views;

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.PortfolioDTO;
import com.orktek.quebragalho.model.Portfolio;
import com.orktek.quebragalho.service.PortfolioService;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller para portfólios de prestadores
 */
@RestController
@RequestMapping("/api/portfolio")
@Tag(name = "Portfolio", description = "Gerenciamento do portfólio de prestadores, permitindo adicionar, listar, obter e remover itens do portfólio.")
public class PortfolioController {

        @Autowired
        private PortfolioService portfolioService;

        /**
         * Adiciona item ao portfólio
         * POST /api/portfolio/{prestadorId}
         */
        @PostMapping("/{prestadorId}")
        @Operation(
                summary = "Adiciona item ao portfólio",
                description = "Adiciona um novo item ao portfólio de um prestador, enviando um arquivo de imagem."
        )
        @ApiResponses({
                @ApiResponse(responseCode = "201", description = "Item adicionado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Erro na requisição"),
                @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<String> adicionarItem(
                @Parameter(description = "ID do prestador ao qual o item será adicionado", required = true, example = "1")
                @PathVariable Long prestadorId,
                @Parameter(description = "Arquivo de imagem a ser adicionado ao portfólio", required = true)
                @RequestParam("file") MultipartFile arquivo) {
                Portfolio item = portfolioService.adicionarAoPortfolio(arquivo, prestadorId);
                return ResponseEntity.status(201).body(item.getImgPortfolioPath());
        }

        /**
         * Lista itens do portfólio de um prestador
         * GET /api/portfolio/prestador/{prestadorId}
         */
        @GetMapping("/prestador/{prestadorId}")
        @Operation(
                summary = "Lista itens do portfólio",
                description = "Lista todos os itens do portfólio de um prestador específico."
        )
        @ApiResponses({
                @ApiResponse(responseCode = "200", description = "Itens listados com sucesso"),
                @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
                @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<List<PortfolioDTO>> listarPorPrestador(
                @Parameter(description = "ID do prestador para listar os itens do portfólio", required = true, example = "1")
                @PathVariable Long prestadorId) {
                List<PortfolioDTO> itens = portfolioService.listarPorPrestador(prestadorId)
                        .stream().map(PortfolioDTO::new)
                        .collect(Collectors.toList());
                return ResponseEntity.ok(itens);
        }

        /**
         * Obtém a imagem de um item do portfólio
         * GET /api/portfolio/{id}/imagem
         */
        @GetMapping("/{idImagem}/imagem")
        @Operation(
                summary = "Obtém imagem do portfólio",
                description = "Retorna a imagem de um item do portfólio pelo seu ID."
        )
        @ApiResponses({
                @ApiResponse(responseCode = "200", description = "Imagem retornada com sucesso", content = @Content(mediaType = "image/*")),
                @ApiResponse(responseCode = "404", description = "Item não encontrado"),
                @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<byte[]> obterImagem(
                @Parameter(description = "ID do item do portfólio para obter a imagem", required = true, example = "1")
                @PathVariable Long idImagem) {

                try {
                        byte[] imageBytes = portfolioService.obterBytesImagem(idImagem);
                        Path imagePath = portfolioService.getFilePath(idImagem);
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

        /**
         * Remove item do portfólio
         * DELETE /api/portfolio/{id}
         */
        @DeleteMapping("/{idImagem}")
        @Operation(
                summary = "Remove item do portfólio",
                description = "Remove um item do portfólio pelo seu ID."
        )
        @ApiResponses({
                @ApiResponse(responseCode = "204", description = "Item removido com sucesso"),
                @ApiResponse(responseCode = "404", description = "Item não encontrado"),
                @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<Void> removerItem(
                @Parameter(description = "ID do item do portfólio a ser removido", required = true, example = "1")
                @PathVariable Long idImagem) {
                portfolioService.removerDoPortfolio(idImagem);
                return ResponseEntity.noContent().build();
        }
}
