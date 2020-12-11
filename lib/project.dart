import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job2go_devtest/model/projectmodel.dart';
import 'package:job2go_devtest/task.dart';

import 'model/api.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final listproject = List<ProjectModel>();
  bool loading = false;

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    listproject.clear();
    var response = await CallApi().getData('projects');
    final data = jsonDecode(response.body);
    //print(data);
    if (data != null) {
      data.forEach((api) {
        final ab = ProjectModel(
          api['id'],
          api['name'],
          api['comment_count'],
        );
        listproject.add(ab);
      });
    }
    setState(() {
      loading = false;
    });
    print(listproject.length);
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
          "Projects",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listproject.length,
              itemBuilder: (context, i) {
                final x = listproject[i];
                return ListTile(
                  title: Text(x.name),
                  subtitle: Text("comment ${x.commentaccount}"),
                  trailing: Container(child: Icon(Icons.add)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(x),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
