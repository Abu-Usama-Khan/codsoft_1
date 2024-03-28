import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.priority,
      required this.dueDate,
      required this.isCompleted});
  final title;
  final description;
  final priority;
  final dueDate;
  final isCompleted;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late var size = MediaQuery.of(context).size;
  late var width = size.width;
  late var height = size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(187, 255, 239, 0.984),
          child: Center(
              child: Container(
                  margin: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.05),
                            child: Text(widget.title,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: height * 0.1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Priority',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Status',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Due Date',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.priority,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      widget.isCompleted
                                          ? 'Completed'
                                          : 'Active',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      widget.dueDate,
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                )
                              ])),
                      Padding(
                          padding: EdgeInsets.only(bottom: height * 0.02),
                          child: Text('Description',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      widget.description.toString().isNotEmpty
                          ? Text(widget.description,
                              style: TextStyle(fontSize: 18))
                          : Text('No Description',
                              style: TextStyle(fontSize: 18)),
                    ],
                  ))),
        ),
      ),
    );
  }
}
