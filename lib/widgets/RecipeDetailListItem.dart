import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();


class Shop {
  String key;
  String answer;
  String questionId;
  bool right;
  String userId;

  Shop(this.answer,this.questionId,this.right,this.userId);

  Shop.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        answer = snapshot.value["answer"],
        questionId= snapshot.value["questionId"].toString(),
        right= snapshot.value["right"],
        userId= snapshot.value["userId"].toString();


  toJson() {
    return {
      "answer": answer,
      "questionId": questionId,
      "right": right,
      "userId": userId,
    };
  }
}