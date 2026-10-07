import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/storage/secure_token_storage.dart';
import '../../core/utils/input_validators.dart';
import '../viewmodels/login_viewmodel.dart';
import 'course_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _emailValid = false;
  bool _passwordValid = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final storage = Get.find<SecureTokenStorage>();
    final rememberMe = await storage.readRememberMe();
    if (!rememberMe) return;
    final (email, password) = await storage.readCredentials();
    if (!mounted) return;
    final vm = Get.find<LoginViewModel>();
    final newEmailValid = email != null && InputValidators.email(email) == null;
    final newPasswordValid = password != null && InputValidators.password(password) == null;
    if (email != null) {
      _emailController.text = email;
      vm.email.value = email;
    }
    if (password != null) {
      _passwordController.text = password;
      vm.password.value = password;
    }
    if (mounted) {
      setState(() {
        _rememberMe = true;
        _emailValid = newEmailValid;
        _passwordValid = newPasswordValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard — Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.school_rounded, size: 64.sp, color: Theme.of(context).colorScheme.primary),
                  SizedBox(height: 12.h),
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Sign in to continue learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32.h),
                  TextFormField(
                    key: const Key('emailField'),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                     keyboardType: TextInputType.emailAddress,
                     validator: InputValidators.email,
                     controller: _emailController,
                     onChanged: (v) {
                       controller.email.value = v;
                       setState(() => _emailValid = InputValidators.email(v) == null);
                     },
                   ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    key: const Key('passwordField'),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                     obscureText: _obscurePassword,
                     validator: InputValidators.password,
                     controller: _passwordController,
                     onChanged: (v) {
                       controller.password.value = v;
                       setState(() => _passwordValid = InputValidators.password(v) == null);
                     },
                   ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (_emailValid && _passwordValid)
                            ? (v) => setState(() => _rememberMe = v ?? false)
                            : null,
                      ),
                      GestureDetector(
                        onTap: (_emailValid && _passwordValid)
                            ? () => setState(() => _rememberMe = !_rememberMe)
                            : null,
                        child: Text('Remember Me', style: TextStyle(color: (_emailValid && _passwordValid) ? null : Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => controller.error.value == null
                      ? const SizedBox.shrink()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            controller.error.value!.message,
                            style: TextStyle(color: Colors.red[700], fontSize: 13.sp),
                          ),
                        )),
                  SizedBox(height: 16.h),
                  Obx(
                    () => FilledButton(
                      key: const Key('loginButton'),
                      onPressed: controller.isLoading.value || !(_emailValid && _passwordValid)
                          ? null
                          : () async {
                              if (!(_formKey.currentState?.validate() ?? false)) return;
                              final ok = await controller.login();
                              if (ok) {
                                final storage = Get.find<SecureTokenStorage>();
                                await storage.saveRememberMe(_rememberMe);
                                if (_rememberMe) {
                                  await storage.saveCredentials(
                                      controller.email.value.trim(), controller.password.value);
                                } else {
                                  await storage.deleteCredentials();
                                }
                                Get.offAll(() => const CourseDashboardScreen());
                              }
                            },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Login', style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Demo credentials:\ntest@demo.com / demo123',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.sp, color: Colors.blue[800]),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Develop by munir.flutter@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
