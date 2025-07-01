package com.orktek.quebragalho.controller.controller_views;

import com.orktek.quebragalho.dto.ApeloDTO.CarregarApeloDTO;
import com.orktek.quebragalho.dto.DenunciaDTO.AnalisarDenunciaDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.AnalisePrestadorDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioResponseDTO;
import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.model.Denuncia;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.ApeloService;
import com.orktek.quebragalho.service.DenunciaService;
import com.orktek.quebragalho.service.FirebaseMessagingService;
import com.orktek.quebragalho.service.PrestadorService;
import com.orktek.quebragalho.service.UsuarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * Controlador para moderação
 */
@RestController
@RequestMapping("/api/moderacao")
@Tag(name = "Funcionalidades da moderação", description = "Operações relacionadas à moderação")
public class ModeracaoController {

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private DenunciaService denunciaService;

    @Autowired
    private PrestadorService prestadorService;

    @Autowired
    private ApeloService apeloService;

    @Autowired
    private FirebaseMessagingService firebaseService;

    @Operation(summary = "Buscar usuários por nome e/ou status de moderador", description = "Retorna uma lista paginada de usuários com base nos filtros fornecidos.")
    @GetMapping("/listarUsuarios")
    public ResponseEntity<Page<UsuarioResponseDTO>> buscarUsuarios(
            @RequestParam(required = false) String nome,
            @RequestParam(required = false) Boolean isModerador,
            Pageable pageable) {

        Page<UsuarioResponseDTO> dtoPage = usuarioService.buscarUsuariosComFiltros(
                nome, isModerador, pageable);

        return ResponseEntity.ok(dtoPage);
    }

    @PutMapping("tornarModerador/{idUsuario}")
    @Operation(summary = "Tornar um usuario moderador", description = "Dar a um usuario o status de moderador")
    public ResponseEntity<String> TornarModerador(@PathVariable Long idUsuario) {

        String retorno = usuarioService.tornarModerador(idUsuario);

        // Envia a notificação para o prestador
        Usuario cliente = usuarioService.buscarPorId(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado")); // O destinatário da
                                                                                    // notificação
        String titulo = "Permissão de Moderador Concedida!";
        String corpo = "Você agora é um moderador do Quebra-Galho! Você pode analisar denúncias e apelos de usuários e analisar pedidos de cadastro de prestador.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok(retorno);
    }

    @PutMapping("removerModerador/{idUsuario}")
    @Operation(summary = "Remover moderador", description = "Revogar o status de moderador de um usuario")
    public ResponseEntity<String> RemoverModerador(@PathVariable Long idUsuario) {

        String retorno = usuarioService.removerModerador(idUsuario);

        // Envia a notificação para o prestador
        Usuario cliente = usuarioService.buscarPorId(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado")); // O destinatário da
                                                                                    // notificação
        String titulo = "Permissão de Moderador Removida!";
        String corpo = "Você deixou de ser moderador do Quebra-Galho! O que você fez para isso acontecer ?.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok(retorno);
    }

    @GetMapping("analisarDenuncias")
    @Operation(summary = "Busca lista de denuncias não analisadas", description = "Busca lista de denuncias não analisadas")
    public ResponseEntity<List<AnalisarDenunciaDTO>> listarDenuncias() {

        List<AnalisarDenunciaDTO> denunciasNaoAceitas = denunciaService.listarTodosNaoAceitos().stream()
                .map(AnalisarDenunciaDTO::fromEntity).collect(Collectors.toList());

        return ResponseEntity.ok(denunciasNaoAceitas);
    }

    @GetMapping("analisarDenuncias/{idDenuncia}")
    @Operation(summary = "Busca uma denúncia não analisada", description = "Busca uma denúncia não analisada pelo ID")
    public ResponseEntity<AnalisarDenunciaDTO> listarDenuncia(@PathVariable Long idDenuncia) {
        Denuncia denuncia = denunciaService.buscarPorId(idDenuncia)
                .orElseThrow(() -> new RuntimeException("Denúncia não encontrada"));
        AnalisarDenunciaDTO denunciaDTO = AnalisarDenunciaDTO.fromEntity(denuncia);
        return ResponseEntity.ok(denunciaDTO);
    }

    @PutMapping("aceitarDenuncia/{idDenuncia}")
    @Operation(summary = "Aceitar uma denúncia", description = "Aceita uma denúncia e ")
    public ResponseEntity<String> AceitarDenuncia(@PathVariable Long idDenuncia) {
        // Busca a denúncia pelo ID
        Denuncia denuncia = denunciaService.buscarPorId(idDenuncia)
                .orElseThrow(() -> new RuntimeException("Denúncia não encontrada"));

        // Aceita a denúncia
        denunciaService.atualizarStatusDenuncia(idDenuncia, true);

        // Busca o usuário denunciado
        Usuario usuario = denuncia.getDenunciado();

        // Envia a notificação para o prestador
        Usuario cliente = usuario; // O destinatário da
                                   // notificação
        String titulo = "Denúncia feita contra você foi aceita";
        String corpo = "Um usuario fez uma denúncia contra você e ela foi aceita pela moderação. Você recebeu um strike "
                +
                "por isso. Se receber três strikes, será banido do Quebra-Galho. Não esqueça que pode apelar dessa decisão para remover o strike.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        // Adiciona um strike ao usuário denunciado
        usuarioService.adicionarStrike(usuario.getId());

        // Se usuario possuir 3 strikes é banido c:
        if (usuario.getIsAtivo() == true && usuario.getNumStrike() >= 3) {
            usuarioService.desativarUsuario(usuario.getId());
            // Envia a notificação para o prestador
            Usuario cliente2 = usuario; // O destinatário da
                                        // notificação
            String titulo2 = "Você foi banido do Quebra-Galho";
            String corpo2 = "Como você conseguiu tomar 3 strikes ?";
            String link2 = ""; // Link para a tela
                               // específica no app
            // Chama o método genérico que faz tudo
            firebaseService.enviarNotificacaoCompleta(cliente2, titulo2, corpo2, link2);

        }

        return ResponseEntity.ok("Denuncia aceita com sucesso");
    }

    @PutMapping("recusarDenuncia/{idDenuncia}")
    @Operation(summary = "Recusar uma denúncia", description = "Recusa uma denúncia")
    public ResponseEntity<String> RecusarDenuncia(@PathVariable Long idDenuncia) {

        // Recusa a denúncia
        denunciaService.atualizarStatusDenuncia(idDenuncia, false);

        return ResponseEntity.ok("Denuncia recusada com sucesso");
    }

    @GetMapping("analisarApelos")
    @Operation(summary = "Busca lista de apelos não analisados", description = "Busca lista de apelos não analisados")
    public ResponseEntity<List<CarregarApeloDTO>> listarApelos() {

        List<CarregarApeloDTO> apelosNaoAceitos = apeloService.listarTodosNaoAceitos().stream()
                .map(CarregarApeloDTO::fromEntity).collect(Collectors.toList());

        return ResponseEntity.ok(apelosNaoAceitos);
    }

    @GetMapping("analisarApelos/{idApelo}")
    @Operation(summary = "Busca apelo não analisados", description = "Busca de apelo não analisado")
    public ResponseEntity<CarregarApeloDTO> listarApelo(
            @Parameter(description = "ID do apelo", example = "1") @PathVariable Long idApelo) {

        Apelo apelo = apeloService.buscarPorId(idApelo)
                .orElseThrow(() -> new RuntimeException("Apelo não encontrado"));
        CarregarApeloDTO apeloDTO = CarregarApeloDTO.fromEntity(apelo);

        return ResponseEntity.ok(apeloDTO);
    }

    @PutMapping("aceitarApelo/{idApelo}")
    @Operation(summary = "Aceitar um apelo", description = "Aceita um apelo de um usuário")
    public ResponseEntity<String> AceitarApelo(@PathVariable Long idApelo) {
        // Aceita o apelo
        apeloService.atualizarStatusApelo(idApelo, true);

        // Busca o usuário do apelo
        Apelo apelo = apeloService.buscarPorId(idApelo)
                .orElseThrow(() -> new RuntimeException("Apelo não encontrado"));
        Usuario usuario = apelo.getDenuncia().getDenunciado();

        // Remove o strike do usuário
        usuarioService.removerStrike(usuario.getId());

        // Envia a notificação para o prestador
        Usuario cliente = usuario; // O destinatário da
                                   // notificação
        String titulo = "Apelo aceito";
        String corpo = "Seu apelo foi aceito pela moderação e seu strike foi removido. Você pode continuar usando o Quebra-Galho normalmente.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok("Apelo aceito com sucesso");
    }

    @PutMapping("recusarApelo/{idApelo}")
    @Operation(summary = "Recusar um apelo", description = "Recusa um apelo de um usuário")
    public ResponseEntity<String> RecusarApelo(@PathVariable Long idApelo) {

        // Recusa o apelo
        apeloService.atualizarStatusApelo(idApelo, false);

        // Busca o usuário do apelo
        Apelo apelo = apeloService.buscarPorId(idApelo)
                .orElseThrow(() -> new RuntimeException("Apelo não encontrado"));
        Usuario usuario = apelo.getDenuncia().getDenunciado();

        // Envia a notificação para o prestador
        Usuario cliente = usuario; // O destinatário da
                                   // notificação
        String titulo = "Apelo recusado";
        String corpo = "Seu apelo foi recusado pela moderação e seu strike foi mantido. Você pode continuar usando o Quebra-Galho, mas cuidado com as denúncias.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok("Apelo recusado com sucesso");
    }

    @GetMapping("analisarPrestador")
    @Operation(summary = "Busca lista de prestadores não analisados", description = "Busca lista de prestadores não analisados")
    public ResponseEntity<List<AnalisePrestadorDTO>> listarPrestadores() {

        List<AnalisePrestadorDTO> prestadoresNaoAceitos = prestadorService.listarTodosNaoAceitos().stream()
                .map(AnalisePrestadorDTO::fromEntity).collect(Collectors.toList());

        return ResponseEntity.ok(prestadoresNaoAceitos);
    }

    @GetMapping("analisarPrestador/{idPrestador}")
    @Operation(summary = "Busca um prestador não analisado", description = "Busca um prestador não analisado pelo ID")
    public ResponseEntity<AnalisePrestadorDTO> listarPrestador(@PathVariable Long idPrestador) {
        Prestador prestador = prestadorService.buscarPorId(idPrestador)
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));
        AnalisePrestadorDTO prestadorDTO = AnalisePrestadorDTO.fromEntity(prestador);
        return ResponseEntity.ok(prestadorDTO);
    }

    @PutMapping("analisarPrestador/recusarPrestador/{idPrestador}")
    @Operation(summary = "Recusar um prestador", description = "Recusa o cadastro de um prestador")
    public ResponseEntity<String> RecusarPrestador(@PathVariable Long idPrestador) {

        // Recusa o prestador
        prestadorService.statusAceito(idPrestador, false);

        Prestador prestador = prestadorService.buscarPorId(idPrestador)
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));

        // Envia a notificação para o prestador
        Usuario cliente = prestador.getUsuario(); // O destinatário da
        // notificação
        String titulo = "Cadastro de Prestador Recusado";
        String corpo = "Seu cadastro como prestador foi recusado pela moderação.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok("Prestador recusado com sucesso");

    }

    @PutMapping("analisarPrestador/aceitarPrestador/{idPrestador}")
    @Operation(summary = "Aceitar um prestador", description = "Aceita o cadastro de um prestador")
    public ResponseEntity<String> AceitarPrestador(@PathVariable Long idPrestador) {

        // Aceita o prestador
        prestadorService.statusAceito(idPrestador, true);

        Prestador prestador = prestadorService.buscarPorId(idPrestador)
                .orElseThrow(() -> new RuntimeException("Prestador não encontrado"));

        // Envia a notificação para o prestador
        Usuario cliente = prestador.getUsuario(); // O destinatário da notificação
        String titulo = "Cadastro de Prestador Aceito!";
        String corpo = "Seu cadastro como prestador foi aceito pela moderação. Você agora pode oferecer seus serviços no Quebra-Galho.";
        String link = ""; // Link para a tela
                          // específica no app
        // Chama o método genérico que faz tudo
        firebaseService.enviarNotificacaoCompleta(cliente, titulo, corpo, link);

        return ResponseEntity.ok("Prestador aceito com sucesso");
    }
}
