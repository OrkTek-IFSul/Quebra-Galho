package com.orktek.quebragalho.service;

import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.orktek.quebragalho.model.Usuario;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseMessagingService {

    private final FirebaseMessaging firebaseMessaging;

    public FirebaseMessagingService(FirebaseMessaging firebaseMessaging) {
        this.firebaseMessaging = firebaseMessaging;
    }

    /**
     * NOVO MÉTODO ORQUESTRADOR:
     * Este é o método principal que você deve chamar de outros serviços (como AgendamentoService).
     * Ele lida tanto com a notificação interna (Firestore) quanto com o push (FCM).
     *
     * @param destinatario O objeto completo do usuário que receberá a notificação.
     * @param titulo O título da notificação.
     * @param mensagem O corpo da notificação.
     * @param link O link para redirecionamento dentro do app (ex: /agendamentos/4).
     */
    public void enviarNotificacaoCompleta(Usuario destinatario, String titulo, String mensagem, String link) {
        // Passo 1: Cria a notificação persistente no Firestore para a lista do app.
        criarNotificacaoNoFirestore(destinatario, titulo, mensagem, link);

        // Passo 2: Envia a notificação push para o dispositivo, se o usuário tiver um token.
        if (destinatario.getToken() != null && !destinatario.getToken().isEmpty()) {
            try {
                // O mapa de dados do push pode conter o link para o app usar ao ser aberto pelo push
                Map<String, String> data = Map.of("link", link != null ? link : "");
                sendPushNotification(titulo, mensagem, destinatario.getToken(), data);
            } catch (FirebaseMessagingException e) {
                // Logar o erro de push, mas não impedir o fluxo, pois a notificação interna já foi salva.
                System.err.println("Erro ao enviar notificação push: " + e.getMessage());
            }
        }
    }

    /**
     * MÉTODO PRIVADO: Cria o registro da notificação na coleção 'notificacoes' do Firestore.
     */
    private void criarNotificacaoNoFirestore(Usuario destinatario, String titulo, String mensagem, String link) {
        try {
            Firestore db = FirestoreClient.getFirestore();
            Map<String, Object> notificacaoData = new HashMap<>();
            
            notificacaoData.put("destinatarioId", destinatario.getId().toString());
            notificacaoData.put("titulo", titulo);
            notificacaoData.put("mensagem", mensagem);
            notificacaoData.put("linkRedirecionamento", link);
            notificacaoData.put("lida", false);
            notificacaoData.put("dataCriacao", FieldValue.serverTimestamp());

            // Adiciona um novo documento com um ID gerado automaticamente na coleção 'notificacoes'
            db.collection("notificacoes").add(notificacaoData).get();
            System.out.println("Notificação interna criada com sucesso no Firestore para o usuário: " + destinatario.getId());

        } catch (InterruptedException | ExecutionException e) {
            System.err.println("Erro ao salvar notificação no Firestore: " + e.getMessage());
            // Lidar com o erro de escrita no Firestore
        }
    }

    /**
     * MÉTODO PRIVADO: Envia a notificação PUSH via FCM. Renomeado para maior clareza.
     * (Este é o seu método original, agora chamado internamente).
     */
    private String sendPushNotification(String title, String body, String token, Map<String, String> data) throws FirebaseMessagingException {
        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(body)
                .build();

        Message message = Message.builder()
                .setToken(token) // Token FCM do dispositivo de destino
                .setNotification(notification)
                .putAllData(data) // Dados customizados para o app (ex: para deep linking)
                .build();

        return firebaseMessaging.send(message);
    }
}