import 'package:flutter/material.dart';
import 'package:open_diet/components/confirm_dialog.dart';
import 'package:open_diet/services/api.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Sair',
        message: 'Tem certeza que deseja sair da sua conta?',
        confirmLabel: 'Sair',
      ),
    );
    if (confirmed == true) Api.instance.logout();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => logout(context),
        icon: Icon(Icons.logout),
        label: Text('Sair'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade300,
          side: BorderSide(color: Colors.red.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
