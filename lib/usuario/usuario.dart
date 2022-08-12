import 'package:cadastrosimples/util/prefs.dart';

class Usuario {
  late String nome;

  Usuario({required this.nome});

  static void clear() {
    Prefs.setString("nome", "");
  }

  void save() {
    Prefs.setString("nome", nome);
  }

  static Future<Usuario?> get() async {
    String nome = await Prefs.getString("nome");

    if (nome.isEmpty) {
      return null;
    }
    Usuario user = Usuario(nome: nome);
    return user;
  }
}
