import 'package:flutter/gestures.dart';
import 'package:flutter_assesment/screens/select_country_screen.dart';
import 'package:flutter_assesment/screens/terms_and_conditions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.grey),
            child: Image.asset('assets/images/Startup.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.53),
            child: Container(
              decoration: BoxDecoration(
                  color: NeumorphicTheme.baseColor(context),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome to Study Lancer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      'Please select your role to get Started',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                // Border width
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: screenHeight * 0.15,
                                    width: screenWidth * 0.39,
                                    child: Image.asset(
                                      'assets/images/student.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectCountry(role: 'Student'),
                                    ));
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            const Text(
                              "Student",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                // Border width
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      // Shadow color
                                      spreadRadius: 5,
                                      // Spread radius
                                      blurRadius: 7,
                                      // Blur radius
                                      offset: const Offset(0,
                                          3), // Offset, changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // Image border
                                  child: SizedBox(
                                      height: screenHeight * 0.15,
                                      width: screenWidth * 0.39,
                                      child: Image.asset(
                                        'assets/images/img2.jpg',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectCountry(role: 'Agent'),
                                    ));
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            const Text(
                              "Agent",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "By continuing you agree to our ",
                            children: [
                          TextSpan(
                              text: "Terms and Conditions",
                              style: const TextStyle(
                                  color: Color.fromRGBO(217, 137, 106, 1)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TermsAndConditions(),
                                      ));
                                }),
                        ]))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
