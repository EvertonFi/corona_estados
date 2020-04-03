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
  int totalcasos = 0;
  int totalmortes = 0;
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
          totalcasos = (totalcasos + dados[Et.estados[i]]["confirmed"].toInt());
          totalmortes = (totalmortes + dados[Et.estados[i]]["deaths"].toInt());
          carregado = true;
        }
        print(totalcasos);
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
              ? Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              "Total de Casos: " + totalcasos.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              "Total de Mortes: " + totalmortes.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView.builder(
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
                                          dados[Et.estados[index]]["name"],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                        "Confirmados: " +
                                            dados[Et.estados[index]]
                                                    ["confirmed"]
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
                      ),
                    ),
                  ],
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
