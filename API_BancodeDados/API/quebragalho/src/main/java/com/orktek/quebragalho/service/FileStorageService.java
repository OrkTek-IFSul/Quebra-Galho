package com.orktek.quebragalho.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileStorageService {

    @Value("${app.upload.dir}")
    private String uploadDir;

    /**
     * Armazena um arquivo no sistema de arquivos
     * @param file Arquivo a ser armazenado
     * @return Nome do arquivo armazenado
     * @throws IOException se ocorrer erro ao armazenar
     */
    public String storeFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("Arquivo vazio");
        }

        // Valida o tipo de arquivo (apenas imagens)
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("Apenas arquivos de imagem são permitidos");
        }

        // Gera um nome único para o arquivo
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        
        // Cria o diretório se não existir
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Salva o arquivo
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath);

        return fileName;
    }

    /**
     * Remove um arquivo do sistema de arquivos
     * @param fileName Nome do arquivo a ser removido
     * @throws IOException se ocorrer erro ao remover
     */
    public void deleteFile(String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            return;
        }
        
        Path filePath = Paths.get(uploadDir).resolve(fileName);
        Files.deleteIfExists(filePath);
    }

        /**
     * Carrega um arquivo como recurso
     * @param fileName Nome do arquivo a ser carregado
     * @return Recurso do arquivo
     * @throws FileNotFoundException se o arquivo não existir
     */
    public Resource loadFileAsResource(String fileName) throws FileNotFoundException {
        try {
            Path filePath = Paths.get(uploadDir).resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new FileNotFoundException("Arquivo não encontrado: " + fileName);
            }
        } catch (MalformedURLException ex) {
            throw new FileNotFoundException("Arquivo não encontrado: " + fileName);
        }
    }

    /**
     * Obtém o caminho completo do arquivo
     * @param fileName Nome do arquivo
     * @return Caminho completo
     */
    public Path getFilePath(String fileName) {
        return Paths.get(uploadDir).resolve(fileName).normalize();
    }
}
