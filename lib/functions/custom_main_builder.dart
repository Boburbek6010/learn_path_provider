import 'package:flutter/material.dart';

Widget customMainBuilder({required bool isLoading, required List<String> list}) {
  return Expanded(
    child: isLoading
        ? ListView.builder(
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(list[index]),
                ),
              );
            },
            itemCount: list.length,
          )
        : const Center(
            child: CircularProgressIndicator(),
          ),
  );
}
