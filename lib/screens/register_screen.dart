import 'package:flutter/material.dart'; 
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+7';

  final List<String> _countryCodes = ['+7', '+1', '+44', '+49', '+33', '+86'];
  
  bool _formTouched = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _validateEmail(String? value) {
    if (!_formTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_formTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен быть не менее 8 символов';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Пароль должен содержать цифру';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Пароль должен содержать заглавную букву';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_formTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (!_formTouched) return null;
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }
    
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.length != 10) {
      return 'Номер должен содержать 10 цифр';
    }
    
    return null;
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null &&
        _validateConfirmPassword(_confirmPasswordController.text) == null &&
        _validatePhone(_phoneController.text) == null;
  }

  // Проверяем совпадение паролей в реальном времени
  bool get _passwordsMatch {
    return _passwordController.text == _confirmPasswordController.text;
  }

  // Проверяем, нужно ли подсвечивать поля паролей красным
  bool get _shouldHighlightPasswords {
    return _formTouched && 
        (_passwordController.text.isNotEmpty || _confirmPasswordController.text.isNotEmpty) &&
        !_passwordsMatch;
  }

  void _handleRegisterPressed(BuildContext context) {
    setState(() {
      _formTouched = true;
    });
    
    if (!_isFormValid) return;
    
    final email = _emailController.text;
    final password = _passwordController.text;
    final phone = _selectedCountryCode + _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    print('Email: $email, Password: $password, Phone: $phone');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VerificationScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final highlightPasswords = _shouldHighlightPasswords;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Создайте новый аккаунт',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: emailError != null ? Colors.red : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: emailError != null ? Colors.red : Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: emailError != null ? Colors.red : Colors.black),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 16),
              onChanged: (_) => setState(() {}),
            ),
            if (emailError != null) ...[
              const SizedBox(height: 4),
              Text(
                emailError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Пароль с глазком
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                labelStyle: TextStyle(color: passwordError != null || highlightPasswords ? Colors.red : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: passwordError != null || highlightPasswords ? Colors.red : Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: passwordError != null || highlightPasswords ? Colors.red : Colors.black),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
              style: const TextStyle(fontSize: 16),
              onChanged: (_) => setState(() {}),
            ),
            if (passwordError != null) ...[
              const SizedBox(height: 4),
              Text(
                passwordError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Подтверждение пароля с глазком
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
                labelStyle: TextStyle(color: confirmPasswordError != null || highlightPasswords ? Colors.red : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: confirmPasswordError != null || highlightPasswords ? Colors.red : Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: confirmPasswordError != null || highlightPasswords ? Colors.red : Colors.black),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showConfirmPassword,
              style: const TextStyle(fontSize: 16),
              onChanged: (_) => setState(() {}),
            ),
            if (confirmPasswordError != null) ...[
              const SizedBox(height: 4),
              Text(
                confirmPasswordError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            if (highlightPasswords) ...[
              const SizedBox(height: 4),
              const Text(
                'Пароли не совпадают',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Номер телефона
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Номер телефона',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                // Выбор кода страны
                Container(
                  height: 56,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: phoneError != null ? Colors.red : Colors.black54),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      isExpanded: true,
                      items: _countryCodes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                color: phoneError != null ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountryCode = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Поле ввода номера
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: '960 852 2112',
                      hintStyle: TextStyle(color: phoneError != null ? Colors.red : Colors.black38),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: phoneError != null ? Colors.red : Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: phoneError != null ? Colors.red : Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 16,
                      color: phoneError != null ? Colors.red : Colors.black,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (phoneError != null) ...[
              const SizedBox(height: 4),
              Text(
                phoneError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 32),

            // Кнопка
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid ? () => _handleRegisterPressed(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? Colors.black : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
