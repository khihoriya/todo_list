import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: todotask(),));
}

class Task {
  String description;
  bool completed;

  Task({required this.description, this.completed = false});

  Task.fromMap(Map map)        // This Function helps to convert our Map into our User Object
      : this.description = map["description"],
        this.completed = map["completed"];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'completed': completed,
    };
  }
}

class todotask extends StatefulWidget {
  const todotask({super.key});

  @override
  State<todotask> createState() => _todotaskState();
}

class _todotaskState extends State<todotask> {
  TextEditingController taskinput = TextEditingController();
  List<Task> tasks = [];

  String replacementValue = '';
  List<String>? tasklist;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initasks();


  }

  initasks()  async {
    prefs =  await SharedPreferences.getInstance() as SharedPreferences?;
    List<String>? listString =  prefs!.getStringList('tasks');
    List<Task> data = listString!.map((item) => Task.fromMap(json.decode(item))).toList();
    setState(()  {
      tasks = data;
      print("=======liststring${tasks[0].description}");
    });

  }

  Future<List<Task>?> loadData() async {

    List<String>? listString = prefs!.getStringList('tasks');
    print("===liststring${listString}");
    tasks = listString!.map((item) => Task.fromMap(json.decode(item))).toList();
    print("=======liststring${tasks}");
    //This command gets us the list stored with key name "list"
  }

  savetasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tasklist = tasks.map((item) => jsonEncode(item.toMap())).toList();

    prefs.setStringList("tasks",tasklist!);
    print("===${tasklist}");


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'To-do List App',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: taskinput,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter Your tasks..',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      taskinput.clear();
                                    });
                                  },
                                  icon: Icon(Icons.cancel_sharp))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return AnimationLimiter(
                    key:ValueKey("${tasks.length}"),
                    child: AnimationConfiguration.staggeredList(
                    position: index,
                      child: ScaleAnimation(
                        duration: Duration(seconds: 1),
                        delay: Duration(seconds: 1),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF90C8AC),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            width: double.infinity,
                            height: 120,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: tasks[index].completed,
                                      checkColor: Colors.white,
                                      activeColor: Colors.black,
                                      onChanged: (value) {
                        
                                        setState(() {
                                          tasks[index].completed = value!;
                                          savetasks();
                                        });
                        
                                        if(value == true)
                                          {
                                            print("==value{$value}");
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Task completed",
                                                  style: TextStyle(
                                                      color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                                backgroundColor: Colors.teal,
                                              ),
                        
                        
                                            );
                        
                        
                                            setState(() {
                                              tasks[index].completed = true;
                                              savetasks();
                                            });
                                          }
                                        else
                                          {
                                            print("==value{$value}");
                                            setState(() {
                                              tasks[index].completed = false;
                                            });
                                          }
                        
                                      },
                                    ),
                                    Center(
                                        child: Text(
                                          tasks[index].description,
                                          style: TextStyle(
                                              color: Colors.black,
                        
                                              fontSize: 20),
                                        )),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       edittask(index);
                                    //     },
                                    //     icon: Icon(Icons.edit))
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Container(

                                        child: NiceButtons(


                                          startColor: Color(0xFF0A4D68),
                                          endColor: Color(0xFF90C8AC),
                                          stretch: true,
                                          gradientOrientation:
                                          GradientOrientation.Vertical,
                                          onTap: (finish) {
                                            edittask(index);
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: Container(
                        
                                        child: NiceButtons(
                                          startColor: Color(0xFF0A4D68),
                                          endColor: Color(0xFF90C8AC),
                                          stretch: true,
                                          gradientOrientation:
                                          GradientOrientation.Vertical,
                                          onTap: (finish) {
                                            AwesomeDialog(
                                              btnOkText: "Confirm",
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.rightSlide,
                                              title: 'Delete Task',
                                              desc: 'Are you Sure to delete this task..',
                                              btnOkOnPress: () {
                                                setState(() {
                                                  tasks.removeAt(index);
                                                  savetasks();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Task deleted",
                                                        style: TextStyle(
                                                            color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                      backgroundColor: Colors.teal,
                                                    ),
                                                  );
                                                });
                                              },
                                            )..show();
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: SwipeButton.expand(
                thumb: Icon(
                  Icons.double_arrow_rounded,
                  color: Colors.white,
                ),
                child: Text(
                  "Swipe to Add task..",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                activeThumbColor: Color(0xFF0A4D68),
                activeTrackColor: Colors.grey.shade300,
                onSwipe: () {
                  if (taskinput.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Enter Task",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  } else {
                    setState(() {
                      tasks.add(Task(description: taskinput.text, completed: false));
                      taskinput.clear();
                      savetasks();
                      replacementValue = ''; // Reset replacementValue
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Task added successfully",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void edittask(int index) {
    TextEditingController edittext = TextEditingController(text: tasks[index].description);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            onChanged: (value) {
              setState(() {
                replacementValue = value;
              });
            },
            controller: edittext,
            decoration: InputDecoration(hintText: 'Type something...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[index].description = edittext.text;
                  edittext.clear();
                  replacementValue = '';
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
