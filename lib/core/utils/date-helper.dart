class DateHelper {
  static DateTime convertStringToDate (String dateStr){
    if (dateStr.length != 10) return null;

      int day = int.tryParse(dateStr.substring(0, 2));
      int mounth = int.tryParse(dateStr.substring(3, 5));
      int year = int.tryParse(dateStr.substring(6, 10));

      DateTime(year, mounth, day);
  }
}