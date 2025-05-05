package com.orktek.quebragalho.security;

import java.security.Key;
import java.util.Date;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtil {

    // Chave secreta usada para assinar o token JWT
    // OBS: Deve ter pelo menos 32 caracteres para o algoritmo HS256 funcionar
    // corretamente
    private final String jwtSecret = "chaveSuperSecretaJwtQuePrecisaTerPeloMenos32Caracteres";

    // Tempo de validade do token: 24 horas (em milissegundos)
    private final long jwtExpirationMs = 86400000;

    // Método auxiliar para obter a chave de assinatura no formato necessário
    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    // Gera um token JWT com o nome de usuário como "subject"
    public String generateToken(String username) {
        return Jwts.builder()
                // Define o "subject" como o nome de usuário
                .setSubject(username)
                // Define a data de criação do token (agora)
                .setIssuedAt(new Date())
                // Define a data de expiração
                .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                // Assina o token usando a chave e algoritmo HS256
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                // Compacta o token em uma string (JWT completo)
                .compact();
    }

    // Extrai o nome de usuário (subject) de um token JWT
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSigningKey()) // Define a chave usada na assinatura
                .build()
                .parseClaimsJws(token) // Faz o parsing do token e valida assinatura/estrutura
                .getBody(); // Obtém o corpo com os dados (claims)

        return claims.getSubject(); // Retorna o subject (username)
    }

    // Verifica se o token é válido (assinatura correta, não expirado, etc.)
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSigningKey()) // Usa a chave secreta
                    .build()
                    .parseClaimsJws(token); // Valida o token
            return true; // Se não lançar exceção, é válido
        } catch (JwtException | IllegalArgumentException e) {
            // Caso o token seja inválido ou tenha expirado
            System.out.println("Token inválido ou expirado: " + e.getMessage());
            return false;
        }
    }
}