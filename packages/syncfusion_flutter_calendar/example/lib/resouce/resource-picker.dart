import 'package:flutter/material.dart';

import 'main.dart';

class ResourcePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResourcePickerState();
  }
}

class _ResourcePickerState extends State<ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: nameCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(nameCollection[index]),
                onTap: () {
                  setState(() {
                    selectedResourceIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}
