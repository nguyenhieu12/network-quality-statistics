import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../widgets/statistic_widget.dart';

class LineScreen extends StatefulWidget {
  const LineScreen({super.key});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  late MapboxMapController mapController;
  TextEditingController searchController = TextEditingController();
  List<String> suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Pear',
    'Pineapple',
    'Strawberry',
    'Watermelon',
  ];

  List<String> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterSuggestions);
  }

  void filterSuggestions() {
    final searchText = searchController.text.toLowerCase();
    setState(() {
      filteredSuggestions = suggestions
          .where((suggestion) => suggestion.toLowerCase().contains(searchText))
          .toList();
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              SizedBox(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.05,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                    ),
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder
                          .none, // Đây là phần quan trọng để xóa gạch ngang
                      labelText: 'Tìm kiếm',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 108, 108, 108),
                      ),
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.only(left: 16, bottom: 100),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  )),
              SizedBox(height: 15),
              // SizedBox(
              //   width: screenWidth * 0.95,
              //   height: screenHeight * 0.05,
              //   child: ListView.builder(
              //     itemCount: filteredSuggestions.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(filteredSuggestions[index]),
              //         onTap: () {
              //           searchController.text = filteredSuggestions[index];
              //         },
              //       );
              //     },
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatisticWidget(
                      label: 'Tốt',
                      statistic: '',
                      percent: '',
                      color: Color.fromARGB(255, 67, 217, 13),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  StatisticWidget(
                      label: 'Trung bình',
                      statistic: '',
                      percent: '',
                      color: Color.fromARGB(255, 255, 153, 0),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  StatisticWidget(
                      label: 'Tồi',
                      statistic: '',
                      percent: '',
                      color: Color.fromARGB(255, 255, 80, 80),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight)
                ],
              ),
              Container(
                child: Divider(
                  thickness: 0.6,
                ),
              ),
              Container(
                height: screenHeight * 0.62,
                child: MapboxMap(
                  accessToken:
                      'sk.eyJ1IjoiaGlldW5tMTIxMiIsImEiOiJjbGptanBtMmExNmhjM3FrMjE1bHZpdzVmIn0.TwqdH0eYn4xy34qcyFWgkQ',
                  styleString: MapboxStyles.MAPBOX_STREETS,
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(21.028511, 105.804817), zoom: 12.0),
                  onMapCreated: _onMapCreated,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
