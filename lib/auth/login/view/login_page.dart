import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/widgets/auth_provider_sign_in_button.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/widgets/login_form.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/widgets/sign_in_button.dart';
import 'package:flutter_instagram_offline_first_clone/auth/login/widgets/widgets.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<UserRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wooble Deep Cyberpunk Dark Background - Fixed underscore issue
      backgroundColor: const Color(0xFF0B0E14),
      body: SafeArea(
        child: AppConstrainedScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap.v(AppSpacing.xxxlg),
              
              // Wooble Header Style
              Text(
                'WOOBLE',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent.withOpacity(0.8),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              const Text(
                'Connect to the Cyberverse',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const Gap.v(AppSpacing.xxlg),

              // Neon Glowing Container Wrapper for Forms - Fixed underscore issue
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginForm(),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSpacing.md,
                        top: AppSpacing.xs,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ForgotPasswordButton(),
                      ),
                    ),
                    const Align(child: SignInButton()),
                    
                    // Styled Neon Divider
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.cyanAccent.withOpacity(0.2),
                            thickness: 1,
                            endIndent: AppSpacing.sm,
                            indent: AppSpacing.md,
                          ),
                        ),
                        Text(
                          'OR', 
                          style: context.titleMedium?.copyWith(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.cyanAccent.withOpacity(0.2),
                            thickness: 1,
                            indent: AppSpacing.sm,
                            endIndent: AppSpacing.md,
                          ),
                        ),
                      ],
                    ),
                    const Gap.v(AppSpacing.sm),

                    // Social Sign-In Buttons with Neon Accents
                    Align(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: AuthProviderSignInButton(
                          provider: AuthProvider.google,
                          onPressed: () =>
                              context.read<LoginCubit>().loginWithGoogle(),
                        ),
                      ),
                    ),
                    Align(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: AuthProviderSignInButton(
                          provider: AuthProvider.github,
                          onPressed: () =>
                              context.read<LoginCubit>().loginWithGithub(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap.v(AppSpacing.xlg),
              const SignUpNewAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
