package com.orktek.quebragalho.controller.controller_views;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.orktek.quebragalho.model.Usuario;
import com.orktek.quebragalho.repository.UsuarioRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

/**
 * Controller para operações da tela de cadastro
 * de usuários e prestadores
 */
@RestController
@RequestMapping("/api/chats")
@Tag(name = "Chat Controller", description = "Operações relacionadas ao gerenciamento do chat entre usuários e prestadores")
public class ChatController {

    @Autowired
    private UsuarioRepository usuarioRepository;

        @Operation(summary = "Listar chats", description = "Listar chats do usuário informado pelo ID")
        @GetMapping("/{usuarioId}")
        public ResponseEntity<List<Map<String, Object>>> getMyChats(@PathVariable String usuarioId) throws Exception {
            // Buscar o usuário pelo ID recebido na URL
            Usuario usuario = usuarioRepository.findById(Long.parseLong(usuarioId)).orElseThrow();
            String usuarioLogadoId = usuario.getId().toString();

            // Conectar ao Firestore
            Firestore db = FirestoreClient.getFirestore();

            // Criar a query para buscar chats onde o usuário é um participante
            ApiFuture<QuerySnapshot> query = db.collection("chats")
                    .whereArrayContains("participants", usuarioLogadoId)
                    .orderBy("lastMessageTimestamp", Query.Direction.DESCENDING)
                    .get();

            // Processar os resultados
            List<Map<String, Object>> chats = new ArrayList<>();
            QuerySnapshot querySnapshot = query.get();
            for (DocumentSnapshot document : querySnapshot.getDocuments()) {
                chats.add(document.getData());
            }

            return ResponseEntity.ok(chats);
        }

}
