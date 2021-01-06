import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart' as calendar;
import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/month.dart' as month;
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Converter {
  static String convertFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return Strings.message_server_failure;
    } else if (failure is NoInternetConnectionFailure) {
      return Strings.message_no_internet_connection;
    } else if (failure is CacheFailure) {
      return Strings.message_cache_failure;
    } else if (failure is PlatformFailure) {
      return failure.message;
    } else {
      return Strings.unexpected_error;
    }
  }

  static List<String> convertListDynamicToListString(List<dynamic> inputs) {
    if (inputs == null) return null;
    List<String> result = List<String>();
    for (String string in inputs) {
      result.add(string);
    }

    return result;
  }

  static String convertStringListToString(List<String> list) {
    final String string = list.join(', ');
    return string;
  }

  static String convertStringToMaskedString({@required String value, @required String mask, String escapeCharacter = "#", bool onlyDigits}) {
    if (value == null || mask == null) return "";
    value = cleanText(value, onlyDigits: onlyDigits);
    int i = 0;
    int j = 0;
    String result = "";
    for (; i < value.length && j < mask.length; i++, j++) {
      if (mask[j] == escapeCharacter) {
        result = result + value[i];
        while (j + 1 < mask.length && mask[j + 1] != escapeCharacter) {
          ++j;
          result = result + mask[j];
        }
      } else {
        result = result + mask[j];
      }
    }
    return result;
  }

  static String convertStringToMultimaskedString(
      {@required String value,
      @required String maskDefault,
      @required String maskSecundary,
      @required Function changeMask,
      bool onlyDigits,
      String escapeCharacter = "#"}) {
    String mask;
    if (changeMask == null)
      mask = maskDefault;
    else
      mask = (changeMask(value)) ? maskSecundary : maskDefault;

    return convertStringToMaskedString(value: value, mask: mask, escapeCharacter: escapeCharacter, onlyDigits: onlyDigits);
  }

  static String cleanText(String text, {bool onlyDigits}) {
    text = text.replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "");
    if (onlyDigits != null && onlyDigits) {
      for (int i = 0; i < text.length; i++) {
        if (int.tryParse(text[i]) == null) {
          text = text.replaceAll(text[i], "");
        }
      }
    }

    return text;
  }



  static String symptom(bool symptom) {
    String string;
    if (symptom == null) {
      return null;
    } else {
      (symptom == true) ? string = "Houve" : string = "Não houve";
      return string;
    }
  }


  static String getDateAsString(DateTime date) {
    if (date == null) return null;
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static int getAgeFromDate(DateTime date) {
    if (date == null) return null;
    return (new DateTime.now().difference(date)).inDays ~/ 365;
  }
}
