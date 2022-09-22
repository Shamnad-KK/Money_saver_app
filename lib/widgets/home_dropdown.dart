// import 'package:flutter/material.dart';
// import 'package:money_manager/helpers/text_style.dart';

// class HomeDropDown extends StatefulWidget {
//   const HomeDropDown({Key? key}) : super(key: key);

//   @override
//   State<HomeDropDown> createState() => _HomeDropDownState();
// }

// class _HomeDropDownState extends State<HomeDropDown> {
//   String dropDownValue = 'ALL';

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton<String>(
//         alignment: Alignment.centerRight,
//         elevation: 16,
//         value: dropDownValue,
//         items: <String>[
//           'ALL',
//           'INCOME',
//           'EXPENSE',
//         ]
//             .map<DropdownMenuItem<String>>(
//               (String value) => DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: appLargeTextStyle,
//                 ),
//               ),
//             )
//             .toList(),
//         onChanged: (String? newValue) {
//           setState(() {
//             dropDownValue = newValue ?? '';
//           });
//         },
//       ),
//     );
//   }
// }
