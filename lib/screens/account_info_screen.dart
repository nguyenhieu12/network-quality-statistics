import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          ClipPath(
            clipper: AccountInfoClipPath(),
            child: Container(
              height: screenHeight * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 102, 102)
              )
            )
          ),
          
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Text('Thông tin tài khoản',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        decoration: TextDecoration.none
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.08),
                CircleAvatar(
                  radius: 75.0,
                  backgroundImage: NetworkImage('https://mirror-media.imgix.net/publication-images/_Cw2xE5CuyrQvxgsrisDb.png?h=800&w=1200'),
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  'Nguyễn Văn A',
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
          )
        ],
      )
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