import 'package:ToDo/screens/completed_tasks_screen.dart';
import 'package:ToDo/screens/favorite_tasks_screen.dart';
import 'package:ToDo/screens/my_drawer.dart';
import 'package:ToDo/screens/pending_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen({Key? key}) : super(key: key);
  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const PendingTasksScreen(), 'title': 'Pending Tasks'},
    {'pageName': const CompletedTasksScreen(), 'title': 'Completed Tasks'},
    {'pageName': const FavoriteTasksScreen(), 'title': 'Favorite Tasks'},
  ];

  var _seletedPageIndex = 0;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const AddTaskScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageDetails[_seletedPageIndex]['title'],
          key: Key('appBarTitle'), // Add a key to the AppBar title
        ),
        actions: [
          IconButton(
            onPressed: () => _addTask(context),
            icon: const Icon(Icons.add),
            key: Key('addTaskIcon'), // Add a key to the IconButton
          )
        ],
      ),
      drawer: const MyDrawer(), 
      body: _pageDetails[_seletedPageIndex]['pageName'],
      floatingActionButton: _seletedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
              key: Key('floatingActionButton'), // Add a key to the FloatingActionButton
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seletedPageIndex,
        onTap: (index) {
          setState(() {
            _seletedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_sharp),
            label: 'Pending Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Complete Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite Tasks',
          ),
        ],
      ),
    );
  }
}
