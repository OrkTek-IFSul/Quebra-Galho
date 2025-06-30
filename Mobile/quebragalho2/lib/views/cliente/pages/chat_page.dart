import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int?> obterIdUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuario_id');
}

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  int? _currentUserId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final id = await obterIdUsuario();
    setState(() {
      _currentUserId = id;
    });
    print('Current User ID: $_currentUserId'); // Debug
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentUserId == null) {
      print('Mensagem vazia ou usuário não identificado'); // Debug
      return;
    }

    if (_isLoading) return; // Previne múltiplos envios

    setState(() {
      _isLoading = true;
    });

    final messageText = _messageController.text.trim();
    _messageController.clear(); // Limpa antes de enviar

    try {
      print('Enviando mensagem para chat: ${widget.chatId}'); // Debug
      print('ID do usuário local: $_currentUserId'); // Debug

      // Cria o documento do chat se não existir
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId);

      // Verifica se o chat existe, se não, cria
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'participants': [_currentUserId.toString()],
          'lastMessage': '',
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('Chat criado: ${widget.chatId}');
      }

      // Salva a mensagem na subcoleção 'messages'
      await chatRef.collection('messages').add({
        'text': messageText,
        'senderId': _currentUserId.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Atualiza o documento do chat com a última mensagem e timestamp
      await chatRef.update({
        'lastMessage': messageText,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });

      print('Mensagem enviada com sucesso!'); // Debug
    } catch (e) {
      print('Erro ao enviar mensagem: $e'); // Debug
      // Recoloca o texto no campo se houver erro
      _messageController.text = messageText;
      
      // Mostra erro para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar mensagem: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isCurrentUser ? const Color.fromARGB(255, 44, 44, 44) : const Color.fromARGB(255, 192, 192, 192),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          messageData['text'] ?? '',
          style: TextStyle(
            color: isCurrentUser ? Colors.white : const Color.fromARGB(221, 85, 85, 85),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  print('Erro no StreamBuilder: ${snapshot.error}'); // Debug
                  return Center(
                    child: Text('Erro ao carregar mensagens: ${snapshot.error}'),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Envie a primeira mensagem!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;
                print('Número de mensagens: ${messages.length}'); // Debug

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data() as Map<String, dynamic>;
                    bool isCurrentUser = messageData['senderId'] == _currentUserId.toString();
                    
                    return _buildMessageBubble(messageData, isCurrentUser);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Digite sua mensagem...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}