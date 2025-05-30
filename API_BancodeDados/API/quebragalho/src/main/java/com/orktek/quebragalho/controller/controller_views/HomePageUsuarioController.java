package com.orktek.quebragalho.controller.controller_views;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.orktek.quebragalho.dto.TagDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorHomePageDoUsuarioDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.service.PrestadorService;
import com.orktek.quebragalho.service.TagService;

/**
 * Controlador para a homepage do usuário
 */
@RestController
@RequestMapping("/api/usuario/homepage")
@Tag(name = "HomePage do usuario", description = "Operações relacionadas à homepage do usuario")
public class HomePageUsuarioController {

        @Autowired
        private TagService tagService;

        @Autowired
        private PrestadorService prestadorService;

        @Autowired
        private PrestadorRepository prestadorRepository;

        @GetMapping
        @Operation(summary = "Lista de prestadores", description = "Lista de prestadores sem filtro de pesquisa")
        public ResponseEntity<List<PrestadorHomePageDoUsuarioDTO>> ListarPrestadores() {

                List<PrestadorHomePageDoUsuarioDTO> prestadores = new ArrayList<>();

                for (Prestador prestadorList : prestadorService.listarTodos()) {
                        prestadores.add(PrestadorHomePageDoUsuarioDTO.fromEntity(prestadorList, prestadorService));
                }

                System.out.println("TESTE TESTE" + prestadores.toString());

                return ResponseEntity.ok(prestadores);

        }

        @GetMapping("/tags")
        @Operation(summary = "Lista de Tags", description = "Lista de tags para o filtro de pesquisa")
        public ResponseEntity<List<TagDTO>> ListarTags() {

                List<TagDTO> tags = tagService.listarTodasAtivas()
                                .stream().map(TagDTO::fromEntity)
                                .collect(Collectors.toList());

                System.out.println("TESTE TESTE" + tags.toString());

                return ResponseEntity.ok(tags);
        }

        @Operation(summary = "Buscar prestadores por nome e/ou tags", description = "Retorna uma lista paginada de prestadores cujo nome contenha o termo informado e que estejam associados a pelo menos uma das tags especificadas.", parameters = {
                        @Parameter(name = "nome", description = "Nome parcial ou completo do prestador", required = true, in = ParameterIn.QUERY, example = "Marcos"),
                        @Parameter(name = "tags", description = "Lista de nomes de tags (separadas por vírgula)", required = false, in = ParameterIn.QUERY, example = "Jardinagem, Reforma"),
                        @Parameter(name = "page", description = "Número da página (inicia em 0)", in = ParameterIn.QUERY, example = "0"),
                        @Parameter(name = "size", description = "Número de itens por página", in = ParameterIn.QUERY, example = "10"),
        }, responses = {
                        @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso", content = @Content(mediaType = "application/json", schema = @Schema(implementation = PrestadorHomePageDoUsuarioDTO.class), examples = {
                                        @ExampleObject(name = "Exemplo de requesta", value = "http://localhost:8080/api/usuario/homepage/buscar?nome=Marcos&tags=Jardinagem,Marcenaria&page=0&size=5")
                        })),
                        @ApiResponse(responseCode = "400", description = "Parâmetros inválidos", content = @Content)
        })
        @GetMapping("/buscar")
        public ResponseEntity<Page<PrestadorHomePageDoUsuarioDTO>> buscarComFiltros(
                        @RequestParam(required = false) String nome,
                        @RequestParam(required = false) List<String> tags,
                        @PageableDefault(size = 10) Pageable pageable) {

                // Limpar espaços em branco do nome
                String nomeProcessado = nome != null && !nome.trim().isEmpty()
                                ? nome.trim().toLowerCase()
                                : null;

                List<String> tagsProcessadas = tags != null && !tags.isEmpty()
                                ? tags.stream()
                                                .filter(tag -> tag != null && !tag.trim().isEmpty())
                                                .map(tag -> tag.trim().toLowerCase())
                                                .collect(Collectors.toList())
                                : null;

                // Se a lista ficou vazia após filtrar, passar null
                if (tagsProcessadas != null && tagsProcessadas.isEmpty()) {
                        tagsProcessadas = null;
                }

                Page<Prestador> resultado = prestadorRepository.buscarPorNomeEPorTags(
                                nomeProcessado, tagsProcessadas, pageable);

                Page<PrestadorHomePageDoUsuarioDTO> dtoPage = resultado
                                .map(prestador -> PrestadorHomePageDoUsuarioDTO.fromEntity(prestador,
                                                prestadorService));

                return ResponseEntity.ok(dtoPage);
        }
}
