import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  final Future<Database> database;
  const HomeScreen({super.key, required this.database});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    refreshTaskList();
  }

  Future<void> insertTask(String title, String desc) async {
    final Database db = await widget.database;
    await db.insert(
      'tasks',
      {
        'title': title,
        'desc': desc,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } 

  Future<void> updateTask(int id, String title, String desc) async {
    final Database db = await widget.database;
    await db.update(  
      'tasks',
      {
        'title': title,
        'desc': desc,
      },
      where: 'id =?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final Database db = await widget.database;
    await db.delete( 
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> refreshTaskList() async {
    final Database db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    setState(() {
      _tasks = maps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Application")),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: "Task Description",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await insertTask(_titleController.text, _descController.text);
              _titleController.text = '';
              _descController.text = '';
              refreshTaskList();
            },
            child: Text("ajouter une tache"),
          ),
 
          Expanded(
              child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              TextEditingController _titleController1 = TextEditingController(text: task['title']);
                  
              TextEditingController _descControlle1 = TextEditingController(text: task['description']);
                  
              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['desc']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Editer le text"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _titleController1,
                                    decoration: InputDecoration(
                                      hintText: "Task Title",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: _descControlle1,
                                    decoration: InputDecoration(
                                      hintText: "Task Description",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),

                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await updateTask(
                                          task['id'],
                                          _titleController1.text,
                                          _descControlle1.text);
                                      Navigator.pop(context);
                                      refreshTaskList();
                                    },
                                    child: Text("Update")),
                              ],

                            ),
                          );
                        },
                        icon: Icon(Icons.edit)),
                    TextButton(
                      onPressed: () async {
                        await deleteTask(task['id']);
                        refreshTaskList();
                      },
                      child: Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          )
          )
        ],
      ),
    );
  }
}
