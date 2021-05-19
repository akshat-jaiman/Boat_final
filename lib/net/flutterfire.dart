import 'package:firebase_auth/firebase_auth.dart';

Future<int> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return 1;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('User Does not exist.');
      return 2;
    } else if (e.code == 'wrong-password') {
      print('The account already exists for that email.');
      return 3;
    } else if (e.code == 'invalid-email') {
      print('Invalid Email');
      return 4;
    } else {
      print(e.toString());
      return 5;
    }
  } catch (e) {
    print(e.toString());
    return 5;
  }
}

Future<int> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return 1;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return 2;
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return 3;
    } else if (e.code == 'invalid-email') {
      print('Invalid Email');
      return 4;
    }
    return 5;
  } catch (e) {
    print(e.toString());
    return 5;
  }
}
