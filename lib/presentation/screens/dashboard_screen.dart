import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:network_quality_statistic/presentation/widgets/statistic_widget.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../utils/map_selection_info.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late MapboxMapController mapController;
  Map<String, dynamic> geoJsonData = {};
  Map<String, dynamic> provinceData = {};
  List<Map<String, dynamic>> lowGeoJson = [];
  List<Map<String, dynamic>> mediumGeoJson = [];
  List<Map<String, dynamic>> highGeoJson = [];
  List<dynamic> provincesValue = [];
  Set<String> provinceQuantity = {};
  Set<String> lowQuantity = {};
  Set<String> mediumQuantity = {};
  Set<String> highQuantity = {};
  Uuid uuid = const Uuid();
  int lowThreshold = 30;
  int highThreshold = 70;
  String currentProvince = '';
  String selectedOption = 'Toàn quốc';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;

    if (MapSelectionInfo.isAll) {
      removeAllLayers();
    } else {
      removeAreaLayer(MapSelectionInfo.currentArea);
      MapSelectionInfo.currentArea = '';
    }

    initMapAll();

    mapController.onFeatureTapped.add((id, point, coordinates) {
      handleProvinceTapped(id);
    });
  }

  final List<String> listOptions = [
    'Toàn quốc',
    'Miền Bắc',
    'Miền Trung',
    'Miền Nam'
  ];

  final List<int> lowOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90];
  final List<int> highOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90];

  Future<void> initMapAll() async {
    try {
      String data =
          await rootBundle.loadString('assets/data/vietnam_province.geojson');
      geoJsonData = json.decode(data);

      String provinces =
          await rootBundle.loadString('assets/data/province_data.json');
      provincesValue = json.decode(provinces);

      List<dynamic> features = geoJsonData['features'];

      for (int i = 0; i < features.length; i++) {
        features[i]['id'] = uuid.v4();
        for (int j = 0; j < provincesValue.length; j++) {
          if (features[i]['properties']['Name_VI'] ==
              provincesValue[j]['province_name']) {
            features[i]['kqi'] = provincesValue[j]['value'];
          }
        }
      }

      geoJsonData['features'] = features;

      provinceData = {
        for (var item in geoJsonData['features']) item['id']: item
      };

      for (int i = 0; i < features.length; i++) {
        int value = features[i]['kqi'];
        String provinceName = features[i]['properties']['Name_VI'];

        if (value < lowThreshold) {
          lowGeoJson.add(features[i]);
          lowQuantity.add(provinceName);
          provinceQuantity.add(provinceName);
        } else if (value > highThreshold) {
          highGeoJson.add(features[i]);
          highQuantity.add(provinceName);
          provinceQuantity.add(provinceName);
        } else {
          mediumGeoJson.add(features[i]);
          mediumQuantity.add(provinceName);
          provinceQuantity.add(provinceName);
        }
      }

      Map<String, dynamic> lowFeatureCollection = {
        "type": "FeatureCollection",
        "features": lowGeoJson,
      };

      Map<String, dynamic> mediumFeatureCollection = {
        "type": "FeatureCollection",
        "features": mediumGeoJson,
      };

      Map<String, dynamic> highFeatureCollection = {
        "type": "FeatureCollection",
        "features": highGeoJson,
      };

      addLayer('sourceId-low', 'layerId-low', lowFeatureCollection, '#FF4A4A');
      addLayer('sourceId-medium', 'layerId-medium', mediumFeatureCollection,
          '#FF9533');
      addLayer(
          'sourceId-high', 'layerId-high', highFeatureCollection, '#6FE844');

      MapSelectionInfo.isAll = true;

      setState(() {});
    } catch (e) {
      debugPrint('Error adding layer: $e');
    }
  }

  Future<void> initMapArea(String selectedArea) async {
    String area = await rootBundle.loadString('assets/data/province_domain.json');
    Map<String, dynamic> areaData = json.decode(area);
    List<dynamic> provincesName = areaData[selectedArea];

    List<dynamic> features = geoJsonData['features'];

    for (int i = 0; i < provincesName.length; i++) {
      for (int j = 0; j < features.length; j++) {
        if (provincesName[i] == features[j]['properties']['Name_VI']) {
          if (features[j]['kqi'] < lowThreshold) {
            lowGeoJson.add(features[j]);
            provinceQuantity.add(features[i]['properties']['Name_VI']);
            lowQuantity.add(features[i]['properties']['Name_VI']);
          } else if (features[j]['kqi'] > highThreshold) {
            highGeoJson.add(features[j]);
            provinceQuantity.add(features[i]['properties']['Name_VI']);
            highQuantity.add(features[i]['properties']['Name_VI']);
          } else {
            mediumGeoJson.add(features[j]);
            provinceQuantity.add(features[i]['properties']['Name_VI']);
            mediumQuantity.add(features[i]['properties']['Name_VI']);
          }
        }
      }
    }

    if (lowGeoJson.isNotEmpty) {
      Map<String, dynamic> lowFeatureCollection = {
        "type": "FeatureCollection",
        "features": lowGeoJson,
      };

      addLayer('sourceId-low-$selectedArea', 'layerId-low-$selectedArea',
          lowFeatureCollection, '#FF4A4A');
    }

    if (mediumGeoJson.isNotEmpty) {
      Map<String, dynamic> mediumFeatureCollection = {
        "type": "FeatureCollection",
        "features": mediumGeoJson,
      };

      addLayer('sourceId-medium-$selectedArea', 'layerId-medium-$selectedArea',
          mediumFeatureCollection, '#FF9533');
    }

    if (highGeoJson.isNotEmpty) {
      Map<String, dynamic> highFeatureCollection = {
        "type": "FeatureCollection",
        "features": highGeoJson,
      };

      addLayer('sourceId-high-$selectedArea', 'layerId-high-$selectedArea',
          highFeatureCollection, '#6FE844');
    }

    selectedArea == 'Miền Bắc'
        ? await mapController.moveCamera(
            CameraUpdate.newLatLngZoom(LatLng(21.520133, 105.080089), 5.6))
        : (selectedArea == 'Miền Trung'
            ? await mapController.moveCamera(
                CameraUpdate.newLatLngZoom(LatLng(15.386838, 106.578776), 5.15))
            : await mapController.moveCamera(CameraUpdate.newLatLngZoom(
                LatLng(10.079575, 106.0102799), 6.35)));

    setState(() {
      
    });
  }

  Future<void> removeAllLayers() async {
    geoJsonData.clear();
    lowGeoJson.clear();
    mediumGeoJson.clear();
    highGeoJson.clear();
    provinceQuantity.clear();
    lowQuantity.clear();
    mediumQuantity.clear();
    highQuantity.clear();

    await mapController.removeLayer('layerId-low');
    await mapController.removeSource('sourceId-low');

    await mapController.removeLayer('layerId-medium');
    await mapController.removeSource('sourceId-medium');

    await mapController.removeLayer('layerId-high');
    await mapController.removeSource('sourceId-high');
  }

  Future<void> removeAreaLayer(String selectedArea) async {
    lowGeoJson.clear();
    mediumGeoJson.clear();
    highGeoJson.clear();
    provinceQuantity.clear();
    lowQuantity.clear();
    mediumQuantity.clear();
    highQuantity.clear();

    await mapController.removeLayer('layerId-low-$selectedArea');
    await mapController.removeSource('sourceId-low-$selectedArea');

    await mapController.removeLayer('layerId-medium-$selectedArea');
    await mapController.removeSource('sourceId-medium-$selectedArea');

    await mapController.removeLayer('layerId-high-$selectedArea');
    await mapController.removeSource('sourceId-high-$selectedArea');

    debugPrint('AREA: $selectedArea DELETED');
  }

  void addLayer(String sourceId, String layerId,
      Map<String, dynamic> geoJsonSource, String color) async {
    await mapController.addGeoJsonSource(sourceId, geoJsonSource);
    await mapController.addLayer(
        sourceId,
        layerId,
        FillLayerProperties(
          fillColor: color,
          fillOutlineColor: 'black',
        ));
  }

  Future<void> handleOptionSelected(String newValue) async {
    if (newValue.contains('Miền')) {
      if (MapSelectionInfo.currentArea == '') {
        MapSelectionInfo.currentArea = newValue;
        selectedOption = newValue;
        MapSelectionInfo.isAll = false;
        await removeAllLayers();
        await initMapArea(newValue);
        setState(() {});
      } else if (MapSelectionInfo.currentArea == newValue) {
        return;
      } else {
        await removeAreaLayer(MapSelectionInfo.currentArea);
        await initMapArea(newValue);
        MapSelectionInfo.currentArea = newValue;
        selectedOption = newValue;
        setState(() {});
      }
    } else if (newValue == 'Toàn quốc') {
      if (MapSelectionInfo.currentArea != '') {
        await removeAreaLayer(MapSelectionInfo.currentArea);
        await initMapAll();
        MapSelectionInfo.currentArea = '';
        selectedOption = newValue;
        await mapController.moveCamera(
            CameraUpdate.newLatLngZoom(LatLng(16.102622, 105.690185), 4.6));
        setState(() {});
      }
    }
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
                padding: const EdgeInsets.only(top: 5),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 32,
                      color: Colors.black,
                    )),
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Thông tin tỉnh/thành phố',
                        style: TextStyle(fontSize: 26),
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
                              '${provinceData[id]['properties']['Name_VI']}',
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
                              '$lowThreshold - $highThreshold',
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
                              '${provinceData[id]['kqi']}',
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
                              '${(provinceData[id]['kqi'] < lowThreshold ? 'Tồi' : (provinceData[id]['kqi'] > highThreshold ? 'Tốt' : 'Trung bình'))}',
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

  void showAreaOptions(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 28,
                      color: Colors.black,
                    )),
              ),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Chọn phạm vi',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await handleOptionSelected('Toàn quốc');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Toàn quốc',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await handleOptionSelected('Miền Bắc');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Miền Bắc',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await handleOptionSelected('Miền Trung');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Miền Trung',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await handleOptionSelected('Miền Nam');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'Miền Nam',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ])),
            ],
          ),
        );
      }),
    );
  }

  void alertThresholdError(double screenWidth, double screenHeight) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 80, 80),
            title: Center(
              child: const Text(
                'Lỗi giá trị',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            content: Container(
              height: height * 0.1,
              width: width * 0.95,
              child: Column(
                children: [
                  Text(
                    'Ngưỡng dưới không thể lớn',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'hơn hoặc bằng ngưỡng trên',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            actions: [
              Center(
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Center(
                      child: Text(
                        'Đóng',
                        style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 255, 80, 80),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }

  void showThresholdOptions(double screenWidth, double screenHeight) {
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          width: double.infinity,
          height: screenHeight * 0.4,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02, left: screenWidth * 0.05),
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
                child: Container(
                  width: screenWidth * 0.9,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.028),
                      Text(
                        'Thay đổi ngưỡng',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngưỡng dưới',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: screenWidth * 0.46),
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: DropdownButtonFormField<int>(
                              value: lowThreshold,
                              onChanged: (newValue) {
                                if (newValue! >= highThreshold) {
                                  Navigator.pop(context);
                                  setState(() {
                                    showThresholdOptions(
                                        screenWidth, screenHeight);
                                    alertThresholdError(
                                        screenWidth, screenHeight);
                                  });
                                } else {
                                  setState(() {
                                    lowThreshold = newValue;
                                  });
                                }
                              },
                              items: lowOptions.map((int value) {
                                return DropdownMenuItem(
                                  value: value,
                                  alignment: AlignmentDirectional.center,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              menuMaxHeight: screenHeight * 0.3,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              dropdownColor: Colors.white,
                              iconSize: 40.0,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngưỡng trên',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: screenWidth * 0.46),
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: DropdownButtonFormField(
                              value: highThreshold,
                              onChanged: (newValue) {
                                if (newValue! <= lowThreshold) {
                                  Navigator.pop(context);
                                  setState(() {
                                    showThresholdOptions(
                                        screenWidth, screenHeight);
                                    alertThresholdError(
                                        screenWidth, screenHeight);
                                  });
                                } else {
                                  setState(() {
                                    highThreshold = newValue;
                                  });
                                }
                              },
                              items: highOptions.map((int value) {
                                return DropdownMenuItem(
                                  value: value,
                                  alignment: AlignmentDirectional.center,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              menuMaxHeight: screenHeight * 0.3,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              dropdownColor: Colors.white,
                              iconSize: 40.0,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        width: screenWidth * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 80, 80)),
                          onPressed: () async {
                            if (MapSelectionInfo.isAll) {
                              await removeAllLayers();
                              await initMapAll();
                              Navigator.pop(context);
                            } else if (MapSelectionInfo.currentArea != '') {
                              await removeAreaLayer(MapSelectionInfo.currentArea);
                              await initMapArea(MapSelectionInfo.currentArea);
                              Navigator.pop(context);
                            }
                            setState(() {});
                          },
                          child: Center(
                            child: Text(
                              'Áp dụng',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.08),
                Container(
                  width: screenWidth * 0.95,
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.46,
                        height: screenHeight * 0.042,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 1.5),
                              onPrimary: Color.fromARGB(255, 255, 80, 80)),
                          onPressed: () {
                            showAreaOptions(context);
                          },
                          icon: Icon(
                            Icons.border_all_rounded,
                            size: 22,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Phạm vi',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: screenWidth * 0.46,
                        height: screenHeight * 0.042,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 1.5),
                              onPrimary: Color.fromARGB(255, 255, 80, 80)),
                          onPressed: () {
                            showThresholdOptions(screenWidth, screenHeight);
                          },
                          icon: Icon(
                            Icons.data_thresholding_outlined,
                            size: 22,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Chọn ngưỡng',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatisticWidget(
                        label: 'Tốt',
                        statistic: (highQuantity.length).toString() +
                            '/' +
                            (provinceQuantity.length).toString(),
                        percent: (((highQuantity.length) /
                                    (provinceQuantity.length)) *
                                    100.0)
                                .toStringAsFixed(2) +
                            '%',
                        color: Color.fromARGB(255, 67, 217, 13),
                        screenWidth: screenWidth,
                        screenHeight: screenHeight),
                    StatisticWidget(
                        label: 'Trung bình',
                        statistic: (mediumQuantity.length).toString() +
                            '/' +
                            (provinceQuantity.length).toString(),
                        percent: (((mediumQuantity.length) /
                                    (provinceQuantity.length)) *
                                    100.0)
                                .toStringAsFixed(2) +
                            '%',
                        color: Color.fromARGB(255, 255, 153, 0),
                        screenWidth: screenWidth,
                        screenHeight: screenHeight),
                    StatisticWidget(
                        label: 'Tồi',
                        statistic: (lowQuantity.length).toString() +
                            '/' +
                            (provinceQuantity.length).toString(),
                        percent: (((lowQuantity.length) /
                                    (provinceQuantity.length)) *
                                    100.0)
                                .toStringAsFixed(2) +
                            '%',
                        color: Color.fromARGB(255, 255, 80, 80),
                        screenWidth: screenWidth,
                        screenHeight: screenHeight),
                  ],
                ),
                Container(
                  child: Divider(
                    thickness: 0.6,
                  ),
                ),
                Container(
                  height: screenHeight * 0.65,
                  child: MapboxMap(
                    accessToken:
                        'sk.eyJ1IjoiaGlldW5tMTIxMiIsImEiOiJjbGxpdWZxbGUwa2xlM2pxdWt5dXBiaHpoIn0.V-v43bc4XXDm7dI5lNkGew',
                    styleString:
                        'mapbox://styles/hieunm1212/clkq6rt3s00cb01ph7e3z6dtx',
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(15.702622, 105.690185), zoom: 4.6),
                    onMapCreated: _onMapCreated,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}