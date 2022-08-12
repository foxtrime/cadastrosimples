import 'package:cadastrosimples/cadastro/cadastro_page.dart';
import 'package:cadastrosimples/usuario/usuario.dart';
import 'package:cadastrosimples/util/nav.dart';
import 'package:cadastrosimples/util/prefs.dart';
import 'package:flutter/material.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  bool _showProgress = false;
  final _formKey = GlobalKey<FormState>();
  final _txtnome = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<Usuario?> future = Usuario.get();
    future.then((Usuario? user) {
      if (user != null) {
        push(context, const CadastroPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nome do Operador"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)])),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _nbody(),
    );
  }

  _nbody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    child: TextFormField(
                      controller: _txtnome,
                      decoration:
                          const InputDecoration(hintText: "Nome Completo"),
                      validator: (value) =>
                          value!.isEmpty ? "Preencha o nome " : null,
                    ),
                  ),
                  Container(
                    height: 45,
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 1.2,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: _onClickNextPage,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: _showProgress
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                alignment: Alignment.center,
                                child: const Text(
                                  "ENTRAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _onClickNextPage() async {
    bool formOk = _formKey.currentState!.validate();

    if (!formOk) {
      return;
    }

    Prefs.setString("nome", _txtnome.text);

    setState(() {
      _showProgress = true;
      push(context, const CadastroPage(), replace: true);
    });

    // setState(() {
    //   _showProgress = false;
    // });
  }
}
