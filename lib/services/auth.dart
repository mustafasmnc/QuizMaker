import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizmaker/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future createUser(String userId, String name,String email,String password) async {
    Map<String, String> userData = {
        "userId": userId,
        "userName": name,
        "userEmail": email,
        "userPassword": password
      };
    
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future singInEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "Error: User Not Found";
        case "wrong-password":
          return "Error: Wrong password";
      }
      return "Error: " + e.code;
    }
  }

  Future signUpWithEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //print("UserID: ${userCredential.user.uid}");
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          return "Error: Account exists with different credential";
        case "email-already-in-use":
          return "Error: Email already in use";
        case "weak-password":
          return "Error: Weak password";
      }
      return "Error: " + e.code;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
