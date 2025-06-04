package com.orktek.quebragalho.controller.controller_generica;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
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
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Controller para portfólios de prestadores
 */
@RestController
@RequestMapping("/api/portfolio")
// @Tag(name = "Portfolio", description = "Gerenciamento do portfólio de prestadores")
public class PortfolioController {

        @Autowired
        private PortfolioService portfolioService;

        /**
         * Adiciona item ao portfólio
         * POST /api/portfolio/{prestadorId}
         */
        @PostMapping("/{prestadorId}")
        //@Operation(summary = "Adiciona item ao portfólio", description = "Adiciona um novo item ao portfólio de um prestador")
        @ApiResponses({
                        @ApiResponse(responseCode = "201", description = "Item adicionado com sucesso"),
                        @ApiResponse(responseCode = "400", description = "Erro na requisição"),
                        @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<Portfolio> adicionarItem(
                        @Parameter(description = "ID do prestador", required = true) @PathVariable Long prestadorId,
                        @Parameter(description = "Arquivo a ser adicionado ao portfólio", required = true) @RequestParam("file") MultipartFile arquivo) {
                Portfolio item = portfolioService.adicionarAoPortfolio(arquivo, prestadorId);
                return ResponseEntity.status(201).body(item);
        }

        /**
         * Lista itens do portfólio de um prestador
         * GET /api/portfolio/prestador/{prestadorId}
         */
        @GetMapping("/prestador/{prestadorId}")
        //@Operation(summary = "Lista itens do portfólio", description = "Lista todos os itens do portfólio de um prestador")
        @ApiResponses({
                        @ApiResponse(responseCode = "200", description = "Itens listados com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Prestador não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<List<PortfolioDTO>> listarPorPrestador(
                        @Parameter(description = "ID do prestador", required = true) @PathVariable Long prestadorId) {
                                // 1. Verifica se o prestador existe
                                System.out.println("Prestador ID: " + prestadorId);
                List<PortfolioDTO> itens = portfolioService.listarPorPrestador(prestadorId)
                                .stream().map(PortfolioDTO::new)
                                .collect(Collectors.toList());
                return ResponseEntity.ok(itens);
        }

        /**
         * Obtém a imagem de um item do portfólio
         * GET /api/portfolio/{id}/imagem
         */
        @GetMapping("/{id}/imagem")
        //@Operation(summary = "Obtém imagem do portfólio", description = "Retorna a imagem de um item do portfólio")
        @ApiResponses({
                        @ApiResponse(responseCode = "200", description = "Imagem retornada com sucesso", content = @Content(mediaType = "image/*")),
                        @ApiResponse(responseCode = "404", description = "Item não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<byte[]> obterImagem(
                        @Parameter(description = "ID do item do portfólio", required = true) @PathVariable Long id) {

                try {
                        byte[] imageBytes = portfolioService.obterBytesImagem(id);
                        Path imagePath = portfolioService.getFilePath(id);
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
        @DeleteMapping("/{id}")
        //@Operation(summary = "Remove item do portfólio", description = "Remove um item do portfólio pelo ID")
        @ApiResponses({
                        @ApiResponse(responseCode = "204", description = "Item removido com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Item não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<Void> removerItem(
                        @Parameter(description = "ID do item a ser removido", required = true) @PathVariable Long id) {
                portfolioService.removerDoPortfolio(id);
                return ResponseEntity.noContent().build();
        }

        /**
         * Obtém a imagem de um item do portfólio
         * GET /api/portfolio/imagem/{id}
         */
        @GetMapping("/imagem/{id}")
        //@Operation(summary = "Obtém imagem do portfólio", description = "Retorna a imagem de um item específico do portfólio")
        @ApiResponses({
                        @ApiResponse(responseCode = "200", description = "Imagem retornada com sucesso"),
                        @ApiResponse(responseCode = "404", description = "Item não encontrado"),
                        @ApiResponse(responseCode = "500", description = "Erro interno no servidor")
        })
        public ResponseEntity<byte[]> obterImagemPortfolio(
                        @Parameter(description = "ID do item do portfólio", required = true) @PathVariable Long id) {

                // 1. Obter o caminho da imagem ou os bytes do serviço
                Optional<Portfolio> portfolioItem = portfolioService.buscarPorId(id);
                if (portfolioItem.isEmpty()) {
                        return ResponseEntity.notFound().build();
                }
                Path imagePath = Paths.get(portfolioItem.get().getImgPortfolioPath());

                // 2. Ler os bytes da imagem
                byte[] imageBytes;
                try {
                        imageBytes = Files.readAllBytes(imagePath);
                } catch (IOException e) {
                        return ResponseEntity.notFound().build();
                }

                // 3. Determinar o tipo de conteúdo
                String mimeType;
                try {
                        mimeType = Files.probeContentType(imagePath);
                } catch (IOException e) {
                        mimeType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
                }

                // 4. Retornar a imagem
                return ResponseEntity.ok()
                                .contentType(MediaType.parseMediaType(mimeType))
                                .body(imageBytes);
        }

}
