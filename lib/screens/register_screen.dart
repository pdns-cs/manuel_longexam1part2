import 'package:flutter/material.dart';
import 'package:manuel_advmobprog/constants.dart';
import 'package:manuel_advmobprog/services/user_database.dart';
import 'package:manuel_advmobprog/widgets/loop_brand.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobilenumController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final UserDatabase _userDatabase = UserDatabase();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobilenumController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String field) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '$field is required';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) {
      return '$field should only contain letters';
    }
    if (v.length < 2) return '$field must be at least 2 characters';
    return null;
  }

  String? _validateMobile(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Mobile number is required';
    if (!RegExp(r'^09\d{9}$').hasMatch(v)) {
      return 'Must be 11 digits and start with 09';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username is required';
    if (v.length < 3) return 'Username must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
      return 'Only letters, numbers and underscores';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add a number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
      return 'Add a special character';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    final errorMessage = await _userDatabase.saveUser(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      mobileNumber: mobilenumController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created — please sign in.'),
          backgroundColor: LOOP_EMERALD,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: LOOP_DANGER),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LOOP_BG,
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoopLogo(size: 40),
                  const SizedBox(height: 20),
                  Text(
                    'Join $kAppName',
                    style: TextStyle(
                      fontFamily: 'Klavika',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: LOOP_TEXT,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: firstNameController,
                          hint: 'First name',
                          validator: (v) => _validateName(v, 'First name'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          controller: lastNameController,
                          hint: 'Last name',
                          validator: (v) => _validateName(v, 'Last name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: mobilenumController,
                    hint: 'Mobile number',
                    keyboardType: TextInputType.phone,
                    validator: _validateMobile,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: usernameController,
                    hint: 'Username',
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: passwordController,
                    hint: 'Password',
                    obscure: _obscurePassword,
                    validator: _validatePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use 8+ characters with upper & lower case, a number and a symbol.',
                    style: TextStyle(color: LOOP_MUTED, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  _field(
                    controller: confirmpasswordController,
                    hint: 'Confirm password',
                    obscure: _obscureConfirmPassword,
                    validator: _validateConfirm,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirmPassword =
                            !_obscureConfirmPassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create account'),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/login'),
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          color: LOOP_ACCENT,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
    );
  }
}
