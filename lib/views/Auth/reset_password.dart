import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});
  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                      ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "We sent a verifivation code to ",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      TextSpan(
                        text: widget.email,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    selectedColor: const Color(0xff6571ff),
                    inactiveColor: Colors.grey,
                  ),
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) async {
                    await _authenticationController.checkCode(
                      email: widget.email,
                      token: pinController.text.trim(),
                    );
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter a valid PIN code.';
                    }
                    if (v.length != 4) {
                      return 'PIN code must be 4 digits long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _authenticationController.checkCode(
                              email: widget.email,
                              token: pinController.text.trim(),
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Obx(() {
                          return _authenticationController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Continue",
                                );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Didn't receive the email? ",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      TextSpan(
                        text: 'Click Here',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: const Color(0xff6571ff),
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await _authenticationController.forgot(
                              email: widget.email,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
