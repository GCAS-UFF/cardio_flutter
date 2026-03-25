import 'package:cardio_flutter/core/utils/converter.dart';
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
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/keys.dart';

class CalendarConverter {
  static Calendar convertEntityListToCalendar(List<BaseEntity> entityList) {
    Calendar calendarObject = Calendar(months: []);

    for (var i = 0; i < entityList.length; i++) {
      final entity = entityList[i];

      // Removidas as checagens e exclamações de initialDate e finalDate, pois agora são não-nulos
      if (!entity.done) {
        for (var j = entity.initialDate.millisecondsSinceEpoch;
            j <= entity.finalDate.millisecondsSinceEpoch;
            j += 86400000) {
          DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(j);
          addMonthInCalendar(calendarObject, entity, currentDate);
        }
      } else if (entity.done && entity.executedDate != null) {
        addMonthInCalendar(calendarObject, entity, entity.executedDate!);
      }
    }
    return calendarObject;
  }

  static void addMonthInCalendar(
      Calendar calendarObject, BaseEntity entity, DateTime currentDate) {
    int year = currentDate.year;
    int monthInt = currentDate.month;
    int day = currentDate.day;

    int monthIndex = calendarObject.months.indexWhere((m) => m.id == monthInt && m.year == year);

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
                  informations: _entityToActivity(entity),
                  type: entity.done ? Keys.ACTIVITY_DONE : Keys.ACTIVITY_RECOMENDED,
                  value: entity,
                  onClick: () {},
                ),
              ],
            )
          ],
        ),
      );
    } else {
      int dayIndex = calendarObject.months[monthIndex].days.indexWhere((d) => d.id == day);

      if (dayIndex < 0) {
        calendarObject.months[monthIndex].days.add(
          Day(
            id: day,
            activities: [
              Activity(
                informations: _entityToActivity(entity),
                type: entity.done ? Keys.ACTIVITY_DONE : Keys.ACTIVITY_RECOMENDED,
                value: entity,
                onClick: () {},
              ),
            ],
          ),
        );
      } else {
        calendarObject.months[monthIndex].days[dayIndex].activities.add(
          Activity(
            informations: _entityToActivity(entity),
            type: entity.done ? Keys.ACTIVITY_DONE : Keys.ACTIVITY_RECOMENDED,
            value: entity,
            onClick: () {},
          ),
        );
      }
    }
  }

  static String symptom(bool? symptomValue) {
    if (symptomValue == null) return "Não informado";
    return symptomValue ? "Houve" : "Não houve";
  }

  static Map<String, String> _entityToActivity(BaseEntity entity) {
    Map<String, String> result = {};

    if (entity is Exercise) {
      // Cast explícito resolve o erro de "getter isn't defined for BaseEntity"
      final exercise = entity as Exercise; 
      
      if (!exercise.done) {
        result = {
          "Exercício": "${exercise.name}",
          "Frequência": "${exercise.frequency} vezes ao dia",
          "Intensidade": Arrays.intensities[exercise.intensity] ?? "Não Selecionado",
          "Horários Indicados": Converter.convertStringListToString(exercise.times ?? []),
          "Duração": "${exercise.durationInMinutes} minutos",
          "Data de Início": DateHelper.convertDateToString(exercise.initialDate),
          "Data de Fim": DateHelper.convertDateToString(exercise.finalDate),
        };
      } else {
        result = {
          "Hora da Realização": exercise.executionTime ?? "",
          "Exercício": "${exercise.name}",
          "Intensidade": Arrays.intensities[exercise.intensity] ?? "Não Selecionado",
          "Duração": "${exercise.durationInMinutes} minutos",
          "   Falta de Ar Excessiva": symptom(exercise.shortnessOfBreath),
          "   Fadiga Excessiva": symptom(exercise.excessiveFatigue),
          "   Tontura": symptom(exercise.dizziness),
          "   Dores Corporais": symptom(exercise.bodyPain),
          "Observação": exercise.observation ?? "",
        };
      }
    } else if (entity is Liquid) {
      final liquid = entity as Liquid;

      if (!liquid.done) {
        result = {
          "Quantidade em ml": "${liquid.mililitersPerDay}",
          "Data de Início": DateHelper.convertDateToString(liquid.initialDate),
          "Data de Fim": DateHelper.convertDateToString(liquid.finalDate),
        };
      } else {
        String refLabel = (liquid.reference != null && Arrays.reference[liquid.reference] != null)
            ? '${(Arrays.reference[liquid.reference]! * (liquid.quantity ?? 0))} ml' 
            : "Referência não selecionada";
        
        result = {
          "Quantidade Ingerida": refLabel,
          "Hora da Realização": liquid.executedDate != null ? DateHelper.getTimeFromDate(liquid.executedDate!) : "",
          "Bebida": "${liquid.name}",
        };
      }
    } else if (entity is Biometric) {
      final biometric = entity as Biometric;

      if (!biometric.done) {
        result = {
          "Frequência": "${biometric.frequency} vezes ao dia",
          "Horários Indicados": Converter.convertStringListToString(biometric.times ?? []),
          "Data de Início": DateHelper.convertDateToString(biometric.initialDate),
          "Data de Fim": DateHelper.convertDateToString(biometric.finalDate),
        };
      } else {
        result = {
          "Peso": "${biometric.weight} kg",
          "Batimentos Cardíacos": "${biometric.bpm} bpm",
          "Pressão Arterial": "${biometric.bloodPressure}",
          "Inchaço": Arrays.swelling[biometric.swelling] ?? "Não Selecionado",
          if (biometric.swelling != "Nenhum" && biometric.swelling != null) 
            "Localização do Inchaço": "${biometric.swellingLocalization}",
          "Fadiga": Arrays.fatigue[biometric.fatigue] ?? "Não Selecionado",
          "Hora da Realização": biometric.executedDate != null ? DateHelper.getTimeFromDate(biometric.executedDate!) : "",
          "Observação": biometric.observation ?? "",
        };
      }
    } else if (entity is Appointment) {
      final appointment = entity as Appointment;
      String addressLabel = Arrays.adresses[appointment.address] ?? "Não Selecionado";
      
      if (!appointment.done) {
        result = {
          "Especialidade": Arrays.expertises[appointment.expertise] ?? "Não Selecionado",
          "Data": DateHelper.convertDateToString(appointment.appointmentDate ?? appointment.initialDate),
          "Horário": appointment.appointmentDate != null ? DateHelper.getTimeFromDate(appointment.appointmentDate!) : "",
          "Localização": addressLabel,
        };
      } else {
        bool went = appointment.went ?? false;
        result = {
          "Especialidade": Arrays.expertises[appointment.expertise] ?? "Não Selecionado",
          "Data Prevista": DateHelper.convertDateToString(appointment.appointmentDate ?? appointment.initialDate),
          "Localização": addressLabel,
          "Compareceu": went ? "Sim" : "Não",
          if (!went) "Justificativa": appointment.justification ?? "",
          "Respondeu em": appointment.executedDate != null ? DateHelper.convertDateToString(appointment.executedDate!) : "",
        };
      }
    } else if (entity is Medication) {
      final medication = entity as Medication;

      if (!medication.done) {
        result = {
          "Nome": "${medication.name}",
          "Dosagem": "${medication.dosage}",
          "Frequência": "${medication.frequency} vezes ao dia",
          "Horários Indicados": Converter.convertStringListToString(medication.times ?? []),
          "Data de Início": DateHelper.convertDateToString(medication.initialDate),
          "Data de Fim": DateHelper.convertDateToString(medication.finalDate),
          "Observação": medication.observation ?? "",
        };
      } else {
        result = {
          "Nome": "${medication.name}",
          "Dosagem": "${medication.dosage}",
          "Hora da Realização": medication.executedDate != null ? DateHelper.getTimeFromDate(medication.executedDate!) : "",
          "Ingerido": (medication.tookIt ?? false) ? "Sim" : "Não",
          "Observação": medication.observation ?? "",
        };
      }
    }

    return result;
  }
}