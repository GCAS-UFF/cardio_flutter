import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/resources/strings.dart';
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

  static String convertStringToMaskedString(
      {@required String value,
      @required String mask,
      String escapeCharacter = "x",
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
      String escapeCharacter = "x"}) {
    String mask;
    if (changeMask == null)
      mask = maskDefault;
    else
      mask = (changeMask(value)) ? maskSecundary : maskDefault;

    return convertStringToMaskedString(
        value: value,
        mask: mask,
        escapeCharacter: escapeCharacter,
        onlyDigits: onlyDigits);
  }

  static String cleanText(String text, {bool onlyDigits}) {
    text = text.replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "");
    if (onlyDigits != null && onlyDigits) {
      for (int i = 0; i < text.length; i++) {
        if (int.tryParse(text[i]) == null) {
          text = text.replaceAll(text[i], "");
        }
      }
    }

    return text;
  }
}
