import 'package:flutter/material.dart';

// Widget buildDropdownField() {
//   return Container(
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey[300]!),
//       borderRadius: BorderRadius.circular(8),
//       color: Colors.white,
//     ),
//     child: DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 16),
//         border: InputBorder.none,
//       ),
//       hint: Text(
//         'Choose the Brand',
//         style: TextStyle(color: Colors.grey[400]),
//       ),
//       items: const [],
//       onChanged: (value) {},
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a brand';
//         }
//         return null;
//       },
//     ),
//   );
// }

//!input Label

Widget buildInputLabel(String label, bool isRequired) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : null,
      ),
    ),
  );
}

// //!image Upload

// Widget buildImageUploadSection() {
//   return Column(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   'Choose the Brand',
//                   style: TextStyle(color: Colors.grey[400]),
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Browse'),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(height: 8),
//       OutlinedButton.icon(
//         onPressed: () {},
//         icon: const Icon(Icons.add_photo_alternate_outlined),
//         label: const Text('Add Image'),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Colors.blue,
//           side: const BorderSide(color: Colors.blue),
//         ),
//       ),
//     ],
//   );
// }

//! snackbar

void showCustomSnackbar({
  required BuildContext context,
  required String messsage,
  Color backgroundColor = Colors.green,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Text(
      messsage,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: action,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}





