import 'package:agreement_app/app/home_page/home_page.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:agreement_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: CustomTextField(
                  controller: passwordController,
                  lableText: 'Password',
                  obscureText: true,
                  textInputType: TextInputType.number,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text == '1234') {
                    Helpers.navigateToPushAndRemoveUntil(context, HomePage());
                  } else {
                    Helpers.showSnackbar(context, 'Invalid password');
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
