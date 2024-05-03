import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/demonstration.dart';

class DemonstrationService {
  final CollectionReference _demoRef =
      FirebaseFirestore.instance.collection('Demos');

  Future<bool> addDemo(Demonstration demo) async {
    try {
      // get the document reference
      DocumentReference docRef = _demoRef.doc();
      // set the id
      demo.id = docRef.id;
      // set the document
      await docRef.set(demo.toMap());
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> updateDemo(Demonstration demo) async {
    try {
      // get the document reference
      DocumentReference docRef = _demoRef.doc(demo.id);
      // set the document
      await docRef.set(demo.toMap());
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> deleteDemo(String id) async {
    try {
      // get the document reference
      DocumentReference docRef = _demoRef.doc(id);
      // delete the document
      await docRef.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> getDemos() {
    return _demoRef.snapshots();
  }
}
