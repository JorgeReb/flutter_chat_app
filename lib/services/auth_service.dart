import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthService with ChangeNotifier {

  Usuario usuario = Usuario(nombre: '', email: '', online: false, uid: '');
  bool _authenticating = false;

  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating(bool valor) {
    _authenticating = valor;
    notifyListeners();
  }

  //GETTERS DEL TOKEN de forma estática
  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future login(String email, String password) async {

    authenticating = true;

    final data = {"email": email, "password": password};
    final uri = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(uri,body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    authenticating = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }
  }


   Future register(String nombre, String email, String password) async {

    authenticating = true;

    final data = {"nombre": nombre,"email": email, "password": password};
    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(uri,body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    authenticating = false;

    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      usuario = registerResponse.usuario;
      await _guardarToken(registerResponse.token);

      return true;
    }else{
      return false;
    }
  }

  Future<bool> isLoggedIn() async{

    final token = await _storage.read(key: 'token') ?? '';
    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(uri,headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      _logOut();
      return false;
    }
  }

  Future _guardarToken( String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future _logOut() async{
    await _storage.delete(key: 'token');
  }
}
