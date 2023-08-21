// import 'package:flutter/material.dart';

// class DropDownMenuWidget extends StatefulWidget {
//   double screenWidth;
//   double screenHeight;
//   dynamic options;
//   List listOptions;

//   DropDownMenuWidget({
//     required this.screenWidth,
//     required this.screenHeight,
//     required this.options,
//     required this.listOptions
//   });

//   @override
//   State<DropDownMenuWidget> createState() => _DropDownMenuWidgetState();
// }

// class _DropDownMenuWidgetState extends State<DropDownMenuWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//                       constraints: BoxConstraints(
//                         maxWidth: widget.screenWidth * 0.46
//                       ),
//                       width: widget.screenWidth * 0.46,
//                       height: screenHeight * 0.04,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black,
//                         ),
//                         borderRadius: BorderRadius.circular(20)
//                       ),
//                       child: DropdownButtonFormField(
//                         value: selectedOption,
//                         onChanged: (newValue) {
//                           setState(() {
//                             selectedOption = newValue!;
//                           });
//                         },
//                         items: listOptions.map<DropdownMenuItem>((dynamic value) {
//                           return DropdownMenuItem(
//                             value: value,
//                             alignment: AlignmentDirectional.center,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: BorderSide(color: Colors.black),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                             borderSide: BorderSide(color: Colors.black),
//                           ),
//                           contentPadding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         menuMaxHeight: screenHeight * 0.3,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16
//                         ),
//                         dropdownColor: Colors.white,
//                         iconSize: 36.0,
//                       ),
//                     );
//   }
// }