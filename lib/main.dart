import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:corona_estado/estados.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dados;
  bool carregado = false;

  getInfoVirus() async {
    String url = "https://alertacorona.online/data.json";
    http.Response response;
    response = await http.get(url);
    if (response.statusCode == 200) {
      var decodeJson = jsonDecode(response.body);
      return decodeJson["brazil"]["states"];
    }
    // String totalcaso = retorno["totalCasos"];
  }

  @override
  void initState() {
    super.initState();
    getInfoVirus().then((map) {
      setState(() {
        dados = map;
        for (var i = 0; i < Et.estados.length; i++) {
          print(dados[Et.estados[i]]);
          print(i);
          carregado = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: carregado
              ? ListView.builder(
                  itemCount: Et.estados.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: 100,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Estado: " +
                                    dados[Et.estados[index]]
                                        ["name"],
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                  "Confirmados: " +
                                      dados[Et.estados[index]]["confirmed"]
                                          .toString(),
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                  "Mortos: " +
                                      dados[Et.estados[index]]["deaths"]
                                          .toString(),
                                  style: TextStyle(fontSize: 20))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text(
                      "Carregando...",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
