import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();


class Shop {
  String key;
  String name;
  String address;
  bool phone;
  String thumbnail;

  Shop(this.name,this.address,this.phone,this.thumbnail);

  Shop.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["answer"],
        address= snapshot.value["questionId"],
        phone= snapshot.value["right"],
        thumbnail= snapshot.value["userId"];


  toJson() {
    return {
      "answer": name,
      "questionId": address,
      "right": phone,
      "userId": thumbnail,
    };
  }
}