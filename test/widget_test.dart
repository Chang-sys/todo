import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ToDo/screens/tabs_screen.dart';
import 'package:ToDo/screens/pending_tasks_screen.dart';
import 'package:ToDo/screens/completed_tasks_screen.dart';
import 'package:ToDo/screens/favorite_tasks_screen.dart';
import 'package:ToDo/models/task.dart';
import 'package:ToDo/blocs/bloc_export.dart';

class MockTasksBloc extends MockBloc<TasksEvent, TasksState>
    implements TasksBloc {}

void main() {
  late MockTasksBloc mockTasksBloc;

  setUp(() {
    mockTasksBloc = MockTasksBloc();
  });

  tearDown(() {
    mockTasksBloc.close();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<TasksBloc>(
      create: (_) => mockTasksBloc,
      child: MaterialApp(
        home: TabsScreen(),
      ),
    );
  }

  testWidgets('TabsScreen displays PendingTasksScreen initially',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTasksBloc.state).thenReturn(TasksState(
      pendingTasks: [
        Task(
            id: '1',
            title: 'Test Task',
            description: 'Test Description',
            date: '2024-01-01')
      ],
      completedTasks: [],
      favoriteTasks: [],
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byKey(Key('appBarTitle')), findsOneWidget);
    expect(find.text('Pending Tasks'), findsOneWidget);
  });

  testWidgets('TabsScreen switches to CompletedTasksScreen when tab is tapped',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTasksBloc.state).thenReturn(TasksState(
      pendingTasks: [
        Task(
            id: '1',
            title: 'Test Task',
            description: 'Test Description',
            date: '2024-01-01')
      ],
      completedTasks: [
        Task(
            id: '2',
            title: 'Completed Task',
            description: 'Description',
            date: '2024-01-01')
      ],
      favoriteTasks: [],
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Complete Tasks'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(Key('appBarTitle')), findsOneWidget);
    expect(find.text('Completed Tasks'), findsOneWidget);
  });

  testWidgets('TabsScreen switches to FavoriteTasksScreen when tab is tapped',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockTasksBloc.state).thenReturn(TasksState(
      pendingTasks: [
        Task(
            id: '1',
            title: 'Test Task',
            description: 'Test Description',
            date: '2024-01-01')
      ],
      completedTasks: [],
      favoriteTasks: [
        Task(
            id: '3',
            title: 'Favorite Task',
            description: 'Description',
            date: '2024-01-01')
      ],
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Favorite Tasks'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(Key('appBarTitle')), findsOneWidget);
    expect(find.text('Favorite Tasks'), findsOneWidget);
  });
}
