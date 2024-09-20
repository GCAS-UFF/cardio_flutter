class DateHelper {
  static DateTime convertStringToDate(String dateStr) {
    if (dateStr == null) return null;
    if (dateStr.length != 10) return null;

    int day = int.tryParse(dateStr.substring(0, 2));
    int mounth = int.tryParse(dateStr.substring(3, 5));
    int year = int.tryParse(dateStr.substring(6, 10));

    return DateTime(year, mounth, day);
  }

  static String convertDateToString(DateTime dateTime) {
    if (dateTime == null) return "";
    String day = (dateTime.day < 10) ? "0${dateTime.day}" : "${dateTime.day}";
    String month =
        (dateTime.month < 10) ? "0${dateTime.month}" : "${dateTime.month}";
    String year = "${dateTime.year}";
    return "$day/$month/$year";
  }

  static int ageFromDate(DateTime dateTime) {
    int age;
    bool birthdayDone = false;
    if (dateTime == null)
      return 0;
    else if (DateTime.now().month > dateTime.month) {
      birthdayDone = true;
    } else if (DateTime.now().month == dateTime.month) {
      if (DateTime.now().day <= dateTime.day) {
        birthdayDone = true;
      }
    }
    if (birthdayDone) {
      age = DateTime.now().year - dateTime.year;
    } else {
      age = (DateTime.now().year - dateTime.year) - 1;
    }
    return age;
  }

  static DateTime addTimeToCurrentDate(String time) {
    if (time == null || time.length != 5) return null;

    int hour = int.tryParse(time.substring(0, 2));
    int minute = int.tryParse(time.substring(3, 5));

    DateTime result = DateTime.now();

    return DateTime(result.year, result.month, result.day, hour, minute);
  }

  static DateTime addTimeToDate(String time, DateTime dateTime) {
    if (time == null || time.length < 5) return null;

    int hour = int.tryParse(time.substring(0, 2));
    int minute = int.tryParse(time.substring(3, 5));

    DateTime result = dateTime;

    return DateTime(result.year, result.month, result.day, hour, minute);
  }

  static String getTimeFromDate(DateTime dateTime) {
    if (dateTime == null) return "";
    String hour =
        (dateTime.hour < 10) ? "0${dateTime.hour}" : "${dateTime.hour}";
    String minute =
        (dateTime.minute < 10) ? "0${dateTime.minute}" : "${dateTime.minute}";
    return "$hour:$minute";
  }
}
