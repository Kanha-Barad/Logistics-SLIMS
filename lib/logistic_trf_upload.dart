// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// //import 'package:image_picker/image_picker.dart';
//
// import 'globals.dart' as globals;
//
// String base64Image = "";
//
// class ImagePhotoPicker extends StatefulWidget {
//   const ImagePhotoPicker({Key? key}) : super(key: key);
//
//   @override
//   _ImagePhotoPickerState createState() => _ImagePhotoPickerState();
// }
//
// class _ImagePhotoPickerState extends State<ImagePhotoPicker> {
//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<File?> files = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context, true);
//             },
//             child: const Icon(Icons.arrow_back_ios,
//                 color: Colors.white, size: 18)),
//         backgroundColor: const Color(0xFF4CAF8E),
//         elevation: 0,
//         title: const Text('TRF Forms', style: TextStyle(color: Colors.white)),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 XFile? photo = await _picker.pickImage(
//                     source: ImageSource.camera,
//                     maxHeight: 480,
//                     maxWidth: 640,
//                     imageQuality: 100,
//                     preferredCameraDevice: CameraDevice.rear);
//
//                 if (photo == null) {
//                 } else {
//                   setState(() {
//                     file = File(photo.path);
//                     files.add(File(photo.path));
//                     // final bytes = File(photo.path).readAsBytesSync();
//                     // base64Image = base64Encode(bytes);
//                     // print("img_pan : $base64Image");
//                   });
//                 }
// // /data/user/0/com.example.logistics_app/cache/37c82b81-bb27-4511-823d-6abc2295bcbf6272293435664269267.jpg
//               },
//               icon: const Icon(Icons.camera_alt_outlined))
//         ],
//       ),
//       body: ListView.builder(
//           itemCount: files.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return files[index] == null
//                 ? const Text("No Image Selected")
//                 : Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
//                     child: Card(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             side: const BorderSide(
//                                 color: Color.fromARGB(255, 182, 245, 226))),
//                         clipBehavior: Clip.antiAlias,
//                         child: Stack(children: <Widget>[
//                           Image.file(
//                             files[index]!,
//                             fit: BoxFit.cover,
//                             height: 480,
//                           ),
//                         ])),
//                   );
//           }),
//       floatingActionButton: InkWell(
//         onTap: () {
//           for (var element in files) {
//             //  Uint8List? bytes = element.path
//             final bytes = File(element!.path).readAsBytesSync();
//             base64Image = base64Encode(bytes);
//             globals.TRFImgPath = base64Image + "," + globals.TRFImgPath;
//           }
//           Navigator.pop(context, true);
//         },
//         child: const SizedBox(
//             height: 40,
//             width: 80,
//             child: Card(
//                 color: Color(0xFF4CAF8E),
//                 child: Center(
//                     child: Text("Upload",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold))))),
//       ),
//     );
//   }
// }
