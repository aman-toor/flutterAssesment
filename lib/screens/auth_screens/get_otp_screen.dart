import 'package:flutter_assesment/apis/api_file.dart';
import 'package:flutter_assesment/screens/auth_screens/verify_otp_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../messages/toast_messages.dart';

class GetOtpScreen extends StatefulWidget {
  final String image;
  final String telcode;
  final String role;

  const GetOtpScreen(
      {super.key,
      required this.image,
      required this.telcode,
      required this.role});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  TextEditingController phoneController = TextEditingController();
 bool isLoading=false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
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
            ),
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
          key: _formKey,
          child: Column(
            children: [
              const Center(
                  child: Text(
                "Enter phone number",
                style: TextStyle(fontSize: 20),
              )),
              Text(
                "Please enter your 10 digit mobile number to receive OTP",
                style: TextStyle(
                  color: NeumorphicTheme.accentColor(context),
                ),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SvgPicture.network(
                      widget.image,
                      width: screenWidth*0.03,
                      height: screenHeight*0.03,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixText: widget.telcode,
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight*0.45,
              ),
              SizedBox(
                width: 150,
                child: NeumorphicButton(
                  onPressed: () =>_handleLogIn(),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    depth: 2,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(child: Text("Get OTP")),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void _handleLogIn() async {
    if (_formKey.currentState!.validate() && !isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = widget.role == 'Student'
            ? await ApiService.studentLogin(
          widget.telcode,
          phoneController.text,
        )
            : await ApiService.counsellorLogin(
          widget.telcode,
          phoneController.text,
        );

        setState(() {
          isLoading = false;
        });

        if (response['success']==true) {
          CustomSnackbar.show(
            context: context,
            message: response['message'],
            textColor: Colors.green,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpScreen(
                phone: phoneController.text,
                countryCode: widget.telcode,
              ),
            ),
          );
        } else {
          if (response['success'] == false ) {
            CustomSnackbar.show(
              context: context,
              message: response['message'],
              textColor: Colors.green,
            );
          }
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });

        CustomSnackbar.show(
          context: context,
          message: 'Failed to login',
          textColor: Colors.red,
        );
      }
    }
  }

}
