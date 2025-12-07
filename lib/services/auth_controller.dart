import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // SIGN UP
  Future<String> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      await _firestore.collection("users").doc(user.uid).set({
        'uid': user.uid,
        'fullName': fullName,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // LOGIN
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // GOOGLE SIGN-IN
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "cancelled";

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user!;

      final userDoc =
          await _firestore.collection("users").doc(user.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'fullName': user.displayName ?? "",
          'email': user.email ?? "",
          'photoUrl': user.photoURL ?? "",
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
