import 'package:chat/global/environment.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioId) async {

    final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId');
    String? token = await AuthService.getToken();
    
    final resp = await http.get(uri,
    headers: {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}