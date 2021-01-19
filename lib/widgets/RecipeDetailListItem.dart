import 'package:firebase_database/firebase_database.dart';

class pregunta {
  String key;
  String answer;
  String questionId;
  bool right;
  String userId;

  pregunta(this.answer,this.questionId,this.right,this.userId);

  pregunta.fromSnapshot(DataSnapshot snapshot)
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