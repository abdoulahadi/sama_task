import 'package:sama_task/data/models/task.dart';

class AppStrings {

  static const String baseApiUrl = 'http://192.168.1.13:3000/';


  static String getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Élevée';
      case TaskPriority.medium:
        return 'Moyenne';
      case TaskPriority.low:
        return 'Basse';
    }
  }

  static TaskPriority getLabelPriority(String priority) {
    switch (priority) {
      case 'Élevée':
        return TaskPriority.high ;
      case 'Moyenne':
        return TaskPriority.medium;
      case 'Basse':
        return TaskPriority.low;
      default:
        return TaskPriority.low;
    }
  }
}