import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../functions/custom_dialog.dart';
import '../functions/custom_main_builder.dart';

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
  initState() {
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
  dispose() {
    fileNameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<String> getLocation() async {
    directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<void> createFile({required String fileName, required String text}) async {
    final path = await getLocation();
    file = File("$path/$fileName-${DateTime.now().toIso8601String().substring(0, 12)}.txt");
    await file.writeAsString(text);
    fileNameController.clear();
    bodyController.clear();
    await getAllFiles();
    setState(() {});
  }

  Future<void> getAllFiles() async {
    list = [];
    isLoading = false;
    setState(() {});
    await getLocation();
    Stream<FileSystemEntity> files = directory.list();
    files.listen((event) {
      if (event.path.endsWith('.txt')) {
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
            onChanged: (_) {
              isAndroid = !isAndroid;
              setState(() {});
            },
          ),
          const SizedBox(
            width: 10,
          ),
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
                        onPressed: () async {
                          isCache = true;
                          isData = false;
                          directory = await getTemporaryDirectory();
                          setState(() {});
                        },
                        color: isCache ? Colors.blue : Colors.grey,
                        child: const Text("Cache"),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          isCache = false;
                          isData = true;
                          directory = await getApplicationDocumentsDirectory();
                          setState(() {});
                        },
                        color: isData ? Colors.blue : Colors.grey,
                        child: const Text("Data"),
                      ),
                    ],
                  ),
                ),
                customMainBuilder(
                  isLoading: isLoading,
                  list: list,
                )
              ],
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return customDialog(
                context: context,
                isPlatform: isAndroid,
                fileNameController: fileNameController,
                bodyController: bodyController,
                onCancelPressed: () {
                  Navigator.pop(context);
                },
                onCreatePressed: () async {
                  await createFile(fileName: fileNameController.text.trim().toLowerCase(), text: bodyController.text);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
