import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageConverterScreen extends StatefulWidget {
  const ImageConverterScreen({Key? key}) : super(key: key);

  @override
  State<ImageConverterScreen> createState() => _ImageConverterScreenState();
}

class _ImageConverterScreenState extends State<ImageConverterScreen> {
  XFile? image;

  String? baseCode = "";
  bool isConvertBtnClick = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Image Convert'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker0 = ImagePicker();
                  final img = await picker0.pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = img;
                  });
                },
                label: const Text('Choose Image'),
                icon: const Icon(Icons.image),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  image = null;
                  baseCode = "";
                  final ImagePicker picker = ImagePicker();
                  final img = await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    image = img;
                  });
                },
                label: const Text('Take Photo'),
                icon: const Icon(Icons.camera_alt_outlined),
              ),
            ],
          ),
          if (image != null)
            Expanded(
              child: Column(
                children: [
                  SizedBox(width: 200, height: 200, child: Image.file(File(image!.path))),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        image = null;
                        baseCode = "";
                        isConvertBtnClick = false;
                      });
                    },
                    label: const Text('Remove Image'),
                    icon: const Icon(Icons.close),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          File imagefile = File(image!.path);
                          Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
                          String base64string = base64.encode(imagebytes); //convert bytes to base64 string
                          setState(() {
                            baseCode = base64string;
                          });
                        },
                        child: const Text('Convert Base64'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isConvertBtnClick = true;
                          });
                        },
                        child: const Text('Convert Image'),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.white70, border: Border.all(width: 1, color: Colors.blue)),
                    child: Text(baseCode!),
                  ),
                  if (isConvertBtnClick == true)
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(color: Colors.white70, border: Border.all(width: 1, color: Colors.blue)),
                      child: Image.memory(base64Decode(baseCode!)),
                    )
                ],
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
