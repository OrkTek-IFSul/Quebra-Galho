package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@Primary
// Classe responsável por carregar os dados do usuário com base no e-mail
// fornecido.
// Essa classe é usada pelo Spring Security no processo de autenticação.
public class UsuarioDetailsService implements UserDetailsService {

    // Injeta o serviço que acessa os dados dos usuários (provavelmente do banco de
    // dados)
    @Autowired
    private UsuarioService usuarioService;

    // Método obrigatório da interface UserDetailsService
    // Ele é chamado pelo Spring Security para buscar o usuário a partir do e-mail
    // (username)
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // Tenta buscar o usuário com base no e-mail informado
        return (UserDetails) usuarioService.buscarPorEmail(email)
                // Se não encontrar o usuário, lança exceção que indica "usuário não encontrado"
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o email: " + email));
    }
}
