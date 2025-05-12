package com.orktek.quebragalho.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class Securityconfig {

    @Autowired
    @Lazy
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    // Configuração CORS completa
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("authorization", "content-type", "x-auth-token"));
        configuration.setExposedHeaders(Arrays.asList("x-auth-token"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Desativa CSRF (necessário para APIs stateless)
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // Mantém CORS ativo
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll() // ⚠️ Libera TODOS os endpoints sem autenticação
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
// @Configuration
// @EnableWebSecurity
// public class Securityconfig {
// // Injeta o filtro JWT personalizado responsável por interceptar as
// requisições
// @Autowired
// @Lazy // Injeta o filtro JWT de forma atrasada para evitar problemas de
// inicialização
// // circular
// private JwtAuthenticationFilter jwtAuthenticationFilter;

// // Define o bean de AuthenticationManager, necessário para autenticar
// usuários
// @Bean
// public AuthenticationManager
// authenticationManager(AuthenticationConfiguration config) throws Exception {
// // Retorna o gerenciador de autenticação configurado automaticamente pelo
// Spring
// return config.getAuthenticationManager();
// }

// // Define a cadeia de filtros de segurança (SecurityFilterChain)
// @SuppressWarnings("removal")
// @Bean
// public SecurityFilterChain securityFilterChain(HttpSecurity http) throws
// Exception {
// // Código anterior: Exigia autenticação para todas as outras rotas, exceto as
// // especificadas
// http
// .csrf(csrf -> csrf.disable()) // Desabilita a proteção CSRF, pois não é
// necessária para APIs REST
// .cors(cors -> cors.configure(http)) // Configura o CORS (Cross-OriginResource
// Sharing) para permitir
// // requisições de diferentes origens
// .authorizeHttpRequests(auth -> auth
// .requestMatchers(
// "/auth/login",
// "/api/usuarios",
// "/api/cadastro/usuario",
// "/api/cadastro/prestador",
// "/v3/api-docs/**", // Libera o JSON do OpenAPI
// "/swagger-ui/**", // Libera a UI do Swagger
// "/swagger-ui.html", // (Versões antigas)
// "/webjars/**", // Recursos estáticos
// "/swagger-resources/**" // (SpringFox)
// )
// .permitAll() // Permite acesso público às rotas
// // de login e cadastro de usuários
// .anyRequest().authenticated() // Exige autenticação para todas as outras
// rotas
// )
// .sessionManagement(session -> session
// .sessionCreationPolicy(SessionCreationPolicy.STATELESS));

// // // Novo código: Permite acesso público a todos os endpoints
// // http
// // .csrf(csrf -> csrf.disable()) // Desabilita a proteção CSRF, pois não é
// // necessária para APIs REST
// // .cors(cors -> cors.configure(http)) // Configura o CORS (Cross-Origin
// // Resource Sharing) para permitir
// // // requisições de diferentes origens
// // .authorizeHttpRequests(auth -> auth
// // .anyRequest().permitAll() // Permite acesso público a todas as rotas
// // )
// // .sessionManagement(session -> session
// // .sessionCreationPolicy(SessionCreationPolicy.STATELESS));

// // Adicione o filtro JWT ANTES do UsernamePasswordAuthenticationFilter
// http.addFilterBefore(jwtAuthenticationFilter,
// UsernamePasswordAuthenticationFilter.class);

// return http.build();
// }

// // Define um bean para codificação de senhas usando o algoritmo BCrypt
// @Bean
// public PasswordEncoder passwordEncoder() {
// return new BCryptPasswordEncoder();
// }
// }