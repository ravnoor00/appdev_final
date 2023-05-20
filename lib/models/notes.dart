import 'question.dart';

class Notes {
  QuestionsList? questions;
  String name;
  String topic;
  String notes;

 Notes({this.questions, required this.name, required this.notes, required this.topic});
}
