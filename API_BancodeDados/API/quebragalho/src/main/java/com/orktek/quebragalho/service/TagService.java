package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Tags;
import com.orktek.quebragalho.repository.TagRepository;

import java.util.List;
import java.util.Optional;

@Service
public class TagService {

    @Autowired
    private TagRepository tagRepository;

    /**
     * Cria uma nova tag no sistema
     * @param tag Objeto Tag com os dados
     * @return Tag salva no banco
     */
    @Transactional
    public Tags criarTag(Tags tag) {
        return tagRepository.save(tag);
    }

    /**
     * Lista todas as tags cadastradas
     * @return Lista de Tag
     */
    public List<Tags> listarTodas() {
        return tagRepository.findAll();
    }

    public List<Tags> listarTodasAtivas() {
        return tagRepository.findByStatus("Ativo"); // Assumindo que seu repository tem este método
    }

    /**
     * Busca uma tag pelo ID
     * @param id ID da tag
     * @return Optional contendo a tag se encontrada
     */
    public Optional<Tags> buscarPorId(Long id) {
        return tagRepository.findById(id);
    }

    /**
     * Atualiza os dados de uma tag
     * @param id ID da tag a ser atualizada
     * @param tagAtualizada Objeto com os novos dados
     * @return Tag atualizada
     */
    @Transactional
    public Tags atualizarTag(Long id, Tags tagAtualizada) {
        return tagRepository.findById(id)
                .map(tag -> {
                    tag.setNome(tagAtualizada.getNome());
                    tag.setStatus(tagAtualizada.getStatus());
                    return tagRepository.save(tag);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tag nao encontrada"));
    }

    /**
     * Remove uma tag do sistema
     * @param id ID da tag a ser removida
     */
    @Transactional
    public void deletarTag(Long id) {
        tagRepository.deleteById(id);
    }
}
