import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task/pages/auth/widgets/auth_textfield.dart';
import 'package:task/pages/home/home_page.dart';
import 'package:task/services/auth_service.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key, required this.email});
  final String email;

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final TextEditingController codeController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool isResending = false;

  Future<void> resendCode() async {
    try {
      setState(() => isResending = true);
      await authService.sendCode(widget.email);
      setState(() => isResending = false);

      if (!mounted) return;
      showSuccess('Code successfully sent!');
    } catch (error) {
      setState(() => isResending = false);
      showError('Error in sending code!');
    }
  }

  Future<void> confirmCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      showError('Please provide code!');
      return;
    }
    try {
      setState(() => isLoading = true);
      final result = await authService.confirmCode(widget.email, code);
      await authService.tokenStorage.saveTokens(result);
      final jwt = result['jwt'];
      final userId = await authService.getUserId(jwt);
      setState(() => isLoading = false);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userId: userId)),
        (route) => false,
      );
    } catch (error) {
      setState(() => isLoading = false);
      if (!mounted) return;
      String errorMessage = 'Code is not right please try again!';

      if (error is DioException) {
        final data = error.response?.data;

        if (data != null && data['error'] != null) {
          final serverError = data['error'].toString().toLowerCase();

          if (serverError.contains('expired')) {
            errorMessage = 'Code expired!';
          } else if (serverError.contains('forbidden')) {
            errorMessage = 'Code is not right!';
          } else {
            errorMessage = data['error'];
          }
        }
      }

      showError(errorMessage);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.green.shade700),
                SizedBox(height: 24),
                Text(
                  'Type code',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Code has been sent',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  widget.email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                AuthTextfield(
                  textAlign: TextAlign.center,
                  fontSize: 28,
                  letterSpacing: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                  hintText: '123456',
                  controller: codeController,
                  isLoading: isLoading,
                  sendCode: confirmCode,
                  icon: Icons.numbers,
                  buttonText: 'Confirm',
                  labelText: 'Code',
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: isResending ? null : resendCode,
                  child: isResending
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Resend code', style: TextStyle(color: Colors.green.shade700, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
