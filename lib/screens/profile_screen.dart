import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  bool isImageSelected = false;
  bool isLoading = false;
  bool isCamera = false;

  Future<void> getImage() async {
    isImageSelected = false;
    final ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: isCamera ?ImageSource.camera:ImageSource.gallery);
    if (xFile != null) {
      file = File(xFile.path);
      final directory = await getApplicationDocumentsDirectory();
      await file!.copy("${directory.path}/image.png");
      isImageSelected = true;
      setState(() {});
    }
  }

  Future<void> read() async {
    isLoading = false;
    setState(() {});
    final directory = await getApplicationDocumentsDirectory();
    await for (var event in directory.list()) {
      if (event.path.contains('image.png')) {
        isImageSelected = true;
      }
    }
    if(isImageSelected){
      file = File("${directory.path}/image.png");
      isLoading = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    read();
    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Column(
                children: [
                  MaterialButton(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                      minWidth: 200,
                      height: 200,
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context){
                            return Container(
                              height: 120,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    onPressed: ()async{
                                      isCamera = false;
                                      await getImage();
                                    },
                                    child: const Text("Gallery"),
                                  ),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    onPressed: ()async{
                                      isCamera = true;
                                      await getImage();
                                    },
                                    child: const Text("Camera"),
                                  )
                                ],
                              ),
                            );
                          }
                        );
                      },
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.transparent,
                        backgroundImage: profileImage(file: file),
                      ))
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

ImageProvider<Object>? profileImage({File? file}) {
  return file != null ? Image.file(file).image : const AssetImage("assets/images/img.png");
}
