import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Activity<T> extends Equatable {
  final Map<String, String> informations;
  final String type;
  final T value;
  final Function onClick;

  Activity(
      {@required this.informations,
      @required this.type,
      @required this.value,
      @required this.onClick});

  @override
  List<Object> get props => [informations, type, value, onClick];
}
