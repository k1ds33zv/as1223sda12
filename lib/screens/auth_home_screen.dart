import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart'; // Добавь эту строку в импорты

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({super.key});

  void _handleSignInPressed(BuildContext context) {
    // Заменяем print на навигацию
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _handleSignUpPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Убираем AppBar полностью, чтобы был чистый белый фон
      appBar: null,
      // Устанавливаем белый фон для всего тела
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Распределяем пространство: логотип вверху, кнопки внизу
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Пустой контейнер вверху для баланса (занимает место)
              const SizedBox.shrink(),
              
              // Колонка с логотипом (по центру)
              Column(
                children: [
                  // Логотип
                  Image.asset(
                    'assets/images/logo.png', // Путь к твоему файлу
                    height: 120, // Регулируй размер
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32), // Отступ под логотипом
                  
                  // Заголовок
                  const Text(
                    'Добро пожаловать',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Подзаголовок
                  const Text(
                    'Войдите или создайте аккаунт, чтобы продолжить',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              // Колонка с кнопками (внизу экрана)
              Column(
                children: [
                  // Кнопка ВОЙТИ - современный стиль
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleSignInPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Черный фон
                        foregroundColor: Colors.white, // Белый текст
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0, // Убираем тень
                      ),
                      child: const Text(
                        'Войти в аккаунт',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Кнопка РЕГИСТРАЦИЯ - стиль "outline"
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleSignUpPressed(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black54), // Цвет рамки
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent, // Прозрачный фон
                      ),
                      child: const Text(
                        'Регистрация',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87, // Цвет текста
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}