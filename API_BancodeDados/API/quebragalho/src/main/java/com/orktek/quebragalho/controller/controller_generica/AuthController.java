package com.orktek.quebragalho.controller.controller_generica;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.service.AuthService;
import com.orktek.quebragalho.service.UsuarioService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    // Injeta o serviço de autenticação (AuthService) automaticamente
    @Autowired
    private AuthService authService;

    @Autowired
    private UsuarioService usuarioService;

    // Mapeia requisições POST para a URL /auth/login
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        // Chama o serviço de autenticação passando email e senha
        String token = authService.autenticar(loginRequest.getEmail(), loginRequest.getSenha());

        // Busca o usuario pelo email para buscar o ID
        Usuario usuario = usuarioService.buscarPorEmail(loginRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Criação do objeto de resposta
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("id_usuario", usuario.getId());

        // Verifica se o usuario é prestador também
        if (usuario.getPrestador() != null) {
            // Se for prestador incorporará id do prestador também
            response.put("id_prestador", usuario.getPrestador().getId());
        }

        // Retorna o token JWT gerado e o ID como resposta para o cliente
        return ResponseEntity.ok((response));
    }

    // Classe estática interna que representa o corpo da requisição de login
    static class LoginRequest {
        private String email;
        private String senha;

        // Getter e Setter para o campo 'email'
        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        // Getter e Setter para o campo 'senha'
        public String getSenha() {
            return senha;
        }

        public void setSenha(String senha) {
            this.senha = senha;
        }
    }

    // Classe estática interna que encapsula o token a ser retornado como resposta
    static class TokenResponse {
        private String token;

        // Construtor que inicializa o token
        public TokenResponse(String token) {
            this.token = token;
        }

        // Getter para obter o token
        public String getToken() {
            return token;
        }
    }
}
