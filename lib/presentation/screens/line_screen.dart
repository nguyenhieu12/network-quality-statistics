import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
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
    'Quốc lộ 1, Hoàng Mai',
    'Quốc lộ 1, Thanh Trì',
    'Quốc lộ 1, Phú Xuyên',
    'Quốc lộ 1, Thường Tín'
  ];
  List<String> filteredSuggestions = [];
  late List<dynamic> jsonData = [];
  late Map<String, dynamic> lowKqiGeoJson;
  late Map<String, dynamic> mediumKqiGeoJson;
  late Map<String, dynamic> highKqiGeoJson;
  late Map<String, dynamic> featuresMap;
  List<Map<String, dynamic>> lowData = [];
  List<Map<String, dynamic>> mediumData = [];
  List<Map<String, dynamic>> highData = [];
  late LatLng currentLatlng;
  double lowThreshold = -105.0;
  double highThreshold = -101.0;
  Uuid uuid = const Uuid();

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;

    mapController.onFeatureTapped.add((id, point, coordinates) {
      handleProvinceTapped(id);
    });
  }

  void handleProvinceTapped(dynamic id) {
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 30,
                      color: Colors.black,
                    )),
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Thông tin tỉnh/thành phố',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tỉnh/thành phố:',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${featuresMap[id]['district']}',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Container(
                          child: Divider(
                            thickness: 0.8,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ngưỡng mạng:',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              '($lowThreshold) -> ($highThreshold)',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Container(
                          child: Divider(
                            thickness: 0.8,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giá trị:',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${featuresMap[id]['kqi']}',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Container(
                          child: Divider(
                            thickness: 0.8,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chất lượng:',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${(featuresMap[id]['kqi'] < lowThreshold ? 'Tồi' : (featuresMap[id]['kqi'] > highThreshold ? 'Tốt' : 'Trung bình'))}',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        );
      }),
    );
  }

  final List<int> lowOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90];
  final List<int> highOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90];

  Future<void> loadJSONData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/line_data.json');
      jsonData = json.decode(jsonString);
      for (int i = 0; i < jsonData.length; i++) {
        jsonData[i]['id'] = uuid.v4();
      }
      featuresMap = {for (var item in jsonData) item['id']: item};
    } catch (e) {
      debugPrint('Error loading JSON data: $e');
    }
  }

  Future<void> loadGeoJson(String roadInfo) async {
    for (var item in jsonData) {
      if (roadInfo.contains(item['district'])) {
        double kqi = item['kqi'];
        if (kqi < lowThreshold) {
          lowData.add(item);
        } else if ((kqi >= lowThreshold) && (kqi <= highThreshold)) {
          mediumData.add(item);
        } else {
          highData.add(item);
        }
      }
    }

    // int length = (jsonData.length / 2) as int;

    // currentLatlng = LatLng(jsonData[length]['lat'], jsonData[length]['lng']);

    lowKqiGeoJson = createGeoJson(lowData);
    mediumKqiGeoJson = createGeoJson(mediumData);
    highKqiGeoJson = createGeoJson(highData);

    // mapController.moveCamera(CameraUpdate.newLatLngZoom(currentLatlng, 12.0));
    // setState(() {});
  }

  Map<String, dynamic> createGeoJson(List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> features = data.map((item) {
      double lat = item['lat'];
      double lng = item['lng'];
      String id = item['id'];

      return {
        'type': 'Feature',
        'id': id,
        'properties': {},
        'geometry': {
          'type': 'Point',
          'coordinates': [lng, lat],
        },
      };
    }).toList();

    return {
      'type': 'FeatureCollection',
      'features': features,
    };
  }

  void addLayer(String sourceId, String layerId, Map<String, dynamic> geoJson,
      String color) async {
    try {
      mapController.addGeoJsonSource(sourceId, geoJson);

      mapController.addCircleLayer(
          sourceId,
          layerId,
          CircleLayerProperties(
            circleColor:
                color, // < -105 red, -105 -> -101 orange, > -101 lightgreen
            circleRadius: 8,
          ));
    } catch (e) {
      debugPrint('Error adding circle layer: $e');
    }
  }

  Future<void> addAllCircleLayers() async {
    addLayer('lowKqiGeoJson', 'lowLayer', lowKqiGeoJson, '#FF4A4A');
    addLayer('mediumKqiGeoJson', 'mediumLayer', mediumKqiGeoJson, '#FF9533');
    addLayer('highKqiGeoJson', 'highLayer', highKqiGeoJson, '#6FE844');
  }

  Future<void> removeAllCircleLayers() async {
    if (lowData.isNotEmpty || mediumData.isNotEmpty || highData.isNotEmpty) {
      lowData.clear();
      mediumData.clear();
      highData.clear();
      lowKqiGeoJson.clear();
      mediumKqiGeoJson.clear();
      highKqiGeoJson.clear();
      mapController.removeLayer('lowLayer');
      mapController.removeLayer('mediumLayer');
      mapController.removeLayer('highLayer');
      mapController.removeSource('lowKqiGeoJson');
      mapController.removeSource('mediumKqiGeoJson');
      mapController.removeSource('highKqiGeoJson');
    }
  }

  void handleTextInputFinished() async {
    FocusScope.of(context).unfocus();
    await removeAllCircleLayers();
    await loadGeoJson(searchController.text);
    await addAllCircleLayers();
    // await mapController
    //     .moveCamera(CameraUpdate.newLatLngZoom(currentLatlng, 12.0));
  }

  @override
  void initState() {
    super.initState();
    loadJSONData();
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
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }

                    return suggestions.where((String suggestion) {
                      return suggestion.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                    });
                  },
                  onSelected: (String item) async {
                    searchController.text = item;
                    FocusScope.of(context).unfocus();
                    await removeAllCircleLayers();
                    await loadGeoJson(searchController.text);
                    await addAllCircleLayers();
                    // mapController.moveCamera(
                    //     CameraUpdate.newLatLngZoom(currentLatlng, 12.0));
                    // setState(() {});
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      onEditingComplete: handleTextInputFinished,
                      cursorHeight: 28,
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Tìm kiếm',
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 108, 108, 108),
                        ),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          size: 24,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          bottom: 80,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        alignLabelWithHint: true,
                      ),
                      onTap: () {
                        fieldTextEditingController.text = searchController.text;
                        fieldTextEditingController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    fieldTextEditingController.text.length));

                        fieldTextEditingController.addListener(() {
                          final searchText =
                              fieldTextEditingController.text.toLowerCase();
                          setState(() {
                            filteredSuggestions = suggestions
                                .where((suggestion) => suggestion
                                    .toLowerCase()
                                    .contains(searchText))
                                .toList();
                          });
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
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
                      target: LatLng(21.028511, 105.804817), zoom: 10.0),
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
