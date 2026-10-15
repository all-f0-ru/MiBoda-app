import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/brand.dart';
import '../../widgets/buttons.dart';
import '../../widgets/layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'maria@correo.cl');
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    // Sin backend: cualquier contraseña de 6+ caracteres entra; si no, se muestra el error.
    if (_password.text.length < 6) {
      setState(() => _error = 'Email o contraseña incorrectos. Inténtalo otra vez.');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, Routes.coupleHome, (_) => false);
  }

  void _social() => Navigator.pushNamedAndRemoveUntil(context, Routes.coupleHome, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: 'Volver', icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.maybePop(context)),
      ),
      body: ScreenList(
        top: 8,
        children: [
          const Align(alignment: Alignment.centerLeft, child: LogoInline()),
          Text('Te damos la bienvenida a MiBoda+', style: AppText.display),
          Text('Ingresa para seguir planificando tu boda.', style: AppText.muted(AppText.bodyM)),
          _field('Email', _email, keyboard: TextInputType.emailAddress),
          _field('Contraseña', _password, obscure: true),
          Align(
            alignment: Alignment.centerLeft,
            child: TextLink('¿Olvidaste tu contraseña?', onTap: () => showToast(context, 'Te enviamos un enlace a ${_email.text}')),
          ),
          AppButton(label: 'Iniciar sesión', onPressed: _login),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('o', style: AppText.muted(AppText.bodyS))),
              const Expanded(child: Divider()),
            ],
          ),
          AppButton.secondary(label: 'Continuar con Google', onPressed: _social),
          AppButton.secondary(label: 'Continuar con Apple', onPressed: _social),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿No tienes cuenta? ', style: AppText.muted(AppText.bodyS)),
              TextLink('Crear cuenta', onTap: () => Navigator.pushReplacementNamed(context, Routes.role)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool obscure = false, TextInputType? keyboard}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppText.muted(AppText.labelS)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: keyboard,
          style: AppText.bodyM,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            errorText: label == 'Email' ? _error : null,
            errorMaxLines: 2,
            errorStyle: AppText.bodyS.copyWith(color: AppColors.error),
            hintText: obscure ? 'Mínimo 6 caracteres' : null,
          ),
        ),
      ],
    );
  }
}
