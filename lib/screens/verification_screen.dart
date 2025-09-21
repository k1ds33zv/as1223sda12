import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Проверяем, весь ли код введен
  bool get _isCodeComplete {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _handleVerificationPressed() {
    if (!_isCodeComplete) return;
    
    final code = _controllers.map((c) => c.text).join();
    print('Код подтверждения: $code для email: ${widget.email}');
  }

  void _handleCodeChange(int index, String value) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        // Если вставили несколько цифр (например, из буфера)
        final digits = value.split('');
        for (int i = 0; i < digits.length && index + i < 6; i++) {
          _controllers[index + i].text = digits[i];
        }
        if (index + digits.length < 6) {
          _focusNodes[index + digits.length].requestFocus();
        }
      } else if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    setState(() {}); // Обновляем состояние для кнопки
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        _handleCodeChange(i, _controllers[i].text);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Подтверждение email',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Мы отправили 6-значный код на ${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),

            // Поля для ввода 6-значного кода
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Кнопка Подтвердить (неактивна пока код не полный)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCodeComplete ? _handleVerificationPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCodeComplete ? Colors.black : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Подтвердить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                print('Отправить код повторно');
              },
              child: const Text(
                'Отправить код повторно',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 40), // Отступ для прокрутки
          ],
        ),
      ),
    );
  }
}