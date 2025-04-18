package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.orktek.quebragalho.model.Tag;
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
    public Tag criarTag(Tag tag) {
        return tagRepository.save(tag);
    }

    /**
     * Lista todas as tags cadastradas
     * @return Lista de Tag
     */
    public List<Tag> listarTodas() {
        return tagRepository.findAll();
    }

    /**
     * Busca uma tag pelo ID
     * @param id ID da tag
     * @return Optional contendo a tag se encontrada
     */
    public Optional<Tag> buscarPorId(Long id) {
        return tagRepository.findById(id);
    }

    /**
     * Atualiza os dados de uma tag
     * @param id ID da tag a ser atualizada
     * @param tagAtualizada Objeto com os novos dados
     * @return Tag atualizada
     * @throws RuntimeException se tag não for encontrada
     */
    @Transactional
    public Tag atualizarTag(Long id, Tag tagAtualizada) {
        return tagRepository.findById(id)
                .map(tag -> {
                    tag.setNome(tagAtualizada.getNome());
                    tag.setStatus(tagAtualizada.getStatus());
                    return tagRepository.save(tag);
                })
                .orElseThrow(() -> new RuntimeException("Tag não encontrada"));
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
