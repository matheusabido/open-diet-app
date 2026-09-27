import 'package:flutter/material.dart';
import 'package:open_diet/components/input/text_input.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  bool isRegister = false;
  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'username': 'Usuário',
    'password': 'Senha',
    'password_confirmation': 'Confirmação de senha',
  };

  void toggleMode() {
    setState(() {
      isRegister = !isRegister;
      errorMessage = null;
    });
  }

  Future<void> submit() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (isRegister) {
        await Api.instance.register(
          usernameController.text.trim(),
          passwordController.text.trim(),
          passwordConfirmationController.text.trim(),
        );
      } else {
        await Api.instance.login(
          usernameController.text.trim(),
          passwordController.text.trim(),
        );
      }
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message ?? formatErrors(e.errors);
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Não foi possível conectar ao servidor';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String formatErrors(Map<String, List<String>> errors) {
    return errors.entries
        .map((entry) {
          final label = _fieldLabels[entry.key] ?? entry.key;
          return '$label ${entry.value.join(', ')}';
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: .all(16),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            spacing: 12,
            children: [
              Text(
                'Open Diet',
                textAlign: .center,
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 32,
                  fontWeight: .bold,
                ),
              ),
              Text(
                isRegister ? 'Crie sua conta' : 'Entre na sua conta',
                textAlign: .center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: TextInput(
                  hint: 'Usuário',
                  controller: usernameController,
                ),
              ),
              SizedBox(
                height: 48,
                child: TextInput(
                  hint: 'Senha',
                  controller: passwordController,
                  obscureText: true,
                ),
              ),
              if (isRegister)
                SizedBox(
                  height: 48,
                  child: TextInput(
                    hint: 'Confirmar senha',
                    controller: passwordConfirmationController,
                    obscureText: true,
                  ),
                ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  textAlign: .center,
                  style: TextStyle(color: Colors.red.shade300),
                ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey.shade200,
                          ),
                        )
                      : Text(isRegister ? 'Cadastrar' : 'Entrar'),
                ),
              ),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: isLoading ? null : toggleMode,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade300,
                    side: BorderSide(color: Colors.blue.shade800),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isRegister
                        ? 'Já tem uma conta? Entrar'
                        : 'Não tem uma conta? Cadastre-se',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
