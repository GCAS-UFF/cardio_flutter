import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/month.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/resources/keys.dart';

class CalendarConverter {
  static Calendar convertEntityListToCalendar(List<BaseEntity> entityList) {
    Calendar calendarObject = Calendar(months: List<Month>());

    // Run through all entity list
    for (var i = 0; i < entityList.length; i++) {
      // if the exercise was not done and doesnt have a initial date we shouldn't bother
      if (!entityList[i].done && entityList[i].initialDate != null) {
        // Run through all days for the initial date until the final date day by day
        for (var j = entityList[i].initialDate.millisecondsSinceEpoch;
            j <= entityList[i].finalDate.millisecondsSinceEpoch;
            j += 86400000) {
          // Get the month and day reference from date
          DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(j);
          addMonthIncalendar(calendarObject, entityList[i], currentDate);
        }
      } else if (entityList[i].done && entityList[i].executedDate != null) {
        addMonthIncalendar(
            calendarObject, entityList[i], entityList[i].executedDate);
      }
    }
    print("calendar " + calendarObject.toString());
    return calendarObject;
  }

  static addMonthIncalendar(
      Calendar calendarObject, BaseEntity entity, DateTime currentDate) {
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
        Month(
          id: monthInt,
          year: year,
          days: [
            Day(
              id: day,
              activities: [
                Activity(
                  informations: entityoActivity(entity),
                  type: Keys.ACTIVITY_RECOMENDED,
                  value: entity,
                  onClick: () {},
                ),
              ],
            )
          ],
        ),
      );
    } else {
      // if the month isn't null we should test if the day exists
      int dayIndex =
          calendarObject.months[monthIndex].days.indexWhere((dayItem) {
        return (dayItem.id == day);
      });
      // if the day doensn't exist we should add everything
      if (dayIndex < 0) {
        calendarObject.months[monthIndex].days.add(
          Day(
            id: day,
            activities: [
              Activity(
                informations: entityoActivity(entity),
                type: Keys.ACTIVITY_RECOMENDED,
                value: entity,
                onClick: () {},
              ),
            ],
          ),
        );
      } else {
        // We should add in the existing day
        calendarObject.months[monthIndex].days[dayIndex].activities.add(
          Activity(
            informations: entityoActivity(entity),
            type: Keys.ACTIVITY_DONE,
            value: entity,
            onClick: () {},
          ),
        );
      }
    }
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

  static Map<String, String> entityoActivity(BaseEntity entity) {
    Map<String, String> result;

    if (entity is Exercise) {
      Exercise exercise = entity as Exercise;

      if (!exercise.done) {
        result = {
          "Exercício": exercise.name,
          "Frequência": exercise.frequency.toString(),
          "Intensidade": exercise.intensity,
          "Duração": "${exercise.durationInMinutes} minutos",
          "Data de Inicio":
              DateHelper.convertDateToString(exercise.initialDate),
          "Data de Fim": DateHelper.convertDateToString(exercise.finalDate),
        };
      } else {
        result = {
          "Hora da Realização": exercise.executionTime,
          "Exercício": exercise.name,
          "Intensidade": exercise.intensity,
          "Duração": "${exercise.durationInMinutes} minutos",
          "Sintomas": "",
          "   Falta de Ar Excessiva": symptom(exercise.shortnessOfBreath),
          "   Fadiga Excessiva": symptom(exercise.excessiveFatigue),
          "   Tontura": symptom(exercise.dizziness),
          "   Dores Corporais": symptom(exercise.bodyPain),
        };
      }
    } else if (entity is Liquid) {
      if (!entity.done) {
        result = {
          "Quantide em ml": entity.mililitersPerDay.toString(),
          "Data de Inicio": DateHelper.convertDateToString(entity.initialDate),
          "Data de Fim": DateHelper.convertDateToString(entity.finalDate),
        };
      } else {
        result = {
          "Quantidade Ingerida":
              (entity.reference * entity.quantity).toString(),
          "Bebida": entity.name,
        };
      }
    } else if (entity is Biometric) {
      if (!entity.done) {
        result = {
          "Frequência": entity.frequency.toString(),
          "Data de Inicio": DateHelper.convertDateToString(entity.initialDate),
          "Data de Fim": DateHelper.convertDateToString(entity.finalDate),
        };
      } else {
        result = {
          "Peso": "${entity.weight} kg",
          "Batimentos Cardíacos": "${entity.bpm} bpm",
          "Pressão Arterial": entity.bloodPressure,
          "Inchaço": entity.swelling,
          "Fadiga": entity.fatigue,
        };
      }
    } else if (entity is Appointment) {
      if (!entity.done) {
        result = {
          "Especialidade": entity.expertise,
          "Data": DateHelper.convertDateToString(entity.appointmentDate),
          "Horário": DateHelper.getTimeFromDate(entity.appointmentDate),
          "Localização": entity.adress,
        };
      } else {
        result = {
          "Especialidade": entity.expertise,
          "Data Prevista":
              DateHelper.convertDateToString(entity.appointmentDate),
          "Horário Previsto":
              DateHelper.getTimeFromDate(entity.appointmentDate),
          "Localização": entity.adress,
          "Compareceu": entity.went,
          "Respondeu em": DateHelper.convertDateToString(entity.executedDate),
        };
      }
    } else if (entity is Medication) {
      if (!entity.done) {
        result = {
          "Frequência": "${entity.frequency.toString()} vezes ao dia",
          "Data de Inicio": DateHelper.convertDateToString(entity.initialDate),
          "Data de Fim": DateHelper.convertDateToString(entity.finalDate),
          "Nome": entity.name,
          "Dosagem": entity.dosage.toString(),
          "Quantidade": entity.quantity.toString(),
          "Hora de Início": DateHelper.getTimeFromDate(entity.initialDate),
          "Observação": entity.observation,
        };
      } else {
        result = {
          "Hora da Realização": DateHelper.getTimeFromDate(entity.executedDate),
          "Nome": entity.name,
          "Dosagem": entity.dosage.toString(),
          "Quantidade": entity.quantity.toString(),
          "Ingerido": (entity.tookIt != null || entity.tookIt) ? "Sim" : "Não",
          "Observação": entity.observation,
        };
      }
    }

    return result;
  }
}
