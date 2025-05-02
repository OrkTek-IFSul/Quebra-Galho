package com.orktek.quebragalho.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import com.orktek.quebragalho.security.JwtUtil;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    public String autenticar(String email, String senha) {
        try {
            Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(email, senha));

            return jwtUtil.generateToken(auth.getName()); // geralmente o email
        } catch (Exception e) {
            throw new IllegalArgumentException("Credenciais inválidas");
        }
    }
}

