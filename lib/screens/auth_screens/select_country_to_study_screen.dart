
import 'package:flutter/material.dart';
import 'package:flutter_assesment/screens/auth_screens/log_out_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../apis/api_file.dart';
import '../../messages/toast_messages.dart';

class SelectCountryForStudyScreen extends StatefulWidget {
  const SelectCountryForStudyScreen({Key? key}) : super(key: key);

  @override
  _SelectCountryForStudyScreenState createState() =>
      _SelectCountryForStudyScreenState();
}

class _SelectCountryForStudyScreenState
    extends State<SelectCountryForStudyScreen> {
  late Future<Map<String, dynamic>> selectCountry;
  late List<bool> imageColorState;
  late int id = 0;
  bool isLoading = false;
  bool isSuccessResponse=false;

  @override
  void initState() {
    super.initState();
    imageColorState=[];
    selectCountry=ApiService.showCountries();
     selectCountry.then((data) {
      if (data['success'] == true) {
        final countries = data['data']['countries'] as List<dynamic>;
        imageColorState = List.generate(countries.length, (index) => false);

      } else {
        setState(() {
          isSuccessResponse = false;
        });
      }
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            const Center(
                child: Text("Select Country", style: TextStyle(fontSize: 20))),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Please select the country where you want to study",
              style: TextStyle(
                color: NeumorphicTheme.accentColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(
              height: 50,
            ),
            // if (isSuccessResponse == true) ...[
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: selectCountry,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final countries =
                          snapshot.data!['countries'] as List<dynamic>;
                      if (countries.isEmpty) {
                        return const Center(
                            child: Text("No countries available"));
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 40,
                          ),
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            final country = countries[index];
                            final imageUrl = country['flag'];
                            final countryName = country['name'];
                            id = country['id'];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imageColorState[index] =
                                          !imageColorState[index];
                                    });
                                  },
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      NeumorphicTheme.baseColor(context),
                                      imageColorState[index]
                                          ? BlendMode.colorDodge
                                          : BlendMode.color,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SvgPicture.network(
                                        imageUrl,
                                        height: 70,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(countryName),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),

            // else if(isSuccessResponse==false) ...[
            //   const Text("You are already associated with a company")
            // ],
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 180,
              child: NeumorphicButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (isSuccessResponse == true) {
                          try {
                            final response =
                                await ApiService.selectCountryForStudy(
                                    id.toString());
                            setState(() {
                              isLoading = false;
                            });
                            if (response['success']) {
                              CustomSnackbar.show(
                                  context: context,
                                  message: response['message'],
                                  textColor: Colors.green);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogOutScreen()),
                              );
                            } else {
                              CustomSnackbar.show(
                                  context: context,
                                  message: response['message'],
                                  textColor: Colors.red);
                            }
                          } catch (error) {
                            setState(() {
                              isLoading = false;
                            });
                            CustomSnackbar.show(
                                context: context,
                                message: 'failed to select',
                                textColor: Colors.red);
                          }
                        }
                        else{
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogOutScreen()),
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
                    : const Center(child: Text("Proceed")),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Can't see the country of your interest?",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Consult with us",
              style: TextStyle(
                  color: NeumorphicTheme.accentColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
