import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  runApp(const MyApp());
  await getdatabase();
}

var database;
List tasksList = [];
Future getdatabase() async {
  database = openDatabase(
    join(await getDatabasesPath(), "todolist3.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE tasks(
        taskID INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT
      )''');
    
    },
  );
  getTaskList();
}

Future<void> insertData(ModelData md) async {
  final localDB = await database;
  await localDB.insert(
    'tasks',
    md.getMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print("data added successfully");
  await getTaskList();
}

Future<void> editData(ModelData md, int taskID) async {
  final localDB = await database;
  await localDB.update(
    'tasks',
    md.getMap(),
    where: 'taskID=?',
    whereArgs: [taskID],
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print("data edited successfully");
  await getTaskList();
}

Future<void> getTaskList() async {
  final localDB = await database;
  tasksList = await localDB.query("tasks");
  print(tasksList);
}

Future<void> deleteTasks(int taskID) async {
  final localDB = await database;
  await localDB.delete('tasks', where: 'taskID=?', whereArgs: [taskID]);
  getTaskList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdvaceTO(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ModelData {
  String title;
  String description;
  String date;

  ModelData(
      {required this.title, required this.description, required this.date});

  Map<String, dynamic> getMap() {
    return {'title': title, 'description': description, 'date': date};
  }
}

class AdvaceTO extends StatefulWidget {
  const AdvaceTO({super.key});
  State createState() {
    return _AdvanceToDoState();
  }
}

class _AdvanceToDoState extends State {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  final GlobalKey _textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  "Good morning",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Srushti",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              child: Expanded(
                child: Container(
                    height: 725,
                    width: 500,
                    padding: const EdgeInsets.only(top: 25),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Color.fromRGBO(212, 211, 211, 0.986)),
                    child: Column(
                      children: [
                        const Text("CREATE TO DO LIST"),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            width: 540,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40)),
                                color: Color.fromRGBO(255, 255, 255, 1)),
                            child: ListView.builder(
                                itemCount: tasksList.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                      closeOnScroll: true,
                                      endActionPane: ActionPane(
                                          extentRatio: 0.2,
                                          motion: const DrawerMotion(),
                                          children: [
                                            Container(
                                              child: Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      getshett(context, true,
                                                          tasksID:
                                                              tasksList[index]
                                                                  ['taskID']);
                                                      _titlecontroller.text =
                                                          tasksList[index]
                                                              ['title'];
                                                      _descriptioncontroller
                                                              .text =
                                                          tasksList[index]
                                                              ['description'];
                                                      _datecontroller.text =
                                                          tasksList[index]
                                                              ['date'];
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            89, 57, 241, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await deleteTasks(
                                                          tasksList[index]
                                                              ['taskID']);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            89, 57, 241, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  )
                                                ],
                                              )),
                                            )
                                          ]),
                                      key: ValueKey(index),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 380,
                                            height: 150,
                                            margin: const EdgeInsets.all(18),
                                            padding: const EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                //color: cardColorList[index % cardColorList.length],
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.1),
                                                    offset: Offset(5, 5),
                                                    spreadRadius: 5,
                                                    blurRadius: 5,
                                                  )
                                                ]),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: Image.asset(
                                                            "assets/images/Group.png"),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 220,
                                                        child: SizedBox(
                                                            child: SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                              tasksList[index]
                                                                  ["title"],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              )),
                                                        )),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 220,
                                                            child: SizedBox(
                                                              child: Text(
                                                                tasksList[index]
                                                                    [
                                                                    'description'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Checkbox(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            activeColor:
                                                                Colors.green,
                                                            value: true,
                                                            onChanged: (val) {},
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ]),
                                          ),
                                        ],
                                      ));
                                }),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getshett(context, false);
        },
        backgroundColor: const Color.fromRGBO(89, 57, 249, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void getshett(BuildContext context, bool todoedit, {int? tasksID}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _textKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Create To Do",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Title",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(111, 81, 255, 1),
                        )),
                    TextFormField(
                      validator: (value) {
                        if (_titlecontroller.text.isEmpty) {
                          return "Please enter title";
                        } else {
                          return null;
                        }
                      },
                      controller: _titlecontroller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(111, 81, 255, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      cursorColor: const Color.fromRGBO(111, 81, 255, 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(111, 81, 255, 1),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_descriptioncontroller.text.isEmpty) {
                          return "Please enter Description";
                        } else {
                          return null;
                        }
                      },
                      controller: _descriptioncontroller,
                      decoration: const InputDecoration(
                        //hintText:
                        //"Simply dummy text of the printing and  has been the typesetting Lorem Ipsum has been the industry./n",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(111, 81, 255, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      cursorColor: const Color.fromRGBO(111, 81, 255, 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(111, 81, 255, 1),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_datecontroller.text.isEmpty) {
                          return "Please select date";
                        } else {
                          return null;
                        }
                      },
                      controller: _datecontroller,
                      decoration: const InputDecoration(
                        //hintText: "10 july 2023.",
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(111, 81, 255, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      cursorColor: const Color.fromRGBO(111, 81, 255, 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                const Color.fromRGBO(111, 81, 255, 1),
                            fixedSize: const Size(350, 50),
                          ),
                          onPressed: () async {
                            String title = _titlecontroller.text.trim();
                            String description =
                                _descriptioncontroller.text.trim();
                            String date = _datecontroller.text.trim();

                            ModelData md = ModelData(
                                title: title,
                                description: description,
                                date: date);
                            if (/*_textKey.currentState.validator()*/ true) {
                              if (!todoedit) {
                                await insertData(md);
                              } else {
                                await editData(md, tasksID!);
                              }
                            }
                            Navigator.of(context).pop();

                            _titlecontroller.clear();

                            _descriptioncontroller.clear();
                            _datecontroller.clear();
                            setState(() {});
                          },
                          child: const Text(
                            "submit",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ));
        });
  }
}
