import 'package:flutter/material.dart';
import 'package:open_diet/components/input/text_input.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/toast.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  static const _fieldLabels = {
    'current_password': 'Senha atual',
    'password': 'Nova senha',
    'password_confirmation': 'Confirmação de senha',
  };

  Map<String, TextEditingController> get requiredFields => {
    'current_password': currentPasswordController,
    'password': passwordController,
    'password_confirmation': passwordConfirmationController,
  };

  Future<void> submit() async {
    final errors = {
      for (final field in requiredFields.entries)
        if (field.value.text.trim().isEmpty) field.key: ['é obrigatório'],
    };
    if (errors.isNotEmpty) {
      setState(() {
        errorMessage = formatErrors(errors, _fieldLabels);
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Api.instance.changePassword(
        currentPasswordController.text.trim(),
        passwordController.text.trim(),
        passwordConfirmationController.text.trim(),
      );
      if (mounted) {
        showToast(context, 'Senha alterada');
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message ?? formatErrors(e.errors, _fieldLabels);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Alterar senha'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(
        child: ListView(
          padding: .all(16),
          children: [
            Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                SizedBox(
                  height: 48,
                  child: TextInput(
                    label: 'Senha atual *',
                    controller: currentPasswordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: TextInput(
                    label: 'Nova senha *',
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: TextInput(
                    label: 'Confirmar nova senha *',
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
                PrimaryButton(
                  label: 'Alterar senha',
                  onPressed: submit,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
