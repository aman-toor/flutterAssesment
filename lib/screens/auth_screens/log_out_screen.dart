
import 'package:flutter_assesment/screens/auth_screens/welcome_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../apis/api_file.dart';
import '../../messages/toast_messages.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({Key? key}) : super(key: key);

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
                onPressed: () {
                  ApiService.logOut().then((response) {

                    if (response['success']) {
                      CustomSnackbar.show(
                          context: context,
                          message: response['message'],
                          textColor: Colors.green
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    } else {

                      CustomSnackbar.show(
                          context: context,
                          message: response['message'],
                          textColor: Colors.red
                      );
                    }
                  }).catchError((error) {

                    CustomSnackbar.show(
                        context: context,
                        message: 'failed to logout',
                        textColor: Colors.red
                    );
                  });
                },
                style: NeumorphicStyle(
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: 2,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
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
                onPressed: () {
                  ApiService.deleteAccount().then((response) {

                    if (response['success']) {
                      CustomSnackbar.show(
                          context: context,
                          message: response['message'],
                          textColor: Colors.green
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    } else {
                      CustomSnackbar.show(
                          context: context,
                          message: response['message'],
                          textColor: Colors.red
                      );
                    }
                  });
                },
                style: NeumorphicStyle(
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: 2,
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
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
}
