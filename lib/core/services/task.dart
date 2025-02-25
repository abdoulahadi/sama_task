import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sama_task/core/constants/app_strings.dart';
import 'package:sama_task/data/local/database.dart';
import 'package:sama_task/data/models/api_exception.dart';
import 'package:sama_task/data/models/task.dart';

class TaskService {
  static const String _baseUrl = '${AppStrings.baseApiUrl}task';
  final http.Client _client;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  TaskService({http.Client? client}) : _client = client ?? http.Client();

  Future<Task> create(String jwt, Task task) async {
    if (await _isOnline()) {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: _headers(jwt),
        body: jsonEncode(task.toCreateJson()),
      );

      final createdTask = _handleResponse<Task>(
        response,
        (json) => Task.fromJson(json),
        successStatus: 201,
        errorMessage: 'Échec de la création de tâche',
      );

      await _dbHelper.insertTask(createdTask);
      return createdTask;
    } else {
      await _dbHelper.insertPendingAction('create', null, jsonEncode(task.toCreateJson()));
      await _dbHelper.insertTask(task); 
      return task;
    }
  }

  Future<List<Task>> getAll(String jwt) async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: _headers(jwt),
      );

      final tasks = _handleResponse<List<Task>>(
        response,
        (json) => (json as List).map((e) => Task.fromJson(e)).toList(),
        errorMessage: 'Échec du chargement des tâches',
      );

      for (var task in tasks) {
        await _dbHelper.insertTask(task);
      }

      return tasks;
    } catch (e) {
      return await _dbHelper.getTasks();
    }
  }

  Future<Task> getById(String jwt, int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers(jwt),
      );

      final task = _handleResponse<Task>(
        response,
        (json) => Task.fromJson(json),
        errorMessage: 'Échec de la récupération de la tâche',
      );

      await _dbHelper.insertTask(task);
      return task;
    } catch (e) {
      final tasks = await _dbHelper.getTasks();
      return tasks.firstWhere((task) => task.id == id);
    }
  }

  Future<Task> update(String jwt, Task task) async {
    if (await _isOnline()) {
      final response = await _client.patch(
        Uri.parse('$_baseUrl/${task.id}'),
        headers: _headers(jwt),
        body: jsonEncode(task.toUpdateJson()),
      );

      final updatedTask = _handleResponse<Task>(
        response,
        (json) => Task.fromJson(json),
        errorMessage: 'Échec de la mise à jour de la tâche',
      );

      await _dbHelper.updateTask(updatedTask);
      return updatedTask;
    } else {
      await _dbHelper.insertPendingAction('update', task.id, jsonEncode(task.toUpdateJson()));
      await _dbHelper.updateTask(task);
      return task;
    }
  }

  Future<void> delete(String jwt, int id) async {
    if (await _isOnline()) {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers(jwt),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Échec de la suppression: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      await _dbHelper.deleteTask(id);
    } else {
      await _dbHelper.insertPendingAction('delete', id, '');
      await _dbHelper.deleteTask(id); 
    }
  }

  Future<void> syncPendingActions(String jwt) async {
    if (!await _isOnline()) return;

    final pendingActions = await _dbHelper.getPendingActions();

    for (var action in pendingActions) {
      final actionType = action['action_type'];
      final taskId = action['task_id'];
      final taskData = action['task_data'];

      try {
        switch (actionType) {
          case 'create':
            final task = Task.fromJson(jsonDecode(taskData));
            await create(jwt, task);
            break;
          case 'update':
            final task = Task.fromJson(jsonDecode(taskData));
            await update(jwt, task);
            break;
          case 'delete':
            await delete(jwt, taskId);
            break;
        }

        await _dbHelper.deletePendingAction(action['id']);
      } catch (e) {
        print('Erreur lors de la synchronisation : $e');
      }
    }
  }

  Future<bool> _isOnline() async {
    try {
      final response = await http.get(Uri.parse('${AppStrings.baseApiUrl}api-docs'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Map<String, String> _headers(String jwt) => {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  };

  T _handleResponse<T>(
    http.Response response,
    T Function(dynamic) converter, {
    String? errorMessage,
    int successStatus = 200,
  }) {
    final body = jsonDecode(response.body);
    
    if (response.statusCode == successStatus) {
      return converter(body);
    } else {
      throw ApiException(
        message: errorMessage ?? 'Erreur inconnue',
        statusCode: response.statusCode,
        serverMessage: body['message'] ?? response.body,
      );
    }
  }
}