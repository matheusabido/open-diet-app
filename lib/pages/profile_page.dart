import 'package:flutter/material.dart';
import 'package:open_diet/components/menu_item.dart';
import 'package:open_diet/components/profile/logout_button.dart';
import 'package:open_diet/pages/goals_calculator_page.dart';
import 'package:open_diet/pages/goals_page.dart';
import 'package:open_diet/pages/password_page.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final user = Api.instance.user!;

    return ListView(
      padding: .all(16),
      children: [
        Column(
          crossAxisAlignment: .stretch,
          spacing: 8,
          children: [
            Text(
              user.username,
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 24,
                fontWeight: .bold,
              ),
            ),
            if (user.isAdmin)
              Text(
                'Administrador',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            SizedBox(height: 8),
            MenuItem(
              icon: Icons.flag_outlined,
              label: 'Metas diárias',
              onTap: () => open(context, const GoalsPage()),
            ),
            MenuItem(
              icon: Icons.calculate_outlined,
              label: 'Calcular metas',
              onTap: () => open(context, const GoalsCalculatorPage()),
            ),
            MenuItem(
              icon: Icons.lock_outline,
              label: 'Alterar senha',
              onTap: () => open(context, const PasswordPage()),
            ),
            SizedBox(height: 8),
            LogoutButton(),
          ],
        ),
      ],
    );
  }
}
