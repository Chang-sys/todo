import 'package:ToDo/screens/recycle_bin.dart';
import 'package:ToDo/screens/pending_tasks_screen.dart';
import 'package:ToDo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';

import '../blocs/bloc_export.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              color: Colors.grey,
              child: Text(
                'Task Drawer',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(TabsScreen.id),
                  child: ListTile(
                    leading: const Icon(Icons.folder_special),
                    title: const Text('My Task'),
                    trailing: Text(
                        '${state.pendingTasks.length} | ${state.completedTasks.length}'),
                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(RecycleBin.id),
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Bin'),
                    trailing: Text('${state.removedTasks.length}'),
                  ),
                );
              },
            ),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Text('Dark Mode'),
                    Switch(
                        value: state.switchValue,
                        onChanged: (newValue) {
                          newValue
                              ? context.read<SwitchBloc>().add(SwitchOnEvent())
                              : context
                                  .read<SwitchBloc>()
                                  .add(SwitchOffEvent());
                        }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
