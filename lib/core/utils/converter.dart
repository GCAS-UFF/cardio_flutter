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

  static String convertStringToMaskedString(
      {@required String value,
      @required String mask,
      String escapeCharacter = "#",
      bool onlyDigits}) {
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

  static calendar.Calendar convertExerciseToCalendar(List<Exercise> exerciseList) {
    calendar.Calendar calendarObject = calendar.Calendar(months: List<month.Month>());

    // Run through all exercice list
    for (var i = 0; i < exerciseList.length; i++) {
      // if the exercise was not done and doesnt have a initial date we shouldn't bother
      if (!exerciseList[i].done && exerciseList[i].initialDate != null) {
        // Run through all days for the initial date until the final date day by day
        for (var j = exerciseList[i].initialDate.millisecondsSinceEpoch; j <= exerciseList[i].finalDate.millisecondsSinceEpoch; j += 86400000) {
          // Get the month and day reference from date
          DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(j);
          addMonthIncalendar(calendarObject, exerciseList[i], currentDate);
        }
      } else if (exerciseList[i].done && exerciseList[i].executionDay != null) {
        addMonthIncalendar(calendarObject, exerciseList[i], exerciseList[i].executionDay);
      }
    }
    print("calendar " + calendarObject.toString());
    return calendarObject;
  }

  static addMonthIncalendar(calendar.Calendar calendarObject, Exercise exercise, DateTime currentDate) {
    int year = currentDate.year;
    print(year);
    int monthInt = currentDate.month;
    int day = currentDate.day;
    //Test if the month is alredy in the calendar
    int monthIndex = calendarObject.months.indexWhere((monthItem) {
      return (monthItem.id == monthInt);
    });
    // if the mounth doesnt exist in calendar we should add everything
    if (monthIndex < 0) {
      calendarObject.months.add(
        month.Month(
          id: monthInt,
          year: year,
          days: [
            Day(
              id: day,
              activities: [
                Activity(
                  informations: exerciseToActivity(exercise),
                  type: Keys.ACTIVITY_RECOMENDED,
                  value: exercise,
                  onClick: () {},
                ),
              ],
            )
          ],
        ),
      );
    } else {
      // if the month isn't null we should test if the day exists
      int dayIndex = calendarObject.months[monthIndex].days.indexWhere((dayItem) {
        return (dayItem.id == day);
      });
      // if the day doensn't exist we should add everything
      if (dayIndex < 0) {
        calendarObject.months[monthIndex].days.add(
          Day(
            id: day,
            activities: [
              Activity(
                informations: exerciseToActivity(exercise),
                type: Keys.ACTIVITY_RECOMENDED,
                value: exercise,
                onClick: () {},
              ),
            ],
          ),
        );
      } else {
        // We should add in the existing day
        calendarObject.months[monthIndex].days[dayIndex].activities.add(
          Activity(
            informations: exerciseToActivity(exercise),
            type: Keys.ACTIVITY_DONE,
            value: exercise,
            onClick: () {},
          ),
        );
      }
    }
  }

  static String symptom(List<String> symptomList) {
    if (symptomList == null)
      return "";
    else {
      String result = "";
      if (symptomList.isEmpty)
        result = "Sem sintomas";
      else
        for (int i = 0; i < symptomList.length; i++) {
          result += symptomList[i];
          if (i == (symptomList.length - 1))
            result += ".";
          else if (i == (symptomList.length - 2))
            result += " e ";
          else
            result += ", ";
        }
      return result;
    }
  }

  static Map<String, String> exerciseToActivity(Exercise exercise) {
    Map<String, String> result;

    if (!exercise.done) {
      result = {
        "Exercício": exercise.name,
        "Frequência": exercise.frequencyPerWeek.toString(),
        "Intensidade": (Arrays.intensities[exercise.intensity] == null)
            ? "Não Selecionado"
            : Arrays.intensities[exercise.intensity],
        "Horários Indicados":
            Converter.convertStringListToString(exercise.times),
        "Duração": "${exercise.durationInMinutes} minutos",
        "Data de Inicio": DateHelper.convertDateToString(exercise.initialDate),
        "Data de Fim": DateHelper.convertDateToString(exercise.finalDate),
        "Observação": (exercise.observation != null) ? exercise.observation : "",
      };
    } else {
      result = {
        "Hora da Realização": exercise.executionTime,
        "Exercício": exercise.name,
        "Intensidade": (Arrays.intensities[exercise.intensity] == null) ? "Não Selecionado" : Arrays.intensities[exercise.intensity],
        "Duração": "${exercise.durationInMinutes} minutos",
        "Sintomas": symptom(exercise.symptoms),
        "Observação":
            (exercise.observation != null) ? exercise.observation : "",
      };
    }
    return result;
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
