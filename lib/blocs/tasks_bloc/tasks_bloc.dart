import 'package:equatable/equatable.dart';

import '../../models/task.dart';
import '../bloc_export.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTask>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  // void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   final task = event.task;

  //   List<Task> pendingTasks = state.pendingTasks;
  //   List<Task> completedTasks = state.completedTasks;

  //   task.isDone == false
  //       ? {
  //           pendingTasks = List.from(pendingTasks)..remove(task),
  //           completedTasks = List.from(completedTasks)
  //             ..insert(0, task.copyWith(isDone: true)),
  //         }
  //       : {
  //           completedTasks = List.from(completedTasks)..remove(task),
  //           pendingTasks = List.from(pendingTasks)
  //             ..insert(0, task.copyWith(isDone: false)),
  //         };
  //   emit(TasksState(
  //       pendingTasks: pendingTasks,
  //       completedTasks: completedTasks,
  //       favoriteTasks: state.favoriteTasks,
  //       removedTasks: state.removedTasks));
  // }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    // Create modifiable copies of the lists
    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);
    List<Task> favoriteTasks = List.from(state.favoriteTasks);

    if (task.isDone == false) {
      if (task.isFavorite == false) {
        pendingTasks.remove(task);
        completedTasks.insert(0, task.copyWith(isDone: true));
      } else {
        var taskIndex = favoriteTasks.indexOf(task);
        pendingTasks.remove(task);
        completedTasks.insert(0, task.copyWith(isDone: true));
        favoriteTasks
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: true));
      }
    } else {
      if (task.isFavorite == false) {
        completedTasks.remove(task);
        pendingTasks.insert(0, task.copyWith(isDone: false));
      } else {
        var taskIndex = favoriteTasks.indexOf(task);
        completedTasks.remove(task);
        pendingTasks.insert(0, task.copyWith(isDone: false));
        favoriteTasks
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: false));
      }
    }

    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    // List<Task> pendingTasks = List.from(state.pendingTasks)..remove(event.task);
    // emit(TasksState(pendingTasks: pendingTasks));
    emit(TasksState(
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: List.from(state.removedTasks)..remove(event.task),
    ));
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..remove(event.task),
      completedTasks: List.from(state.completedTasks)..remove(event.task),
      favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
      removedTasks: List.from(state.removedTasks)
        ..add(event.task.copyWith(isDeleted: true)),
    ));
  }

  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) {
    final state = this.state;

    // Create modifiable copies of the lists
    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);
    List<Task> favoriteTasks = List.from(state.favoriteTasks);

    if (event.task.isDone == false) {
      if (event.task.isFavorite == false) {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.removeWhere((task) => task.id == event.task.id);
      }
    } else {
      if (event.task.isFavorite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.removeWhere((task) => task.id == event.task.id);
      }
    }
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state;

    // Create modifiable copies of the lists
    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);
    List<Task> favoriteTasks = List.from(state.favoriteTasks);
    List<Task> removedTasks = List.from(state.removedTasks);

    // Update favorite tasks if the old task was a favorite
    if (event.oldTask.isFavorite == true) {
      favoriteTasks
        ..remove(event.oldTask)
        ..insert(0, event.newTask);
    }

    // Update pending tasks
    pendingTasks
      ..remove(event.oldTask)
      ..insert(0, event.newTask);

    // Update completed tasks
    completedTasks.remove(event.oldTask);

    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks,
    ));
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      removedTasks: List.from(state.removedTasks)..remove(event.task),
      pendingTasks: List.from(state.pendingTasks)
        ..insert(
            0,
            event.task.copyWith(
              isDeleted: false,
              isDone: false,
              isFavorite: false,
            )),
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
    ));
  }

  void _onDeleteAllTask(DeleteAllTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removedTasks: List.from(state.removedTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
