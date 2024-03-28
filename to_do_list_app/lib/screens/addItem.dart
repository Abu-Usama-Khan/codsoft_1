import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/screens/home.dart';
import 'package:date_field/date_field.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String priority = 'High';
  String dueDate = DateTime.now().year.toString() +
      '-' +
      DateTime.now().month.toString() +
      '-' +
      DateTime.now().day.toString();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return SizedBox(
      height: height * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: height * 0.01,
                bottom: height * 0.01,
                right: width * 0.05,
                left: width * 0.05),
            child: Text('Add Item', style: TextStyle(fontSize: 20)),
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
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description (Optional)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: height * 0.03, right: width * 0.05, left: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Priority:'),
                Row(
                  children: [
                    Radio(
                      groupValue: priority,
                      value: 'High',
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text('High'),
                    SizedBox(
                      width: width * 0.07,
                    ),
                    Radio(
                      groupValue: priority,
                      value: 'Intermediate',
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text('Intermediate'),
                    SizedBox(
                      width: width * 0.07,
                    ),
                    Radio(
                      groupValue: priority,
                      value: 'Low',
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                    ),
                    Text('Low')
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: height * 0.03, right: width * 0.05, left: width * 0.05),
            child: DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Due Date',
              ),
              initialValue: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
              mode: DateTimeFieldPickerMode.date,
              autovalidateMode: AutovalidateMode.always,
              onDateSelected: (DateTime value) {
                dueDate = value.year.toString() +
                    '-' +
                    value.month.toString() +
                    '-' +
                    value.day.toString();
              },
            ),
          ),
          ElevatedButton(
              onPressed: titleController.text.toString().isNotEmpty
                  ? () async {
                      Map dataMap = {
                        'title': titleController.text.toString(),
                        'description': descriptionController.text.toString(),
                        'priority': priority,
                        'dueDate': dueDate,
                        'isCompleted': false
                      };
                      var pref = await SharedPreferences.getInstance();
                      String? tempStr = pref.getString('toDoString');
                      List tempList = [];
                      tempStr != null ? tempList = json.decode(tempStr) : null;
                      tempList.add(dataMap);
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
              child: Text('Add Task'))
        ],
      ),
    );
  }
}
