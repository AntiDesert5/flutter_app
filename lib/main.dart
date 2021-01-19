import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/widgets/RecipeDetailListItem.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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

          body: ListView.builder(
            itemBuilder: (context, index) {
              return index == 0 ? _searchBar() : _listItem(index-1);
            },
            itemCount: notaMostrada.length+1,
          )
    );
  }

  _icono() {
    return Icon(
      Icons.assignment_turned_in,
      size: 35,
      color: Colors.lightGreen,
    );
  }

  _iconofalse() {
    return Icon(
      Icons.cancel,
      size: 35,
      color: Colors.redAccent,
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Buscar por Usuario...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            notaMostrada = itemsShop.where((note) {
              var noteTitle = note.userId.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  List<Shop> itemsShop = List();
  List<Shop> notaMostrada = List<Shop>();
  Shop itemShop;
  DatabaseReference itemRefShop;

  @override
  void initState() {
    super.initState();
    itemShop = Shop("", "", true, "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRefShop = database.reference().child('answers');
    itemRefShop.onChildAdded.listen(_onEntryAddedShop);
    itemRefShop.onChildChanged.listen(_onEntryChangedShop);
  }

  _onEntryAddedShop(Event event) {
    setState(() {
      itemsShop.add(Shop.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChangedShop(Event event) {
    var old = itemsShop.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      itemsShop[itemsShop.indexOf(old)] = Shop.fromSnapshot(event.snapshot);
    });
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new Text('Usuario: ' + notaMostrada[index].userId),
              subtitle: new Text('Respuesta: ' +
                  itemsShop[index].answer +
                  '\n' +
                  'Id de pregunta: ' +
                  itemsShop[index].questionId),
              leading:
                  itemsShop[index].right == false ? _iconofalse() : _icono(),
            ),
          ],
        ),
      ),
    );
  }
}
