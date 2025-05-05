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
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    // Injeta o filtro JWT personalizado responsável por interceptar as requisições
    @Autowired
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
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf().disable() // Desabilita CSRF porque o sistema usa tokens (JWT) ao invés de cookies
                .authorizeHttpRequests()
                // Permite acesso público sem autenticação a qualquer endpoint que comece com
                // /api/auth/
                .requestMatchers("/api/auth/**").permitAll()
                // Requer autenticação para qualquer outra rota
                .anyRequest().authenticated()
                .and()
                // Define que a aplicação não irá manter sessões (stateless)
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        // Adiciona o filtro JWT antes do filtro padrão de autenticação por
        // usuário/senha
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        // Constrói e retorna a cadeia de filtros
        return http.build();
    }

    // Define um bean para codificação de senhas usando o algoritmo BCrypt
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}