import 'package:cadastrosimples/api_reponse.dart';
import 'package:cadastrosimples/cadastro/cadastro.dart';
import 'package:cadastrosimples/util/url.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class CadastroApi {
  static Future<ApiResponse<bool>> save(Cadastro c) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8",
    };

    // var url = Uri.http(link, '/api_cadastro/inseri.php');
    var url = Uri.http(link, '/inseri.php');

    String json = c.toJson();

    var response = await http.post(url, body: json, headers: headers);

    // ignore: avoid_print
    print('Response status ${response.statusCode}');
    // ignore: avoid_print
    print('Response body ${response.body}');

    if (response.statusCode == 201) {
      Map mapResponse = convert.json.decode(response.body);

      Cadastro cadastro = Cadastro.fromJson(mapResponse);

      // ignore: avoid_print
      print("Novo Cadastro: ${cadastro.id}");

      return ApiResponse.ok(true);
    }
    Map mapResponse = convert.json.decode(response.body);
    return ApiResponse.error(mapResponse["error"]);
  }
}
