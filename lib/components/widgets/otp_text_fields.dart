import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';


class OTPTextField extends StatefulWidget {
  const OTPTextField({Key? key}) : super(key: key);

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  bool hasError = false;
  // String currentText = "";
  final otpFormKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var forgotPassVM = context.watch<ForgotPassVM>();
    return Form(
      key: otpFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: PinCodeTextField(
          autoDisposeControllers: false,
          appContext: context,
          pastedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          length: 4,
          obscureText: true,
          obscuringCharacter: '*',
          obscuringWidget: const FlutterLogo(
            size: 24,
          ),
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          validator: (v) {
            if (v!.length < 3) {
              return "I'm from validator";
            } else {
              return null;
            }
          },
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              // activeFillColor: Colors.white,
              activeColor: Colors.green,
              selectedColor: Colors.blue,
              inactiveColor: Colors.grey,
              disabledColor: Colors.yellow,
              selectedFillColor: Colors.white70,
              inactiveFillColor: Colors.white,
              activeFillColor: Colors.white),
          cursorColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          errorAnimationController: errorController,
          // controller: forgotPassVM.otpTextEditingController,
          keyboardType: TextInputType.number,
          boxShadows: const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
          onCompleted: (v) {
            debugPrint("Completed");
          },
          // onTap: () {
          //   print("Pressed");
          // },
          onChanged: (value) {
            debugPrint(value);
            // forgotPassVM.setCurrentText(value);
          },
          beforeTextPaste: (text) {
            debugPrint("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
      ),
    );
  }
}
