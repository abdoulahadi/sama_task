import 'package:intl/intl.dart'; 

class DateFormatter {
  
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }


  static String formatDateFromString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(date); 
  }
}