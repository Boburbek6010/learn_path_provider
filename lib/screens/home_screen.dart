import 'dart:developer';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learn_path_provider/main.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Directory directory;
  late File file;
  late TextEditingController fileNameController;
  late TextEditingController bodyController;
  late List<String> list;
  late bool isAndroid;
  late bool isLoading;
  late bool isCache;
  late bool isData;

  @override
  initState(){
    fileNameController = TextEditingController();
    bodyController = TextEditingController();
    list = [];
    isAndroid = false;
    isLoading = false;
    isCache = true;
    isData = false;
    getAllFiles();
    super.initState();
  }


  @override
  dispose(){
    fileNameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<String> getLocation()async{
    directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<void> createFile({required String fileName, required String text})async{
    final path = await getLocation();
    file = File("$path/$fileName-${DateTime.now().toIso8601String()}.txt");
    await file.writeAsString(text);
    fileNameController.clear();
    bodyController.clear();
    await getAllFiles();
    setState(() {});
  }


  Future<void> getAllFiles()async{
    list = [];
    isLoading = false;
    setState(() {});
    await getLocation();
    Stream<FileSystemEntity> files = directory.list();
    files.listen((event) {
      if(event.path.endsWith('.txt')){
        list.add(event.path);
      }
    });
    isLoading = true;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Path Provider"),
        centerTitle: true,
        actions: [
          Switch(
            value: isAndroid,
            onChanged: (_){
              isAndroid = !isAndroid;
              setState(() {});
            },
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: ()async{
                        isCache = true;
                        isData = false;
                        directory = await getTemporaryDirectory();
                        setState(() {});
                      },
                      color: isCache ?Colors.blue:Colors.grey,
                      child: const Text("Cache"),
                    ),
                    const SizedBox(width: 30,),
                    MaterialButton(
                      onPressed: ()async{
                        isCache = false;
                        isData = true;
                        directory = await getApplicationDocumentsDirectory();
                        setState(() {});
                      },
                      color: isData ?Colors.blue:Colors.grey,
                      child: const Text("Data"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading ?ListView.builder(
                  itemBuilder: (_, index){
                    return Card(
                      child: ListTile(
                        title: Text(list[index]),
                      ),
                    );
                  },
                  itemCount: list.length,
                ):const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          showDialog(
            context: context,
            builder: (context){
              return customDialog(
                context: context,
                isPlatform: isAndroid,
                fileNameController: fileNameController,
                bodyController: bodyController,
                onCancelPressed: (){
                  Navigator.pop(context);
                },
                onCreatePressed: ()async{

                  await createFile(fileName: fileNameController.text.trim().toLowerCase(), text: bodyController.text);

                  Navigator.pop(context);
                }
              );
            }
          );
        },
      ),
    );
  }
}

Widget customDialog({required bool isPlatform, required void Function()? onCancelPressed, required void Function()? onCreatePressed, required BuildContext context, required TextEditingController fileNameController, required TextEditingController bodyController}){
  return isPlatform
      ?AlertDialog(
    title: const Text("Create a file"),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: fileNameController,
          decoration: const InputDecoration(
              hintText: "File name"
          ),
        ),
        TextField(
          controller: bodyController,
          decoration: const InputDecoration(
              hintText: "Text"
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: onCancelPressed,
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: onCreatePressed,
        child: const Text("Create"),
      )
    ],
  )
      :CupertinoAlertDialog(
          title: const Text("Create a file"),
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
            controller: fileNameController,
            decoration: const InputDecoration(
                hintText: "File name"
            ),
                    ),
                    TextField(
            controller: bodyController,
            decoration: const InputDecoration(
                hintText: "Text"
            ),
                    ),
                  ],
            ),
          ),
          actions: [
      CupertinoDialogAction(
        onPressed: onCancelPressed,
        child: const Text("Cancel"),
      ),
      CupertinoDialogAction(
        onPressed: onCreatePressed,
        child: const Text("Create"),
      )
          ],
        );
}
