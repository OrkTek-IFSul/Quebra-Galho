package com.orktek.quebragalho.security;

import java.io.IOException;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    // Injeta a utilitária JwtUtil que fornece métodos para trabalhar com o token
    // JWT
    @Autowired
    private JwtUtil jwtUtil;

    // Injeta o serviço que carrega os dados do usuário (implementa
    // UserDetailsService)
    @Autowired
    private UserDetailsService userDetailsService;

    // Método principal que intercepta todas as requisições HTTP
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        // Extrai o cabeçalho Authorization da requisição
        String authHeader = request.getHeader("Authorization");

        // Verifica se o cabeçalho contém um token JWT iniciado com "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            // Remove o prefixo "Bearer " e extrai o token JWT
            String token = authHeader.substring(7);
            // Obtém o nome do usuário a partir do token
            String username = jwtUtil.getUsernameFromToken(token);

            // Verifica se o usuário foi extraído e se ainda não há autenticação no contexto
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // Carrega os detalhes do usuário (como roles/autoridades)
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                // Verifica se o token é válido
                if (jwtUtil.validateToken(token)) {
                    // Cria o objeto de autenticação com os dados do usuário
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());

                    // Associa informações adicionais da requisição à autenticação
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                    // Define a autenticação no contexto de segurança
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        }

        // Continua o fluxo da requisição
        filterChain.doFilter(request, response);
    }
}