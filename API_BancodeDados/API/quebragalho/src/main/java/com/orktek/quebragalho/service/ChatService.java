package com.orktek.quebragalho.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Chat;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.ChatRepository;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class ChatService {

    @Autowired
    private ChatRepository chatRepository;
    
    @Autowired
    private UsuarioRepository usuarioRepository;
    
    @Autowired
    private PrestadorRepository prestadorRepository;

    /**
     * Envia uma mensagem no chat entre usuário e prestador
     * @param chat Objeto Chat com a mensagem
     * @param usuarioId ID do usuário remetente
     * @param prestadorId ID do prestador destinatário
     * @return Chat salvo
     * @throws ResponseStatusException se usuário ou prestador não existirem
     */
    @Transactional
    public Chat enviarMensagem(Chat chat, Long usuarioId, Long prestadorId) {
        // Verifica se usuário existe
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario nao encontrado"));
        
        // Verifica se prestador existe
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        // Configura os relacionamentos e data
        chat.setUsuario(usuario);
        chat.setPrestador(prestador);
        chat.setData(LocalDate.now());
        
        return chatRepository.save(chat);
    }

    /**
     * Lista mensagens de uma conversa específica entre usuário e prestador
     * @param usuarioId ID do usuário
     * @param prestadorId ID do prestador
     * @return Lista de Chat ordenada por data
     */
    public List<Chat> listarConversa(Long usuarioId, Long prestadorId) {
        return chatRepository.findByUsuarioIdAndPrestadorIdOrderByData(usuarioId, prestadorId);
    }
    
    /**
     * Lista todas as mensagens de um usuário (todas as conversas)
     * @param usuarioId ID do usuário
     * @return Lista de Chat ordenada por data
     */
    public List<Chat> listarTodasMensagensUsuario(Long usuarioId) {
        return chatRepository.findByUsuarioIdOrderByData(usuarioId);
    }
    
    /**
     * Lista todas as mensagens de um prestador (todas as conversas)
     * @param prestadorId ID do prestador
     * @return Lista de Chat ordenada por data
     */
    public List<Chat> listarTodasMensagensPrestador(Long prestadorId) {
        return chatRepository.findByPrestadorIdOrderByData(prestadorId);
    }
}