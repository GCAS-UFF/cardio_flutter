import 'dart:async';
import 'dart:io';

import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:package_info/package_info.dart';

const MIXPANEL_TOKEN = 'f06f25864e88616b1384f5c2cb52b0a7';
const DISTINCT_ID = "distinct_id";
const PHONE_OS = "phoneOS";
const LOCALE = "locale";
var a;

class Mixpanel {
  static Dio _http;
  static MixpanelAnalytics _mixpanel;
  static StreamController<String> _user$ = StreamController<String>.broadcast();

  static _init(String versionName) {
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

  static Future<MixpanelResult> trackEvent(MixpanelEvents event,
      {String userId, Map<String, dynamic> data}) async {
    String version = (await PackageInfo.fromPlatform()).version;
    _init(version);
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
    data['timeStamp'] = DateTime.now();

    var result = await _mixpanel.track(
      event: _getEventString(event),
      properties: data,
    );
    return result
        ? MixpanelResult(isSuccessful: true)
        : MixpanelResult(errorText: "Erro no Mixpanel");
  }

  static updateProfile(String userId, Map<String, dynamic> data) async {
    String version = (await PackageInfo.fromPlatform()).version;
    _init(version);
    _user$?.add(userId ?? 'Usuário não identificado');
    if (data == null) data = Map<String, dynamic>();
    data[DISTINCT_ID] = userId;
    data['timeStamp'] = DateTime.now();
    var result = await _mixpanel.engage(
      operation: MixpanelUpdateOperations.$set,
      value: data,
      time: DateTime.now().toUtc(),
    );
    return result
        ? MixpanelResult(isSuccessful: true)
        : MixpanelResult(errorText: "Erro no Mixpanel");
  }
}

class MixpanelResult {
  final bool isSuccessful;
  final String errorText;

  MixpanelResult({this.isSuccessful = false, this.errorText});
}

enum MixpanelEvents {
  // General actions
  OPEN_APP,
  DO_LOGIN,
  DO_LOGOUT,
  READ_ORIENTATIONS,
  READ_INFORMATION,
  READ_QUESTIONS,
  OPEN_HISTORY,

  // Professional actions
  REGISTER_PROFESSIONAL,
  REGISTER_PATIENT,
  EDIT_PROFESSIONAL,
  EDIT_PATIENT,
  DELETE_PATIENT,
  OPEN_PATIENT,
  RECOMMEND_ACTION,
  EDIT_RECOMMENDATION,
  DELETE_RECOMMENDATION,

  // Patient actions
  DO_ACTION,
  EDIT_ACTION,
  DELETE_ACTION,
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
