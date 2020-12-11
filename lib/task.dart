import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job2go_devtest/model/projectmodel.dart';
import 'package:job2go_devtest/model/taskmodal.dart';

import 'model/api.dart';

class TaskPage extends StatefulWidget {
  final ProjectModel projectModel;
  TaskPage(this.projectModel);
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final listtask = List<TaskModel>();
  bool loading = false;

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    listtask.clear();
    var response =
        await CallApi().getData('tasks?project_id=${widget.projectModel.id}');
    final data = jsonDecode(response.body);
    //print(data);
    if (data != null) {
      data.forEach((api) {
        final ab = TaskModel(
          api['id'],
          api['content'],
          api['due']['date'],
        );
        listtask.add(ab);
      });
    }
    setState(() {
      loading = false;
    });
    print(listtask.length);
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listtask.length,
              itemBuilder: (context, i) {
                final x = listtask[i];
                return ListTile(
                  title: Text(x.content),
                  subtitle: Text("due ${x.due}"),
                  trailing: Container(child: Icon(Icons.edit)),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TaskPage(x),
                    //   ),
                    // );
                  },
                );
              },
            ),
    );
  }
}
