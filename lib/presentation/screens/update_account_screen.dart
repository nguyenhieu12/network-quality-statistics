import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_quality_statistic/data/repositories/user_repository.dart';

class UpdateAccountScreen extends StatefulWidget {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;

  UpdateAccountScreen(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  XFile? image;
  bool isImageSelected = false;
  String newImageUrl = '';

  Future getImageFromGallery() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }

    String newImagePath = pickedImage.path;

    await UserRepository.updateUserByID(widget.id, newImagePath, '0123456789');

    setState(() {
      newImageUrl = newImagePath;
    });
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
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          Text(
                            'Cập nhật tài khoản',
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
                      ElevatedButton(
                        onPressed: () {
                          getImageFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            maximumSize:
                                Size(screenWidth * 0.4, screenHeight * 0.05),
                            onPrimary: Color.fromARGB(255, 255, 177, 177)),
                        child: Row(
                          children: [
                            Icon(Icons.switch_account_sharp, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Đổi ảnh',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.fullName,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.1),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              widget.email,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400),
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
                            Icon(
                              Icons.phone,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              widget.phoneNumber,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400),
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
                      SizedBox(height: screenHeight * 0.05),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 102, 102),
                            side: BorderSide(color: Colors.transparent, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            maximumSize:
                                Size(screenWidth * 0.5, screenHeight * 0.05),
                            onPrimary: Color.fromARGB(255, 255, 102, 102)),
                        child: Center(
                          child: Text(
                            'Cập nhật',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
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
