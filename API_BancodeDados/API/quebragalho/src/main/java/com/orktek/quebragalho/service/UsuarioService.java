package com.orktek.quebragalho.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.UsuarioRepository;

import jakarta.transaction.Transactional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder; // Para criptografar senhas

    @Autowired
    private FileStorageService fileStorageService;// Para manipulação de arquivos

    /**
     * Cria um novo usuário no sistema
     * 
     * @param usuario Objeto Usuario com os dados do novo usuário
     * @return Usuario salvo no banco de dados
     * @throws ResponseStatusException se email ou documento já estiverem
     *                                 cadastrados
     */
    @Transactional
    public Usuario criarUsuario(Usuario usuario) {
        // Verifica se email já está em uso
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "E-mail já existe");
        }

        // Verifica se documento já está cadastrado
        if (usuarioRepository.existsByDocumento(usuario.getDocumento())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Documento já existe");
        }

        // Criptografa a senha antes de salvar
        usuario.setSenha(passwordEncoder.encode(usuario.getSenha()));
        return usuarioRepository.save(usuario);
    }

    /**
     * Lista todos os usuários cadastrados
     * 
     * @return Lista de Usuario
     */
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    /**
     * Busca um usuário pelo ID
     * 
     * @param id ID do usuário
     * @return Optional contendo o usuário se encontrado
     */
    public Optional<Usuario> buscarPorId(Long id) {
        return usuarioRepository.findById(id);
    }

    public String getNomeUsuario(Long id) {
        return usuarioRepository.findById(id).map(Usuario::getNome)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));
    }

    /**
     * Atualiza os dados de um usuário existente
     * 
     * @param id                ID do usuário a ser atualizado
     * @param usuarioAtualizado Objeto com os novos dados
     * @return Usuario atualizado
     * @throws ResponseStatusException se usuário não for encontrado ou email já
     *                                 estiver em uso
     */
    @Transactional
    public Usuario atualizarUsuario(Long id, Usuario usuarioAtualizado) {
        return usuarioRepository.findById(id)
                .map(usuario -> {
                    // Verifica se está tentando mudar o email
                    if (!usuario.getEmail().equals(usuarioAtualizado.getEmail())) {
                        // Verifica se novo email já está em uso
                        if (usuarioRepository.existsByEmail(usuarioAtualizado.getEmail())) {
                            throw new ResponseStatusException(HttpStatus.CONFLICT, "E-mail já está em uso");
                        }
                    }

                    // Atualiza apenas os campos permitidos
                    usuario.setNome(usuarioAtualizado.getNome());
                    usuario.setEmail(usuarioAtualizado.getEmail());
                    usuario.setTelefone(usuarioAtualizado.getTelefone());
                    usuario.setImgPerfil(usuarioAtualizado.getImgPerfil());

                    return usuarioRepository.save(usuario);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));
    }

    /**
     * Remove um usuário do sistema
     * 
     * @param id ID do usuário a ser removido
     */
    @Transactional
    public void deletarUsuario(Long id) {
        usuarioRepository.deleteById(id);
    }

    /**
     * Busca usuário pelo email
     * 
     * @param email Email do usuário
     * @return Optional contendo o usuário se encontrado
     */
    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email);
    }

    /**
     * Adiciona um strike (marca de advertência) ao usuário
     * 
     * @param usuarioId ID do usuário
     */
    public void adicionarStrike(Long usuarioId) {
        usuarioRepository.findById(usuarioId).ifPresent(usuario -> {
            usuario.setNumStrike(usuario.getNumStrike() + 1);
            usuarioRepository.save(usuario);
        });
    }

    /**
     * Atualiza a imagem de perfil do usuário
     * 
     * @param usuarioId    ID do usuário
     * @param imagemPerfil Arquivo de imagem a ser salvo
     * @return Nome do arquivo salvo
     * @throws ResponseStatusException se usuário não for encontrado ou ocorrer erro
     *                                 no upload
     */
    @Transactional
    public String atualizarImagemPerfil(Long usuarioId, MultipartFile imagemPerfil) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

        try {
            // Remove a imagem antiga se existir
            if (usuario.getImgPerfil() != null) {
                fileStorageService.deleteFile(usuario.getImgPerfil());
            }

            // Salva a nova imagem
            String nomeArquivo = fileStorageService.storeFile(imagemPerfil);
            usuario.setImgPerfil(nomeArquivo);
            usuarioRepository.save(usuario);

            return nomeArquivo;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Erro ao atualizar imagem de perfil", e);
        }
    }

    /**
     * Remove a imagem de perfil do usuário
     * 
     * @param usuarioId ID do usuário
     * @throws ResponseStatusException se usuário não for encontrado ou ocorrer erro
     *                                 ao remover
     */
    @Transactional
    public void removerImagemPerfil(Long usuarioId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

        if (usuario.getImgPerfil() != null) {
            try {
                fileStorageService.deleteFile(usuario.getImgPerfil());
                usuario.setImgPerfil(null);
                usuarioRepository.save(usuario);
            } catch (IOException e) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "Erro ao remover imagem de perfil", e);
            }
        }
    }

    /**
     * Obtém o caminho do arquivo de imagem do usuário
     * 
     * @param usuarioId ID do usuário
     * @return Caminho do arquivo
     */
    public Path getFilePath(Long usuarioId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

        return fileStorageService.getFilePath(usuario.getImgPerfil());
    }

    /**
     * Carrega a imagem de um usuário como recurso
     * 
     * @param usuarioId ID do usuário
     * @return Recurso da imagem
     */
    public Resource carregarImagemUsuario(Long usuarioId) throws FileNotFoundException {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(
                        () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

        return fileStorageService.loadFileAsResource(usuario.getImgPerfil());
    }

    /**
     * Obtém os bytes da imagem do usuário
     * 
     * @param usuarioId ID do usuário
     * @return Bytes da imagem
     */
    public byte[] obterBytesImagem(Long usuarioId) throws IOException {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(
                        () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuário não encontrado"));

        Path imagePath = fileStorageService.getFilePath(usuario.getImgPerfil());
        return Files.readAllBytes(imagePath);
    }
}
