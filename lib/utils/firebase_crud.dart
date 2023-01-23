import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('shelters');

class FirebaseCrud {
  static Future<Response> addShelter({
    required String userId,
    required String shelterId,
    required String name,
    required GeoPoint location,
    required String phone,
    required String description,
    required bool status,
    required bool verified,
    required List<dynamic> benefit,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "userid": userId,
      "shelterId": shelterId,
      "name": name,
      "location": location,
      "phone": phone,
      "description": description,
      "status": status,
      "benefit": benefit,
      "verified": false,
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readShelter() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  static Future<Response> updateStatusShelter({
    required String shelterId,
    required bool status,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(shelterId);

    Map<String, dynamic> data = <String, dynamic>{
      "status": status,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> updateShelter({
    required String userid,
    required String shelterId,
    required String name,
    required GeoPoint location,
    required String phone,
    required String description,
    required bool status,
    required bool verified,
    required List<dynamic> benefit,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(shelterId);

    Map<String, dynamic> data = <String, dynamic>{
      "userid": userid,
      "shelterId": shelterId,
      "name": name,
      "location": location,
      "phone": phone,
      "description": description,
      "status": status,
      "benefit": benefit,
      "verified": verified,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteShelter({
    required String shelterId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(shelterId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
