import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login function

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register function

  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //call our database service to update user data
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//sign out

  Future signOut() async {
    try {
      HelperFunctions.saveUserLoggedInStatus(false);
      HelperFunctions.saveUserNameSF("");
      HelperFunctions.saveUserEmailSF("");
      firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
