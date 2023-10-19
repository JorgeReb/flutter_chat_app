import 'package:chat/pages/pages.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
        future: checkLoginState(context),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authenticated = await authService.isLoggedIn();

    if (authenticated) {
      // ignore: use_build_context_synchronously
      socketService.connect();
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_,__,___) => const UsuariosPage(),
        transitionDuration: const Duration(milliseconds: 0)));
    } else {
         // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_,__,___) => const LoginPage(),
        transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
