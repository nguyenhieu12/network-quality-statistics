import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;

  AccountInfoScreen(
      {required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            color: Colors.white,
            child: Stack(
              children: [
                ClipPath(
                    clipper: AccountInfoClipPath(),
                    child: Container(
                        height: screenHeight * 0.4,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 102, 102)))),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          Text(
                            'Thông tin tài khoản',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.08),
                      CircleAvatar(
                        radius: 80.0,
                        backgroundImage: NetworkImage(widget.imageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: 30),
                      Text(
                        widget.fullName,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: 30,),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.1),
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined, color: Colors.red, size: 30,),
                            SizedBox(width: 20,),
                            Text(widget.email,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.2),
                        child: Container(
                          child: const Divider(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.1),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.red, size: 30,),
                            SizedBox(width: 20,),
                            Text(widget.phoneNumber,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.2),
                        child: Container(
                          child: const Divider(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
            
      ),
    );
  }
}

class AccountInfoClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();

    path.lineTo(0, height - 120);
    path.quadraticBezierTo(width / 2, height, width, height - 120);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
