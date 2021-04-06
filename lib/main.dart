import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/widgets/RecipeDetailListItem.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Busqueda de respuestas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

          body:
          ListView.builder(

            itemBuilder: (context, index) {
              return index == 0 ? _searchBar() : _listItem(index-1);
            },
            itemCount: notaMostrada.length+1,
          )
    );
  }

  _icono() { //funcion para mostrar icono de respuesta correcta
    return Icon(
      Icons.assignment_turned_in,
      size: 35,
      color: Colors.lightGreen,
    );
  }

  _iconofalse() {//muestra icono para respuesta mala
    return Icon(
      Icons.cancel,
      size: 35,
      color: Colors.redAccent,
    );
  }

  _searchBar() { //barra de busqueda, se convierte a minusculas
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Buscar por Usuario...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            notaMostrada = itemsPregPrincipal.where((nota) {
              var tituloNota = nota.userId.toLowerCase();
              return tituloNota.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  List<pregunta> itemsPregPrincipal = List();//objetos pregunta, lista
  List<pregunta> notaMostrada = List<pregunta>();
  pregunta itemPregunta;
  DatabaseReference itemRefPreg;

  @override
  void initState() {
    super.initState();
    itemPregunta = pregunta("", "", true, "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRefPreg = database.reference().child('answers');//rama principal para obtener datos
    itemRefPreg.onChildAdded.listen(_onEntryAddedShop);
    itemRefPreg.onChildChanged.listen(_onEntryChangedShop);
  }

  _onEntryAddedShop(Event event) {//añadir
    setState(() {
      itemsPregPrincipal.add(pregunta.fromSnapshot(event.snapshot));
      notaMostrada=itemsPregPrincipal;
    });
  }

  _onEntryChangedShop(Event event) {//cargar
    var old = itemsPregPrincipal.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      itemsPregPrincipal[itemsPregPrincipal.indexOf(old)] = pregunta.fromSnapshot(event.snapshot);
    });
  }

  _listItem(index) { //se crea card, se usa listtile para agregar los datos a la card
    //ademas se pasa la funcion para mostrar iconos, segun resultado
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new Text('Producto: ' + notaMostrada[index].userId),
              subtitle: new Text('Descripcion: ' +
                  itemsPregPrincipal[index].answer +
                  '\n' +
                  'Costo: ' + '\$'+
                  itemsPregPrincipal[index].questionId),
              leading:
                  itemsPregPrincipal[index].right == false ? _iconofalse() : _icono(),//if
            ),
          ],
        ),
      ),
    );
  }
}
