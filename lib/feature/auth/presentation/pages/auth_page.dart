import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/biometric_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthenticationScreen extends StatelessWidget {
  final BiometricRepository biometricRepository;

  AuthenticationScreen({Key? key, required this.biometricRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AuthBloc(biometricRepository),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              Navigator.pushReplacementNamed(context, '/notesList');
            } else if (state is AuthFailureState) {
              _showErrorDialog(
                  context, 'Authentication failed. Please try again.');
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade900.withOpacity(0.8),
                      Colors.blueAccent.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fingerprint, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Login with Biometrics',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (state is! AuthLoadingState) {
                          context.read<AuthBloc>().add(AuthenticateUserEvent());
                        }
                      },
                      child: state is AuthLoadingState
                          ? CircularProgressIndicator()
                          : Text('Authenticate'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
