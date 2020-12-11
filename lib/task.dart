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
  TextEditingController contentDesc = TextEditingController();

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
          //api['due']['date'],
        );
        listtask.add(ab);
      });
    }
    setState(() {
      loading = false;
    });
    print(listtask.length);
  }

  Future<void> _updateData(BuildContext context, id) async {
    var data = {
      'content': contentDesc.text,
    };
    var response = await CallApi().postData(data, 'tasks/$id');
    Navigator.pop(context);
    _readData();
  }

  Future<void> _saveData(BuildContext context) async {
    var data = {
      'content': contentDesc.text,
      'project_id': widget.projectModel.id
    };
    var response = await CallApi().postData(data, 'tasks');
    Navigator.pop(context);
    _readData();
  }

  dialogUpdate(BuildContext context, TaskModel x) {
    contentDesc.text = x.content;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    controller: contentDesc,
                    autofocus: false,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(13.0),
                      labelText: "Content",
                      labelStyle: TextStyle(fontSize: 13.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    onPressed: () {
                      _updateData(context, x.id);
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Container(
                      height: 40.0,
                      child: Center(
                        child: Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  dialogCreate(BuildContext context) {
    contentDesc.text = "";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    controller: contentDesc,
                    autofocus: false,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(13.0),
                      labelText: "Content",
                      labelStyle: TextStyle(fontSize: 13.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    onPressed: () {
                      _saveData(context);
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Container(
                      height: 45.0,
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
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
                  //subtitle: Text("due ${x.due}"),
                  trailing: Container(child: Icon(Icons.edit)),
                  onTap: () {
                    dialogUpdate(context, x);
                  },
                );
              },
            ),
      floatingActionButton: Container(
        width: 53.0,
        height: 53.0,
        child: FloatingActionButton(
          onPressed: () {
            dialogCreate(context);
          },
          backgroundColor: Colors.blue,
          tooltip: 'Add',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
