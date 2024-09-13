import 'package:flutter/material.dart';

import '../blocs/bloc_export.dart';
import '../widgets/tasks_list.dart';
import 'my_drawer.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});

  static const id = 'recycle_bin_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Recycle Bin',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              // IconButton(
              //   onPressed: () => {},
              //   icon: const Icon(Icons.add),
              // )
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.delete_forever),
                            label: const Text('Delete all Tasks'),
                          ),
                          onTap: () =>
                              context.read<TasksBloc>().add(DeleteAllTask()),
                        )
                      ])
            ],
            backgroundColor: Colors.blue,
          ),
          drawer: const MyDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    '${state.removedTasks.length} Tasks',
                  ),
                ),
              ),
              TasksList(tasksList: state.removedTasks)
            ],
          ),
        );
      },
    );
  }
}
