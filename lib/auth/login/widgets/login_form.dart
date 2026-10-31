import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_offline_first_clone/app/app.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/widgets/widgets.dart';

/// {@template login_form}
/// Login form that contains email and password fields styled in Wooble Neon Dark theme.
/// {@endtemplate}
class LoginForm extends StatefulWidget {
  /// {@macro login_form}
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().resetState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<LoginCubit>().resetState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title: loginSubmissionStatusMessage[state.status]!.title,
              description:
                  loginSubmissionStatusMessage[state.status]?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (p, c) => p.status != c.status,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Custom Neon Email Field ---
          Text(
            'EMAIL ADDRESS',
            style: TextStyle(
              color: Colors.cyanAccent.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (p, c) => p.email != c.email,
            builder: (context, state) {
              return TextFormField(
                style: const TextStyle(color: Colors.white),
                onChanged: (email) => context.read<LoginCubit>().onEmailChanged(email),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: const Color(0xFF0F141C),
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.cyanAccent.withOpacity(0.6)),
                  errorText: state.email.displayError != null ? 'Invalid email format' : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3), width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.cyanAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),

          // --- Custom Neon Password Field ---
          Text(
            'PASSWORD',
            style: TextStyle(
              color: Colors.pinkAccent.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (p, c) => p.password != c.password,
            builder: (context, state) {
              return TextFormField(
                style: const TextStyle(color: Colors.white),
                onChanged: (password) => context.read<LoginCubit>().onPasswordChanged(password),
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: const Color(0xFF0F141C),
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.pinkAccent.withOpacity(0.6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.pinkAccent.withOpacity(0.6),
                    ),
                    onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                  ),
                  errorText: state.password.displayError != null ? 'Password cannot be empty' : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.3), width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
