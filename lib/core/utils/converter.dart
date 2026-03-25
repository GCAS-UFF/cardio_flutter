import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart'
    as calendar;
import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/month.dart'
    as month;
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';

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

  // 1. Mudamos para List<String>? e corrigimos o construtor da List
  static List<String>? convertListDynamicToListString(List<dynamic>? inputs) {
    if (inputs == null) return null;
    List<String> result = []; // Usar [] em vez de List()
    for (var element in inputs) {
      result.add(element.toString());
    }
    return result;
  }

  static String convertStringListToString(List<String>? list) {
    if (list == null) return "";
    return list.join(', ');
  }

  // 2. Trocamos @required por required e bool por bool? ou damos valor default
  static String convertStringToMaskedString({
    required String? value,
    required String? mask,
    String escapeCharacter = "x",
    bool onlyDigits = false, // Valor default para não ser nulo
  }) {
    if (value == null || mask == null) return "";
    String cleanedValue = cleanText(value, onlyDigits: onlyDigits);
    int i = 0;
    int j = 0;
    String result = "";
    for (; i < cleanedValue.length && j < mask.length; i++, j++) {
      if (mask[j] == escapeCharacter) {
        result = result + cleanedValue[i];
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

  static String convertStringToMultimaskedString({
    required String? value,
    required String maskDefault,
    required String maskSecondary, // Corrigido erro de digitação
    required bool Function(String?)? changeMask,
    bool onlyDigits = false,
    String escapeCharacter = "x",
  }) {
    String mask;
    if (changeMask == null) {
      mask = maskDefault;
    } else {
      mask = (changeMask(value)) ? maskSecondary : maskDefault;
    }

    return convertStringToMaskedString(
        value: value,
        mask: mask,
        escapeCharacter: escapeCharacter,
        onlyDigits: onlyDigits);
  }

  static String cleanText(String text, {bool onlyDigits = false}) {
    String result = text
        .replaceAll(".", "")
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .replaceAll(":", "");
    
    if (onlyDigits) {
      result = result.replaceAll(RegExp(r'[^0-9]'), ''); // Forma mais moderna de limpar
    }

    return result;
  }

  static calendar.Calendar convertExerciseToCalendar(List<Exercise> exerciseList) {
    calendar.Calendar calendarObject = calendar.Calendar(months: []);

    for (var i = 0; i < exerciseList.length; i++) {
      final exercise = exerciseList[i];
      if (!exercise.done && exercise.initialDate != null && exercise.finalDate != null) {
        for (var j = exercise.initialDate!.millisecondsSinceEpoch;
            j <= exercise.finalDate!.millisecondsSinceEpoch;
            j += 86400000) {
          DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(j);
          addMonthIncalendar(calendarObject, exercise, currentDate);
        }
      } else if (exercise.done && exercise.executionDay != null) {
        addMonthIncalendar(calendarObject, exercise, exercise.executionDay!);
      }
    }
    return calendarObject;
  }

  static void addMonthIncalendar(calendar.Calendar calendarObject, Exercise exercise, DateTime currentDate) {
    int year = currentDate.year;
    int monthInt = currentDate.month;
    int day = currentDate.day;

    int monthIndex = calendarObject.months.indexWhere((monthItem) => monthItem.id == monthInt);

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
      int dayIndex = calendarObject.months[monthIndex].days.indexWhere((dayItem) => dayItem.id == day);
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

  static String? symptom(bool? symptomValue) {
    if (symptomValue == null) return null;
    return (symptomValue) ? "Houve" : "Não houve";
  }

  static Map<String, String> exerciseToActivity(Exercise exercise) {
    Map<String, String> result;

    if (!exercise.done) {
      result = {
        "Exercício": exercise.name ?? "Sem nome",
        "Frequência": exercise.frequency.toString(),
        "Intensidade": (Arrays.intensities[exercise.intensity] == null)
            ? "Não Selecionado"
            : Arrays.intensities[exercise.intensity]!,
        "Horários Indicados": convertStringListToString(exercise.times),
        "Duração": "${exercise.durationInMinutes} minutos",
        "Data de Inicio": DateHelper.convertDateToString(exercise.initialDate),
        "Data de Fim": DateHelper.convertDateToString(exercise.finalDate),
        "Observação": exercise.observation ?? "",
      };
    } else {
      result = {
        "Hora da Realização": exercise.executionTime ?? "--:--",
        "Exercício": exercise.name ?? "Sem nome",
        "Intensidade": (Arrays.intensities[exercise.intensity] == null)
            ? "Não Selecionado"
            : Arrays.intensities[exercise.intensity]!,
        "Duração": "${exercise.durationInMinutes} minutos",
        "Sintomas": "",
        "   Falta de Ar Excessiva": symptom(exercise.shortnessOfBreath) ?? "Não informado",
        "   Fadiga Excessiva": symptom(exercise.excessiveFatigue) ?? "Não informado",
        "   Tontura": symptom(exercise.dizziness) ?? "Não informado",
        "   Dores Corporais": symptom(exercise.bodyPain) ?? "Não informado",
        "Observação": exercise.observation ?? "",
      };
    }
    return result;
  }
}