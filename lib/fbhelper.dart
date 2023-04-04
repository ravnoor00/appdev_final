import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Map<String, dynamic> userData = {};
var _email;

Future<List<Map<String, dynamic>>> getJsonList() async {
  List<Map<String, dynamic>> jsonList = [];

  // Retrieve users collection
  QuerySnapshot<Map<String, dynamic>> users = await firestore
      .collection('users')
      .where("email", isEqualTo: _email)
      .get();

  for (var user in users.docs) {
    // Iterate through user documents and get the subcollections
    String userId = user.id;
    QuerySnapshot<Map<String, dynamic>> subcollections = await firestore
        .collection('users')
        .doc(userId)
        .collection('questions')
        .get();

    for (var subcollectionDoc in subcollections.docs) {
      if (subcollectionDoc.data().containsKey('question_answer')) {
        List<dynamic> rawJsonList = subcollectionDoc['question_answer'];

        // Convert List<dynamic> to List<Map<String, dynamic>>
        List<Map<String, dynamic>> convertedJsonList =
            rawJsonList.map((item) => item as Map<String, dynamic>).toList();

        jsonList.addAll(convertedJsonList);
      }
    }
  }

  return jsonList;
}

Future<void> addJsonListToUserQuestions(String userId, List<Map<String, dynamic>> jsonList) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a new document in the user's questions subcollection
  DocumentReference<Map<String, dynamic>> questionsRef = firestore.collection('users').doc(userId).collection('questions').doc();

  // Add the list of JSON objects to the new document
  return questionsRef.set({'question_answer': jsonList});
}
