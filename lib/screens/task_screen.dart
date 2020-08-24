import 'package:diy_task_tracking/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskBottomSheet()),
            isScrollControlled: true,
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TodoHeader(),
          TodoBody(),
        ],
      ),
    );
  }
}

class TodoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return Container(
          padding: EdgeInsets.only(
            left: 30,
            top: 60,
            right: 30,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  Icons.list,
                  size: 30,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Todoo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "${taskData.taskCount} tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TodoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Provider.of<TaskData>(context).tasks.isNotEmpty
            ? TaskList()
            : Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Let's add your tasks and get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, height: 2),
                  ),
                ),
              ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (BuildContext context, taskData, Widget child) {
        return ListView.builder(
          itemCount: taskData.taskCount,
          itemBuilder: (context, index) {
            final taskItem = taskData.tasks[index];
            return TaskItem(
              isChecked: taskItem.isDone,
              taskTitle: taskItem.name,
              toggled: (value) {
                taskData.updateTask(taskItem);
              },
              onLongPressed: () {
                _showAlertDialog(
                  context,
                  () {
                    taskData.deleteTask(taskItem);
                    Navigator.of(context).pop();
                  },
                  () => Navigator.of(context).pop(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function toggled;
  final Function onLongPressed;

  TaskItem({
    @required this.isChecked,
    @required this.taskTitle,
    @required this.toggled,
    @required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: toggled,
      ),
      onLongPress: onLongPressed,
    );
  }
}

class AddTaskBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title;
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Add Task",
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 1,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                title = value;
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
              height: 50,
              child: Text(
                "ADD",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Provider.of<TaskData>(context, listen: false).addTask(title);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

_showAlertDialog(BuildContext context, Function onDelete, Function onCancel) {
  // set up the button
  Widget deleteButton = FlatButton(
    child: Text(
      "Delete",
      style: TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: onDelete,
  );

  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
      style: TextStyle(
        color: Colors.lightBlueAccent,
        fontWeight: FontWeight.w700,
      ),
    ),
    onPressed: onCancel,
  );

  // set up the AlertDialog
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text(
      "Warning",
      style: TextStyle(fontSize: 22),
    ),
    content: SizedBox(
      height: 100,
      width: 200,
      child: Center(
        child: Text(
          "Do you want to delete this task?",
          style: TextStyle(fontSize: 18),
        ),
      ),
    ),
    actions: [
      cancelButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
