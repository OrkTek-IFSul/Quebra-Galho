package com.orktek.quebragalho.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.orktek.quebragalho.service.AuthService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

@RestController
@RequestMapping("/api/auth")
public class LoginController {

    @Autowired // Injeta automaticamente a dependência do serviço de usuário
    private AuthService authService;

    // Define uma rota POST em /api/auth/login
    @PostMapping("/login")
    @Operation(summary = "Login de usuário", description = "Autentica o usuário com nome de usuário e senha")
    @ApiResponse(responseCode = "200", description = "Login realizado com sucesso")
    @ApiResponse(responseCode = "401", description = "Credenciais inválidas")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginRequest) {
        // Extrai o email e a senha do corpo da requisição (esperado em formato JSON)
        String email = loginRequest.get("email");
        String senha = loginRequest.get("senha");

        try {
            // Tenta autenticar o usuário e gerar um token JWT
            String token = authService.autenticar(email, senha);

            // Retorna o token em um JSON
            return ResponseEntity.ok(Map.of("token", token));
        } catch (IllegalArgumentException e) {
            // Se ocorrer erro na autenticação, retorna 401 Unauthorized com mensagem de
            // erro
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("erro", e.getMessage()));
        }
    }
}
