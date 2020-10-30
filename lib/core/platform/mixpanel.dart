import 'dart:async';
import 'dart:io';

import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';

const MIXPANEL_TOKEN = '7c27b5a82c6705e36ef57be2c65901fd';
const DISTINCT_ID = "distinct_id";
const PHONE_OS = "phoneOS";
const LOCALE = "locale";
var a;

class Mixpanel {
  static Dio _http;
  static MixpanelAnalytics _mixpanel;
  static StreamController<String> _user$ = StreamController<String>.broadcast();

  static _init() {
    // _user$ ??= StreamController<String>.broadcast();
    _mixpanel ??= MixpanelAnalytics(
      token: MIXPANEL_TOKEN,
      userId$: _user$.stream,
      verbose: true,
      shouldAnonymize: false,
      shaFn: (value) => value,
      onError: (e) {
        print("[JP - Mixpanel] error: $e");
      },
    );
  }

  static Future<MixpanelResult> trackEvent(MixpanelEvents event, {String userId, Map<String, dynamic> data}) async {
    _init();
    if (userId == null) {
      try {
        userId = GetIt.instance<Settings>().getUserId();
      } catch (e) {
        userId = 'Usuário não identificado';
      }
    }
    _user$?.add(userId);

    if (data == null) data = Map<String, dynamic>();
    data[DISTINCT_ID] = userId;
    data[PHONE_OS] = Platform.isAndroid ? "android" : "iOS";
    data[LOCALE] = Platform.localeName;

    var result = await _mixpanel.track(event: _getEventString(event), properties: data);
    return result ? MixpanelResult(isSuccessful: true) : MixpanelResult(errorText: "Erro no Mixpanel");
  }

  static updateProfile(String userId, Map<String, dynamic> data) async {
    _init();
    _user$?.add(userId ?? 'Usuário não identificado');
    if (data == null) data = Map<String, dynamic>();
    data[DISTINCT_ID] = userId;
    var result = await _mixpanel.engage(
      operation: MixpanelUpdateOperations.$set,
      value: data,
      time: DateTime.now().toUtc(),
    );
    return result ? MixpanelResult(isSuccessful: true) : MixpanelResult(errorText: "Erro no Mixpanel");
  }
}

class MixpanelResult {
  final bool isSuccessful;
  final String errorText;

  MixpanelResult({this.isSuccessful = false, this.errorText});
}

enum MixpanelEvents {
  // General actions
  OPEN_APP, // feito
  DO_LOGIN, // feito
  DO_LOGOUT, // feito
  READ_ORIENTATIONS, // feito
  READ_INFORMATION, // feito
  READ_QUESTIONS, // feito
  OPEN_HISTORY, // feito

  // Professional actions
  REGISTER_PROFESSIONAL, // feito
  REGISTER_PATIENT, // feito
  EDIT_PROFESSIONAL, // feito
  EDIT_PATIENT, // feito
  DELETE_PATIENT, // feito
  OPEN_PATIENT, //feito
  RECOMMEND_ACTION, //feito
  EDIT_RECOMMENDATION, // feito
  DELETE_RECOMMENDATION, // feito

  // Patient actions
  DO_ACTION, // feito
  EDIT_ACTION, // feito
  DELETE_ACTION, // feito
}

String _getEventString(MixpanelEvents event) {
  switch (event) {
    case MixpanelEvents.OPEN_APP:
      return "OPEN_APP";
    case MixpanelEvents.DO_LOGIN:
      return "DO_LOGIN";
    case MixpanelEvents.DO_LOGOUT:
      return "DO_LOGOUT";
    case MixpanelEvents.READ_ORIENTATIONS:
      return "READ_ORIENTATIONS";
    case MixpanelEvents.READ_INFORMATION:
      return "READ_INFORMATION";
    case MixpanelEvents.READ_QUESTIONS:
      return "READ_QUESTIONS";
    case MixpanelEvents.OPEN_HISTORY:
      return "OPEN_HISTORY";
    case MixpanelEvents.REGISTER_PROFESSIONAL:
      return "REGISTER_PROFESSIONAL";
    case MixpanelEvents.REGISTER_PATIENT:
      return "REGISTER_PATIENT";
    case MixpanelEvents.EDIT_PROFESSIONAL:
      return "EDIT_PROFESSIONAL";
    case MixpanelEvents.EDIT_PATIENT:
      return "EDIT_PATIENT";
    case MixpanelEvents.DELETE_PATIENT:
      return "DELETE_PATIENT";
    case MixpanelEvents.OPEN_PATIENT:
      return "OPEN_PATIENT";
    case MixpanelEvents.RECOMMEND_ACTION:
      return "RECOMMEND_ACTION";
    case MixpanelEvents.EDIT_RECOMMENDATION:
      return "EDIT_RECOMMENDATION";
    case MixpanelEvents.DELETE_RECOMMENDATION:
      return "DELETE_RECOMMENDATION";
    case MixpanelEvents.DO_ACTION:
      return "DO_ACTION";
    case MixpanelEvents.EDIT_ACTION:
      return "EDIT_ACTION";
    case MixpanelEvents.DELETE_ACTION:
      return "DELETE_ACTION";
    default:
      return "UNKNOWN_EVENT";
  }
}
