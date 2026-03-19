import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: 'No user found for that email'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMessage: 'Wrong password'));
      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure(errorMessage: 'Invalid email or password')); 
      }else {
        emit(LoginFailure(errorMessage: e.message ?? 'Login failed!'));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }

  Future<void> registerUser({required String email, required String password,}) async {
    emit(RegisterLoading());

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ); 

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          RegisterFailure(errorMessage: 'The password provided is too weak'),
        );
      } else if (e.code == 'email-already-in-use') {
        emit(
          RegisterFailure(
            errorMessage: 'This account is already registerd',
          ),
        );
      } else if (e.code == 'invalid-email') {
        emit(
          RegisterFailure(
            errorMessage: 'The email address is badly formatted',
          ),
        );
      } else {
        emit(
          RegisterFailure(
            errorMessage: e.message ?? 'Registration failed, please try again',
          ),
        );
      }
    } catch (e) {
      emit(
        RegisterFailure(
          errorMessage: 'An unexpected error occurred. Please try again later',
        ),
      );
    }
  }
}
