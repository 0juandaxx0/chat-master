import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';

class AuthUser {
  Future<UserCredential> loginGoogle() async {
    // Inicializa Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Inicia sesión con Google
    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

    // Verifica si el usuario ha iniciado sesión
    if (googleAccount == null) {
      // Maneja el caso en que el usuario canceló el inicio de sesión o ocurrió un error
      throw Exception(
          'El usuario canceló el inicio de sesión o ocurrió un error.');
    }

    // Obtiene las credenciales de autenticación de Google
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    // Crea las credenciales de Firebase utilizando los tokens de Google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Inicia sesión en Firebase con las credenciales de Google
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Devuelve las credenciales del usuario autenticado
    return userCredential;
  }
}

class GoogleSignInAccount {
  get authentication => null;
}

class GoogleSignIn {
  signIn() {}
}
