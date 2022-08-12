import 'dart:convert' as convert;

class Cadastro {
  String? id;
  String? nome;
  String? telefone;
  String? cidade;
  String? bairro;
  String? sexo;
  String? hora;
  double? lat;
  double? longi;
  String? operador;

  Cadastro(
      {this.id,
      this.nome,
      this.telefone,
      this.cidade,
      this.bairro,
      this.sexo,
      this.hora,
      this.lat,
      this.longi,
      this.operador});

  Cadastro.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    cidade = json['cidade'];
    bairro = json['bairro'];
    sexo = json['sexo'];
    hora = json['hora'];
    lat = json['lat'];
    longi = json['longi'];
    operador = json['operador'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['cidade'] = cidade;
    data['bairro'] = bairro;
    data['sexo'] = sexo;
    data['hora'] = hora;
    data['lat'] = lat;
    data['longi'] = longi;
    data['operador'] = operador;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
}
