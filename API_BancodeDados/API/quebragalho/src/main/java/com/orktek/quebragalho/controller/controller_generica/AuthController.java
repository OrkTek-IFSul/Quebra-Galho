package com.orktek.quebragalho.controller.controller_generica;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.orktek.quebragalho.service.AuthService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    // Injeta o serviço de autenticação (AuthService) automaticamente
    @Autowired
    private AuthService authService;

    // Mapeia requisições POST para a URL /auth/login
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        // Chama o serviço de autenticação passando email e senha
        String token = authService.autenticar(loginRequest.getEmail(), loginRequest.getSenha());

        // Retorna o token JWT gerado como resposta para o cliente
        return ResponseEntity.ok(new TokenResponse(token));
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
