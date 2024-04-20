import 'dart:async';

import 'package:flutter_assesment/screens/auth_screens/select_country_to_study_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../apis/api_file.dart';
import '../../messages/toast_messages.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;
  final String countryCode;

  const VerifyOtpScreen(
      {super.key, required this.phone, required this.countryCode});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  bool isResendOtp = false;
  OtpFieldController otpController = OtpFieldController();
  String otp = '';
  bool isLoading = false;
  late Timer _timer;
  int _resendTimer = 10;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth= MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: NeumorphicTheme.baseColor(context),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: NeumorphicButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: const NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                color: Color.fromRGBO(33, 36, 38, 1)),
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(

          child: Column(
            children: [
              const Center(
                  child: Text(
                    "Verify phone number",
                    style: TextStyle(fontSize: 24),
                  )),
              Text(
                "Please enter the OTP received to verify your number",
                style: TextStyle(
                    color: NeumorphicTheme.accentColor(context), fontSize: 14),
                textAlign: TextAlign.center,
              ),
             SizedBox(
                height: screenHeight*0.03,
              ),
              const Divider(
                thickness: 2,
              ),
               SizedBox(
                height: screenHeight*0.05,
              ),
              OTPTextField(
                length: 4,
                controller: otpController,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                fieldWidth: screenWidth*0.10,
                style: const TextStyle(fontSize: 17, color: Colors.white),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                otpFieldStyle: OtpFieldStyle(
                   enabledBorderColor: Colors.white,
                  focusBorderColor: NeumorphicTheme.accentColor(context)
                ),
                onChanged: (String code) {
                  otp = code;
                },
                onCompleted: (pin) {},
              ),
               SizedBox(
                height: screenHeight*0.3,
              ),
              const Text(
                "Didn't receive OTP?",
                style: TextStyle(
                    color: Color.fromRGBO(125, 126, 128, 1), fontSize: 14),
              ),
               SizedBox(
                height: screenHeight*0.02,
              ),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isResendOtp = true;
                    });
                    _startResendTimer();
                    final response = await ApiService.resendOtp(
                        '${widget.countryCode}${widget.phone}');
                    if (response['success']) {
                      CustomSnackbar.show(
                          context: context,
                          message: response['message'],
                          textColor: Colors.green
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['message']),
                        ),
                      );
                    }
                  },
                  child: isResendOtp == false
                      ? Text(
                    "Resend OTP",
                    style: TextStyle(
                        color: NeumorphicTheme.accentColor(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                      : RichText(
                    text: TextSpan(
                        text: "Resending OTP in ",
                        style: const TextStyle(
                            color: Color.fromRGBO(125, 126, 128, 1)),
                        children: [
                          TextSpan(
                              text: '$_resendTimer Seconds',
                              style: TextStyle(
                                  color:
                                  NeumorphicTheme.accentColor(context)))
                        ]),
                  )),
             SizedBox(
                height: screenHeight*0.06,
              ),
              SizedBox(
                width: 150,
                child: NeumorphicButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final response = await ApiService.verifyOtp(
                          otp, '${widget.countryCode}${widget.phone}');
                      setState(() {
                        isLoading = false;
                      });
                      if (response['success']) {
                        CustomSnackbar.show(
                            context: context,
                            message: response['message'],
                            textColor: Colors.green
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SelectCountryForStudyScreen()),
                        );
                      } else {
                        CustomSnackbar.show(
                            context: context,
                            message: response['message'],
                            textColor: Colors.red
                        );
                      }
                    } catch (error) {
                      setState(() {
                        isLoading = false;
                      });
                      CustomSnackbar.show(
                          context: context,
                          message: 'failed to verify',
                          textColor: Colors.red
                      );
                    }
                  },
                  style: NeumorphicStyle(
                    boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    depth: 2,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(child: Text("Verify OTP")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startResendTimer() {
    const Duration oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_resendTimer == 0) {
        setState(() {
          isResendOtp = false; // Reset resend state
        });
        timer.cancel();
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }
}
