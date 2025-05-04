package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Portfolio;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.repository.PortfolioRepository;
import com.orktek.quebragalho.repository.PrestadorRepository;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class PortfolioService {

    @Autowired
    private PortfolioRepository portfolioRepository;
    
    @Autowired
    private PrestadorRepository prestadorRepository;
    
    @Autowired
    private FileStorageService fileStorageService; // Novo

    /**
     * Adiciona um item ao portfólio com upload de imagem
     * @param imagemPortfolio Arquivo de imagem do portfólio
     * @param prestadorId ID do prestador
     * @return Portfolio criado
     * @throws RuntimeException se prestador não for encontrado ou ocorrer erro no upload
     */
    @Transactional
    public Portfolio adicionarAoPortfolio(MultipartFile imagemPortfolio, Long prestadorId) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));
        
        try {
            String nomeArquivo = fileStorageService.storeFile(imagemPortfolio);
            
            Portfolio portfolio = new Portfolio();
            portfolio.setImgPortfolioPath(nomeArquivo);
            portfolio.setPrestador(prestador);
            
            return portfolioRepository.save(portfolio);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Falha ao adicionar item ao portfolio",e);
        }
    }

    /**
     * Lista todos os itens de portfólio de um prestador
     * @param prestadorId ID do prestador
     * @return Lista de Portfolio
     */
    public List<Portfolio> listarPorPrestador(Long prestadorId) {
        return portfolioRepository.findByPrestadorId(prestadorId);
    }

    /**
     * Busca um item de portfólio pelo ID
     * @param id ID do item
     * @return Optional contendo o item se encontrado
     */
    public Optional<Portfolio> buscarPorId(Long id) {
        return portfolioRepository.findById(id);
    }

    /**
     * Remove um item do portfólio e sua imagem associada
     * @param id ID do item do portfólio
     * @throws RuntimeException se item não for encontrado ou ocorrer erro ao remover
     */
    @Transactional
    public void removerDoPortfolio(Long id) {
        Portfolio portfolio = portfolioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item do portfolio nao encontrado"));
        
        try {
            // Remove o arquivo de imagem
            fileStorageService.deleteFile(portfolio.getImgPortfolioPath());
            
            // Remove o item do banco de dados
            portfolioRepository.delete(portfolio);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Falha ao remover item do portfolio",e);
        }
    }
}