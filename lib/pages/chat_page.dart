import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;
  final List<ChatMessage> _messages =  [];
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

 
 
 void _escucharMensaje( dynamic payload) {
  ChatMessage message = ChatMessage(texto: payload['mensaje'], uid: payload['de']);

  setState(() {
    _messages.insert(0,message);
  });
 }



  @override
  void initState() {
    super.initState();
      
    chatService = Provider.of<ChatService>(context,listen: false);
    socketService = Provider.of<SocketService>(context,listen: false);
    authService = Provider.of<AuthService>(context,listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);

  }

  void _cargarHistorial( String usuarioID) async{
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uid: m.de
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {

    final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child:  Text(
                usuarioPara.nombre.substring(0,2),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().isNotEmpty) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                        child: const Text('Enviar'),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.send),
                              onPressed: _isWriting
                                  ? () =>
                                      _handleSubmit(_textController.text.trim())
                                  : null),
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {

    if(texto.isEmpty) return; 
    
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(texto: texto, uid: authService.usuario.uid);
    _messages.insert(0, newMessage);

    setState(() {
      _isWriting = false;
    });

    socketService.emit('mensaje-personal', {
      'de'     : authService.usuario.uid,
      'para'   : chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }
  
  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
