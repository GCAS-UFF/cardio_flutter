class DateHelper {
  // 1. Mudamos para DateTime? porque o retorno pode ser nulo se a string for inválida
  static DateTime? convertStringToDate(String? dateStr) {
    if (dateStr == null || dateStr.length != 10) return null;

    // 2. int.tryParse retorna int?, então usamos 'final' ou 'int?'
    final day = int.tryParse(dateStr.substring(0, 2));
    final month = int.tryParse(dateStr.substring(3, 5));
    final year = int.tryParse(dateStr.substring(6, 10));

    // 3. Se qualquer um falhar na conversão, retornamos null
    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  static String convertDateToString(DateTime? dateTime) {
    if (dateTime == null) return "";
    
    // Adicionamos o padLeft para garantir os dois dígitos (mais limpo que o IF)
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    
    return "$day/$month/$year";
  }

  static int ageFromDate(DateTime? dateTime) {
    if (dateTime == null) return 0;
    
    DateTime now = DateTime.now();
    int age = now.year - dateTime.year;
    
    // Lógica simplificada: se ainda não fez aniversário este ano, subtrai 1
    if (now.month < dateTime.month || 
       (now.month == dateTime.month && now.day < dateTime.day)) {
      age--;
    }
    
    return age;
  }

  static DateTime? addTimeToCurrentDate(String? time) {
    if (time == null || time.length != 5) return null;

    final hour = int.tryParse(time.substring(0, 2));
    final minute = int.tryParse(time.substring(3, 5));

    if (hour == null || minute == null) return null;

    DateTime result = DateTime.now();
    return DateTime(result.year, result.month, result.day, hour, minute);
  }

  static DateTime? addTimeToDate(String? time, DateTime? dateTime) {
    if (time == null || time.length < 5 || dateTime == null) return null;

    final hour = int.tryParse(time.substring(0, 2));
    final minute = int.tryParse(time.substring(3, 5));

    if (hour == null || minute == null) return null;

    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  }

  static String getTimeFromDate(DateTime? dateTime) {
    if (dateTime == null) return "";
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}