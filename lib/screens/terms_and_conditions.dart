import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assesment/apis/api_file.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late Future<Map<String, dynamic>> _termsAndConditions;

  @override
  void initState() {
    super.initState();
    _termsAndConditions = ApiService.fetchTermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _termsAndConditions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!['data'];
            final createdDate =
                DateTime.parse(data['created_at']).toString().split(' ')[0];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/terms.png'),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              data['title'],
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: NeumorphicTheme.accentColor(context)),
                            ),
                            Text(
                              ' Update $createdDate',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(data['content'],
                        customWidgetBuilder: (element) {
                      if (element.localName == 'h1') {
                        // Customize color for h1 headings
                        return Text(
                          element.innerHtml,
                          style: TextStyle(
                              fontSize: 16,
                              color: NeumorphicTheme.accentColor(
                                  context) // Change color as needed
                              ),
                        );
                      }
                      return null;
                    }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
