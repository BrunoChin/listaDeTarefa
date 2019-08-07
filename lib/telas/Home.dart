import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List listaTarefa = [];
  final controleTarefa = TextEditingController();

  void initStatus(){
    super.initState();
    lerArquivo().then((dado){
      setState(() {
        listaTarefa = jsonDecode(dado);
      });
    });
  }

  void addTarefa(){
    setState(() {
      if(controleTarefa.text.isNotEmpty){
        Map<String, dynamic> novaTarefa = Map();
        novaTarefa["titulo"] = controleTarefa.text;
        novaTarefa["ok"] = false;
        listaTarefa.add(novaTarefa);
        controleTarefa.text = "";
        salvarArquivo();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Nova tarefa: ",
                        labelStyle: TextStyle(color: Colors.cyan),
                      ),
                      controller: controleTarefa,
                    ),
                  ),
                  RaisedButton(
                    color: Colors.lightBlue,
                    child: Text("Add"),
                    textColor: Colors.white,
                    onPressed: addTarefa,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: listaTarefa.length,
                  itemBuilder: (context, index){
                   return CheckboxListTile(
                     title: Text(listaTarefa[index]["titulo"]),
                     value: listaTarefa[index]["ok"],
                     secondary: CircleAvatar(
                       child: Icon(listaTarefa[index]["ok"] ? Icons.sentiment_satisfied : Icons.sentiment_dissatisfied),
                     ),
                     onChanged: (c){
                       setState(() {
                         listaTarefa[index]["ok"] = c;
                         salvarArquivo();
                       });
                     },
                   );

                },
              ),
            )
          ],
        ),
      ),
    );
  }



  //pegar/criar local do arquivo
  Future<File> _pegarArquivo() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/arquivo.json");
  }

  Future<File> salvarArquivo()async{
    String dados = json.encode(listaTarefa);
    final file = await _pegarArquivo();
    return file.writeAsString(dados);
  }

  Future<String> lerArquivo() async{
    final file = await _pegarArquivo();
    return file.readAsString();
  }
}