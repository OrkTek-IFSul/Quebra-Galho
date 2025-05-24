package com.orktek.quebragalho.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.dto.PrestadorDTO.AtualizarPrestadorDTO;
import com.orktek.quebragalho.dto.PrestadorDTO.PrestadorGenericoDTO;
import com.orktek.quebragalho.dto.UsuarioDTO.UsuarioGenericoDTO;
import com.orktek.quebragalho.model.Prestador;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.AvaliacaoRepository;
import com.orktek.quebragalho.repository.PrestadorRepository;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class PrestadorService {

    @Autowired
    private final AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private FileStorageService fileStorageService; // Para manipulação de arquivos

    @Autowired
    private PrestadorRepository prestadorRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    PrestadorService(AvaliacaoRepository avaliacaoRepository) {
        this.avaliacaoRepository = avaliacaoRepository;
    }

    // TODO UTILIZAR NA CONTROLLER DE CRIAÇÃO DE USUÁRIOS
    /**
     * Cria um novo prestador de serviço associado a um usuário
     * 
     * @param prestador Objeto Prestador com os dados
     * @param usuarioId ID do usuário que será o prestador
     * @return Prestador criado
     * @throws ResponseStatusException se usuário não existir ou já for prestador
     */
    @Transactional
    public PrestadorGenericoDTO criarPrestador(UsuarioGenericoDTO usuarioDTO, String descricao) {
        // Verifica se usuário existe
        Usuario usuario = usuarioRepository.findById(usuarioDTO.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario nao encontrado"));

        Prestador prestador = new Prestador();
        prestador.setDescricao(descricao);
        prestador.setUsuario(usuario);
        prestador.setDocumentoPath("");
        prestador.setDataHoraInicio(LocalDateTime.now());
        prestador.setDataHoraFim(LocalDateTime.now());
        // Salva o prestador no banco de dados
        prestadorRepository.save(prestador);

        // Cria um novo DTO com os dados do prestador
        PrestadorGenericoDTO RetornoPrestadorDTO = new PrestadorGenericoDTO();
        RetornoPrestadorDTO.setId(prestador.getId());
        RetornoPrestadorDTO.setDescricao(prestador.getDescricao());
        // Cria um novo DTO com os dados do usuário
        UsuarioGenericoDTO usuarioRetorno = new UsuarioGenericoDTO();
        usuarioRetorno.setId(usuario.getId());
        usuarioRetorno.setNome(usuario.getNome());
        usuarioRetorno.setEmail(usuario.getEmail());
        usuarioRetorno.setDocumento(usuario.getDocumento());
        usuarioRetorno.setTelefone(usuario.getTelefone());
        // Adiciona o usuário ao DTO do prestador
        RetornoPrestadorDTO.setUsuario(usuarioRetorno);
        // Retorna o DTO com os dados do prestador
        return RetornoPrestadorDTO;
    }

    /**
     * Lista todos os prestadores cadastrados
     * 
     * @return Lista de Prestador
     */
    public List<Prestador> listarTodos() {
        return prestadorRepository.findAll();
    }

    /**
     * Busca prestador pelo ID
     * 
     * @param id ID do prestador
     * @return Optional contendo o prestador se encontrado
     */
    public Optional<Prestador> buscarPorId(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID do prestador não pode ser nulo");
        }
        return prestadorRepository.findById(id);
    }

    /**
     * Busca prestador pelo ID do usuário associado
     * 
     * @param usuarioId ID do usuário
     * @return Optional contendo o prestador se encontrado
     */
    public Optional<Prestador> buscarPorUsuarioId(Long usuarioId) {
        return prestadorRepository.findByUsuarioId(usuarioId);
    }

    // TODO IMPLEMENTAR NA CONTROLLER DE ALTERAR PRESTADOR
    /**
     * Atualiza descricao de prestador
     * 
     * @param id ID do prestador
     * @return Prestador atualizado
     * @throws ResponseStatusException se prestador não for encontrado
     */
    @Transactional
    public void atualizarPrestador(Long id, AtualizarPrestadorDTO dto) {
        Prestador prestador = prestadorRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador não encontrado"));

        // Atualizar campos simples
        prestador.setDescricao(dto.getDescricao());
        prestador.setDataHoraInicio(dto.getHorarioInicio());
        prestador.setDataHoraFim(dto.getHorarioFim());

        // Atualizar usuário se necessário
        if (dto.getUsuario() != null) {
            Usuario usuario = prestador.getUsuario();
            usuario.setNome(dto.getUsuario().getNome());
            usuario.setEmail(dto.getUsuario().getEmail());
            usuario.setTelefone(dto.getUsuario().getTelefone());
            usuario.setDocumento(dto.getUsuario().getDocumento());
            usuarioRepository.save(usuario);
        }
        prestadorRepository.save(prestador);
    }
    
    /**
     * Remove um prestador do sistema
     * 
     * @param id ID do prestador
     */
    @Transactional
    public void deletarPrestador(Long id) {
        prestadorRepository.deleteById(id);
    }

    public double mediaNotaPrestador(Long prestadorId) {
        return avaliacaoRepository.calcularMediaAvaliacoesPorPrestador(prestadorId);
    }

    /**
     * Adiciona a imagem de documento do prestador
     * 
     * @param prestadorId ID do prestador
     * @param documento   Arquivo de imagem a ser salvo
     * @return Nome do arquivo salvo
     * @throws ResponseStatusException se usuário não for encontrado ou ocorrer erro
     *                                 no upload
     */
    @Transactional
    public String enviarImagemDocumento(Long prestadorId, MultipartFile documento) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador nao encontrado"));

        try {
            // Remove a imagem antiga se existir
            if (prestador.getDocumentoPath() != null) {
                fileStorageService.deleteFile(prestador.getDocumentoPath());
            }

            // Salva a nova imagem
            String nomeArquivo = fileStorageService.storeFile(documento);
            prestador.setDocumentoPath(nomeArquivo);
            prestadorRepository.save(prestador);

            return nomeArquivo;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Falha ao enviar imagem de documento", e);
        }
    }

    /**
     * Obtém o caminho do arquivo de imagem do documento do prestador
     * 
     * @param prestadorId ID do prestador
     * @return Caminho do arquivo
     */
    public Path getFilePath(Long prestadorId) {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prestador não encontrado"));

        return fileStorageService.getFilePath(prestador.getDocumentoPath());
    }

    /**
     * Carrega a imagem do documento do prestador como recurso
     * 
     * @param prestadorId ID do prestador
     * @return Recurso da imagem
     */
    public Resource carregarImagemDocumento(Long prestadorId) throws FileNotFoundException {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(
                        () -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                "Documento do prestador não encontrado"));

        return fileStorageService.loadFileAsResource(prestador.getDocumentoPath());
    }

    /**
     * Obtém os bytes da imagem do documento do prestador
     * 
     * @param prestadorId ID do prestador
     * @return Bytes da imagem
     */
    public byte[] obterBytesImagem(Long prestadorId) throws IOException {
        Prestador prestador = prestadorRepository.findById(prestadorId)
                .orElseThrow(
                        () -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                "Documento do prestador não encontrado"));

        Path imagePath = fileStorageService.getFilePath(prestador.getDocumentoPath());
        return Files.readAllBytes(imagePath);
    }
}