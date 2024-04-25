import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customDialog(
    {required bool isPlatform,
    required void Function()? onCancelPressed,
    required void Function()? onCreatePressed,
    required BuildContext context,
    required TextEditingController fileNameController,
    required TextEditingController bodyController}) {
  return isPlatform
      ? AlertDialog(
          title: const Text("Create a file"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(hintText: "File name"),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(hintText: "Text"),
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
      : CupertinoAlertDialog(
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
                  decoration: const InputDecoration(hintText: "File name"),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(hintText: "Text"),
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
