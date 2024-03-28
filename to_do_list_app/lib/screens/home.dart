import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/screens/addItem.dart';
import 'package:to_do_list_app/screens/editItem.dart';
import 'package:to_do_list_app/screens/detailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final title;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? toDo;

  bool isChecked = false;
  bool selected = true;

  void alertBox(ind) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: TextStyle(
                          color: Colors.black54,
                        ))),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteItem(ind);
                  },
                  child: Text('Delete',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                )
              ],
              title: Text('Delete Task',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              content: Text('Are you sure?',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              buttonPadding: EdgeInsets.only(top: 20),
              backgroundColor: Colors.teal,
            ));
  }

  void addItem() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return AddItem();
        });
  }

  void editItem(ind, ttl, des) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return EditItem(index: ind, title: ttl, description: des);
        });
  }

  void deleteItem(ind) async {
    setState(() {
      toDo!.removeAt(ind);
    });
    var pref = await SharedPreferences.getInstance();
    String sendStr = json.encode(toDo);
    pref.setString('toDoString', sendStr);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(title: 'To Do List App'),
        ));
  }

  void changeStatus(ind, val) async {
    setState(() {
      toDo![ind]['isCompleted'] = val;
    });
    var pref = await SharedPreferences.getInstance();
    String sendStr = json.encode(toDo);
    pref.setString('toDoString', sendStr);
  }

  Color _tileColor(ind) {
    if (toDo![ind]['priority'] == 'High') {
      return const Color.fromRGBO(244, 67, 54, 0.75);
    } else if (toDo![ind]['priority'] == 'Intermediate') {
      return const Color.fromRGBO(255, 235, 59, 0.75);
    } else {
      return Colors.white;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inItExtended();
  }

  inItExtended() async {
    var pref = await SharedPreferences.getInstance();
    String? str = pref.getString('toDoString')!;
    List? lst = json.decode(str);
    setState(() {
      toDo = lst;
      selected
          ? toDo!.sort((a, b) {
              var r = a['priority'].compareTo(b['priority']);
              return r;
            })
          : toDo!.sort((a, b) {
              var r = a['dueDate'].toString().compareTo(b['dueDate']);
              return r;
            });
    });
    str = json.encode(toDo);
    pref.setString('toDoString', str);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () => addItem(),
                icon: Icon(Icons.add),
                iconSize: width * 0.075,
                color: Colors.black),
          ],
        ),
        backgroundColor: const Color.fromRGBO(187, 255, 239, 0.984),
        body: SafeArea(
            child: Center(
                child: SizedBox(
                    width: width * 0.9,
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.02, bottom: height * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    selected = true;
                                    inItExtended();
                                  },
                                  child: Text(
                                    'Sort by Priority',
                                    style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.teal),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: selected
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.teal)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.white))),
                              ElevatedButton(
                                  onPressed: () {
                                    selected = false;
                                    inItExtended();
                                  },
                                  child: Text(
                                    'Sort by Due Date',
                                    style: TextStyle(
                                        color: !selected
                                            ? Colors.white
                                            : Colors.teal),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: !selected
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.teal)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.white)))
                            ],
                          )),
                      toDo == null || toDo!.isEmpty
                          ? Center(child: Text('No Activity to show'))
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: toDo!.length,
                                  itemBuilder: (context, index) => Card(
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(
                                                          title: toDo![index]
                                                              ['title'],
                                                          description: toDo![
                                                                  index]
                                                              ['description'],
                                                          priority: toDo![index]
                                                                  ['priority']
                                                              .toString(),
                                                          dueDate: toDo![index]
                                                              ['dueDate'],
                                                          isCompleted: toDo![
                                                                  index]
                                                              ['isCompleted']))),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            tileColor: _tileColor(index),
                                            leading: Checkbox(
                                                value: toDo![index]
                                                    ['isCompleted'],
                                                onChanged: (newValue) {
                                                  changeStatus(index, newValue);
                                                }),
                                            title: Text(
                                              toDo![index]['title'],
                                              style: TextStyle(
                                                  decoration: toDo![index]
                                                          ['isCompleted']
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null),
                                            ),
                                            subtitle: toDo![index]
                                                    ['isCompleted']
                                                ? Text('Status: Completed')
                                                : Text('Status: Active'),
                                            trailing: PopupMenuButton(
                                                color: const Color.fromRGBO(
                                                    187, 255, 239, 0.984),
                                                itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    editItem(
                                                                        index,
                                                                        toDo![index]
                                                                            [
                                                                            'title'],
                                                                        toDo![index]
                                                                            [
                                                                            'description']);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons
                                                                          .edit),
                                                                      Text(
                                                                          ' Edit')
                                                                    ],
                                                                  ))),
                                                      PopupMenuItem(
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    alertBox(
                                                                        index);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons
                                                                          .delete),
                                                                      Text(
                                                                          ' Delete')
                                                                    ],
                                                                  )))
                                                    ],
                                                child: Icon(Icons.more_horiz)),
                                          ),
                                        ),
                                      )),
                            )
                    ])))));
  }
}
