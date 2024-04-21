import 'package:flutter/material.dart';
import 'package:flutter_assesment/screens/welcome_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../apis/api_file.dart';
import '../../messages/toast_messages.dart';

class LogOutScreen extends StatefulWidget {
  const LogOutScreen({Key? key}) : super(key: key);

  @override
  _LogOutScreenState createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  bool isLoadingLogout = false;
  bool isLoadingDelete=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 150,
              child: NeumorphicButton(
                onPressed: isLoadingLogout ? null : _handleLogOut,
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: 2,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: isLoadingLogout
                      ? const CircularProgressIndicator()
                      : Text(
                    "Logout",
                    style: TextStyle(
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 180,
              child: NeumorphicButton(
                onPressed: isLoadingDelete ? null : _handleDeleteAccount,
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: 2,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: isLoadingDelete
                      ? const CircularProgressIndicator()
                      : Text(
                    "Delete User",
                    style: TextStyle(
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogOut() {
    setState(() {
      isLoadingLogout = true;
    });
    ApiService.logOut().then((response) {
      setState(() {
        isLoadingLogout = false;
      });
      if (response['success']) {
        CustomSnackbar.show(
          context: context,
          message: response['message'],
          textColor: Colors.green,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      } else {
        CustomSnackbar.show(
          context: context,
          message: response['message'],
          textColor: Colors.red,
        );
      }
    }).catchError((error) {
      setState(() {
        isLoadingLogout = false;
      });
      CustomSnackbar.show(
        context: context,
        message: 'failed to logout',
        textColor: Colors.red,
      );
    });
  }

  void _handleDeleteAccount() {
    setState(() {
      isLoadingDelete = true;
    });
    ApiService.deleteAccount().then((response) {
      setState(() {
        isLoadingDelete = false;
      });
      if (response['success']) {
        CustomSnackbar.show(
          context: context,
          message: response['message'],
          textColor: Colors.green,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      } else {
        CustomSnackbar.show(
          context: context,
          message: response['message'],
          textColor: Colors.red,
        );
      }
    }).catchError((error) {
      setState(() {
        isLoadingDelete = false;
      });
      CustomSnackbar.show(
        context: context,
        message: 'failed to delete',
        textColor: Colors.red,
      );
    });
  }
}
