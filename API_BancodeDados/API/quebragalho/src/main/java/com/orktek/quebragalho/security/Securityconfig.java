package com.orktek.quebragalho.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class Securityconfig {
    // Injeta o filtro JWT personalizado responsável por interceptar as requisições
    @Autowired
    @Lazy // Injeta o filtro JWT de forma atrasada para evitar problemas de inicialização circular
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    // Define o bean de AuthenticationManager, necessário para autenticar usuários
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        // Retorna o gerenciador de autenticação configurado automaticamente pelo Spring
        return config.getAuthenticationManager();
    }

    // Define a cadeia de filtros de segurança (SecurityFilterChain)
    @SuppressWarnings("removal")
    @Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable()) // Desabilita a proteção CSRF, pois não é necessária para APIs REST
        .cors(cors -> cors.configure(http))  // Configura o CORS (Cross-Origin Resource Sharing) para permitir requisições de diferentes origens
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/auth/login", "/api/usuarios").permitAll()  // Permite acesso público às rotas de login e cadastro de usuários
            .anyRequest().authenticated() // Exige autenticação para todas as outras rotas
        )
        .sessionManagement(session -> session
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        );
    
    // Adicione o filtro JWT ANTES do UsernamePasswordAuthenticationFilter
    http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
    
    return http.build();
}

    // Define um bean para codificação de senhas usando o algoritmo BCrypt
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}