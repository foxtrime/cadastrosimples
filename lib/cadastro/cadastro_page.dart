import 'package:cadastrosimples/api_reponse.dart';
import 'package:cadastrosimples/cadastro/cadastro.dart';
import 'package:cadastrosimples/cadastro/cadastro_api.dart';
import 'package:cadastrosimples/util/alert.dart';
import 'package:cadastrosimples/util/drawer_list.dart';
import 'package:cadastrosimples/util/nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  @override
  void initState() {
    super.initState();
    _latitude = 000000;
    _longitude = 000000;
    pegaLocaliza();
  }

  Future pegaLocaliza() async {
    var location = Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }
    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }
    var loc = await location.getLocation();
    // print("${loc.latitude} ${loc.longitude}");

    _latitude = loc.latitude;
    _longitude = loc.longitude;
  }

  late dynamic _latitude;
  late dynamic _longitude;

  bool _showProgress = false;
  bool _isPressed = false;

  final _nome = TextEditingController();

  final _telefone = TextEditingController();
  var maskTextInputTel = MaskTextInputFormatter(
      mask: "(##)#####-####", filter: {"#": RegExp(r'[0-9]')});

  final _cidade = TextEditingController();
  final _bairro = TextEditingController();

  String _sexo = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Cadastro"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)])),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: _nbody(),
      ),
      drawer: const DrawerList(),
    );
  }

  _nbody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
      child: Center(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  // textCapitalization: TextCapitalization.characters,
                  controller: _nome,
                  decoration: const InputDecoration(hintText: "Nome Completo"),
                  validator: (value) =>
                      value!.isEmpty ? "Preencha o nome " : null,
                ),
                TextFormField(
                  controller: _telefone,
                  inputFormatters: [maskTextInputTel],
                  decoration: const InputDecoration(hintText: "Telefone"),
                  validator: (value) =>
                      value!.isEmpty ? "Preencha o nome " : null,
                ),

                TextFormField(
                  controller: _cidade,
                  decoration: const InputDecoration(hintText: "Cidade"),
                  validator: (value) =>
                      value!.isEmpty ? "Preencha o nome " : null,
                ),

                TextFormField(
                  controller: _bairro,
                  decoration: const InputDecoration(hintText: "Bairro"),
                  validator: (value) =>
                      value!.isEmpty ? "Preencha o nome " : null,
                ),

                Column(
                  children: [
                    ListTile(
                      title: const Text("Masculino"),
                      leading: Radio(
                        value: 'Masculino',
                        groupValue: _sexo,
                        onChanged: (value) {
                          setState(() {
                            _sexo = 'Masculino';
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: const Text("Feminino"),
                      leading: Radio(
                        value: 'Feminino',
                        groupValue: _sexo,
                        onChanged: (value) {
                          setState(() {
                            _sexo = 'Feminino';
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),

                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 1.2,
                //   height: 45,
                //   child: TextFormField(
                //     controller: _sexo,
                //     decoration: const InputDecoration(hintText: "Sexo"),
                //     validator: (value) =>
                //         value!.isEmpty ? "Preencha o nome " : null,
                //   ),
                // ),
                const SizedBox(height: 15),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width / 1.2,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                      onPressed: _isPressed == false ? _onClickSave : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                          child: _showProgress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Text('Salvar'))),
                ),
              ],
            )),
      ),
    );
  }

  _onClickSave() async {
    bool formOk = _formKey.currentState!.validate();
    if (!formOk) {
      return;
    }

    setState(() {
      _isPressed = true;
      _showProgress = true;
    });

    //  pega o nome do usuario "logado"
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final nomeOperador = prefs.getString('nome') ?? '';

    DateTime datetime = DateTime.now();

    String horaData = datetime.toString();

    var c = Cadastro();

    c.nome = _nome.text;
    c.telefone = _telefone.text;
    c.cidade = _cidade.text;
    c.bairro = _bairro.text;
    c.sexo = _sexo;
    c.hora = horaData;
    c.lat = _latitude;
    c.longi = _longitude;
    c.operador = nomeOperador;

    // ignore: avoid_print
    print("Paciente: $c");

    ApiResponse<bool> response = await CadastroApi.save(c);

    if (response.ok) {
      alert(context, "Cadastro", "Cadastro realizado com Sucesso",
          callback: () {
        // Navigator.popAndPushNamed(context, '/screenname');
        push(context, const CadastroPage(), replace: true);
      });
    } else {
      alert(context, response.msg, response.msg);
    }

    setState(() {
      _showProgress = false;
    });
  }
}
