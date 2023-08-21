import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LineScreen extends StatefulWidget {
  const LineScreen({super.key});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  late MapboxMapController mapController;
  // List<String> _suggestions = [
  //   'Apple',
  //   'Banana',
  //   'Cherry',
  //   'Date',
  //   'Fig',
  //   'Grape',
  //   'Kiwi',
  //   'Lemon',
  //   'Mango',
  //   'Orange',
  //   'Peach',
  //   'Pear',
  //   'Pineapple',
  //   'Strawberry',
  //   'Watermelon',
  // ];

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.15),
            Row(
              children: [
                // DropdownButton(items: items, onChanged: onChanged)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 78, 198, 35),
                  ),
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Tốt',
                        style: TextStyle(
                            fontSize: screenWidth * 0.048,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 153, 0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          'Trung bình',
                          style: TextStyle(
                              fontSize: screenWidth * 0.048,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 80, 80),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Tồi',
                        style: TextStyle(
                            fontSize: screenWidth * 0.048,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Divider(
                thickness: 0.6,
              ),
            ),
            Container(
              height: screenHeight * 0.6,
              child: MapboxMap(
                accessToken:
                    'sk.eyJ1IjoiaGlldW5tMTIxMiIsImEiOiJjbGptanBtMmExNmhjM3FrMjE1bHZpdzVmIn0.TwqdH0eYn4xy34qcyFWgkQ',
                styleString:
                    'mapbox://styles/hieunm1212/clkq6rt3s00cb01ph7e3z6dtx',
                initialCameraPosition: const CameraPosition(
                    target: LatLng(21.028511, 105.804817), zoom: 2.0),
                onMapCreated: _onMapCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
