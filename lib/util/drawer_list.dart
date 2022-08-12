import 'package:cadastrosimples/usuario/usuario.dart';
import 'package:cadastrosimples/usuario/usuario_page.dart';
import 'package:cadastrosimples/util/nav.dart';
import 'package:cadastrosimples/util/prefs.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({Key? key}) : super(key: key);

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  UserAccountsDrawerHeader _header(user) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)])),
      accountName: Text(user.nome),
      accountEmail: const Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<Usuario?> future = Usuario.get();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<Usuario?>(
              future: future,
              builder: (context, snapshot) {
                Usuario? user = snapshot.data;
                // ignore: unnecessary_null_comparison
                return user != null ? _header(user) : Container();
              },
            ),
            ListTile(
              title: const Text("Sair"),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () => _onClickLogout(context),
            )
          ],
        ),
      ),
    );
  }
}

_onClickLogout(BuildContext context) {
  Prefs.setString("nome", "");
  Navigator.pop(context);
  push(context, const UsuarioPage(), replace: true);
}
