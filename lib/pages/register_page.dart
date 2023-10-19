import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:chat/helpers/mostrar_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';



class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Column(
              children: [
                Logo(titulo: 'Registro'),
                _Form(),
                SizedBox(height: 30),
                Labels(
                  ruta: 'login',
                  titulo: '¿Ya tienes cuenta?',
                  subTitulo: '¡Inicia sesión aquí!',
                ),
                Text(
                  'Término y condiciones de uso',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
        final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.visiblePassword,
            textController: passwordCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Registrar',
            onPressed: () async {
              FocusScope.of(context).unfocus();

              final registerOk = await authService.register(nameCtrl.text.trim(),emailCtrl.text.trim(), passwordCtrl.text.trim());

              if (registerOk) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                // ignore: use_build_context_synchronously
                mostrarAlert(context, 'Registro incorrecto', 'El correo ya está registrado');
              }
            },
          ),
        ],
      ),
    );
  }
}
