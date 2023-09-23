import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:recovery_passaword_web/core/config/api_client.dart';
import 'package:validatorless/validatorless.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_textformfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaEC = TextEditingController();
  final _confirmaEC = TextEditingController();

  RxBool _visible = true.obs;

  @override
  void dispose() {
    super.dispose();
    _senhaEC.dispose();
    _confirmaEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: const Text('Recuperação de senha!')),
      body: Obx(
        () => _visible.value
            ? Center(
                child: Container(
                  height: 400,
                  width: 300,
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Digite a nova senha!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: CustomTextformfield(
                            label: 'Nova senha',
                            controller: _senhaEC,
                            obscureText: true,
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatório'),
                              Validatorless.min(8,
                                  'Nova senha deve ter pelo menos 8 caracteres'),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomTextformfield(
                            label: 'Confirma a nova senha',
                            obscureText: true,
                            validator: Validatorless.multiple([
                              Validatorless.required(
                                  'Confirma senha obrigatória'),
                              Validatorless.compare(_senhaEC,
                                  'Nova senha diferente de confirma nova senha'),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomButton(
                            color: Colors.green,
                            width: double.infinity,
                            label: 'CADASTRAR NOVA SENHA',
                            onPressed: () {
                              final formValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (formValid) {
                                String? userId =
                                    Uri.base.queryParameters['userId'];
                                String? secret =
                                    Uri.base.queryParameters['secret'];

                                ApiClient.account.updateRecovery(
                                    userId: userId.toString(),
                                    secret: secret.toString(),
                                    password: _senhaEC.text,
                                    passwordAgain: _senhaEC.text);

                                // print(userId);
                                // print(secret);
                                _visible.value = false;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                  height: 400,
                  width: 300,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText(
                            duration: Duration(seconds: 3),
                            'Parabéns!',
                            textStyle: const TextStyle(
                                fontSize: 28, color: Colors.blue),
                          ),
                          ScaleAnimatedText(
                              duration: Duration(seconds: 3),
                              'Senha alterada!',
                              textStyle:
                                  TextStyle(fontSize: 25, color: Colors.blue)),
                          ScaleAnimatedText(
                              duration: Duration(seconds: 3),
                              'Faça login no App!',
                              textStyle: const TextStyle(
                                  fontSize: 25, color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
