import 'package:flutter_tagging/flutter_tagging.dart';

class EventTag extends Taggable {
  final String tag;

  EventTag({this.tag});

  @override
  List<Object> get props => [tag];
}
