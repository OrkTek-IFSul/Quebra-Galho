package com.orktek.quebragalho.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.TagRepository;

@Service
public class TagPrestadorService {

    @Autowired
    private PrestadorRepository prestadorRepository;
    
    @Autowired
    private TagRepository tagRepository;

    /**
     * Adiciona uma tag a um prestador
     * @param prestadorId ID do prestador
     * @param tagId ID da tag
     * @throws ResponseStatusException se prestador ou tag não existirem
     */
    @Transactional
    public void adicionarTagAoPrestador(Long prestadorId, Long tagId) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        Tags tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag nao encontrada"));
        
        prestador.getTags().add(tag);
        prestadorRepository.save(prestador);
    }

    /**
     * Remove uma tag de um prestador
     * @param prestadorId ID do prestador
     * @param tagId ID da tag
     * @throws ResponseStatusException se prestador ou tag não existirem
     */
    @Transactional
    public void removerTagDoPrestador(Long prestadorId, Long tagId) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        Tags tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag nao encontrada"));
        
        prestador.getTags().remove(tag);
        prestadorRepository.save(prestador);
    }

    /**
     * Lista os IDs das tags associadas a um prestador
     * @param prestadorId ID do prestador
     * @return Lista de IDs das tags associadas ao prestador
     * @throws ResponseStatusException se o prestador não existir
     */
    public List<Long> listarTagsPorPrestador(Long prestadorId) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        return prestador.getTags().stream()
                .map(Tags::getId)
                .toList();
    }
}