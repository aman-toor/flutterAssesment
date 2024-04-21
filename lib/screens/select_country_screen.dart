
import 'package:flutter_assesment/screens/auth_screens/get_otp_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

import '../apis/api_file.dart';

class SelectCountry extends StatefulWidget {
  final String role;
  const SelectCountry({super.key, required this.role});

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  late Future<Map<String, dynamic>> _countryList;
  List<dynamic> _allResult = [];
  final List<dynamic> _searchResult = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countryList = ApiService.fetchCountryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              "Select Your Country",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: NeumorphicTheme.accentColor(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _countryList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final countryData = snapshot.data!['data'];
                  _allResult = countryData;

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final List<dynamic> displayData =
                      _searchResult.isNotEmpty ? _searchResult : countryData;

                      final imageUrl = displayData[index]['flag'];
                      final countryName = displayData[index]['name'];
                      final countryCode = displayData[index]['tel_code'];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetOtpScreen(
                                image: imageUrl,
                                telcode: countryCode,
                                role: widget.role,
                              ),
                            ),
                          );
                        },
                        title: Row(
                          children: [
                            SvgPicture.network(imageUrl, width: 20, height: 20),
                            const SizedBox(width: 10),
                            Text(
                              countryName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: Text(
                          countryCode,
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 2,
                    ),
                    itemCount:  _searchResult.isNotEmpty ? _searchResult.length : countryData.length
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var country in _allResult) {
      if (country['name'].toString().toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(country);
      }
    }

    setState(() {});
  }
}
