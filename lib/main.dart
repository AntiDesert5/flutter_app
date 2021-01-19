
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/widgets/RecipeDetailListItem.dart';

final databaseReference = FirebaseDatabase.instance.reference();
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                  query: itemRefShop,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return index == 0
                        ? _searchBar()
                        :  new ListTile(
                      title: new Text(
                          'Usuario: ' + notaMostrada[index-1].userId),
                      subtitle: new Text('Respuesta: ' +
                          itemsShop[index].answer +
                          '\n' +
                          'Id de pregunta: ' +
                          itemsShop[index].questionId),
                      leading: itemsShop[index].right == false
                          ? _icono()
                          : _icono(),
                    );
                  }),
            ),
          ],
        ),
      ),

    );
  }

  _icono() {
    return Icon(
      Icons.ac_unit_rounded,
      size: 10,
    );
  }
  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
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
}
