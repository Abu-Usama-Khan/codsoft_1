import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/screens/home.dart';

class EditItem extends StatefulWidget {
  const EditItem(
      {super.key, required this.index, required this.title, this.description});
  final index;
  final title;
  final description;

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController titleController =
      TextEditingController(text: widget.title);
  late TextEditingController descriptionController =
      TextEditingController(text: widget.description);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return SizedBox(
      height: height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: height * 0.01,
                bottom: height * 0.01,
                right: width * 0.05,
                left: width * 0.05),
            child: Text('Edit Item', style: TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: height * 0.03, right: width * 0.05, left: width * 0.05),
            child: TextFormField(
              controller: titleController,
              onChanged: (value) => setState(() {
                titleController;
              }),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) =>
                  value!.isEmpty ? 'Please Enter Title' : null,
              decoration: InputDecoration(hintText: 'Title'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: height * 0.05, right: width * 0.05, left: width * 0.05),
            child: TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              onChanged: (value) => setState(() {
                descriptionController;
              }),
              decoration: InputDecoration(hintText: 'Description (Optional)'),
            ),
          ),
          ElevatedButton(
              onPressed: titleController.text.toString().isNotEmpty &&
                      (titleController.text.toString() != widget.title ||
                          descriptionController.text.toString() !=
                              widget.description)
                  ? () async {
                      var pref = await SharedPreferences.getInstance();
                      String tempStr = pref.getString('toDoString')!;
                      List tempList = [];
                      tempList = json.decode(tempStr);
                      tempList[widget.index]['title'] =
                          titleController.text.toString();
                      tempList[widget.index]['description'] =
                          descriptionController.text.toString();
                      String sendStr = json.encode(tempList);
                      pref.setString('toDoString', sendStr);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(title: 'To Do List App'),
                          ));
                    }
                  : null,
              child: Text('Edit Task'))
        ],
      ),
    );
  }
}
