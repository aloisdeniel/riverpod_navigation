import 'package:equatable/equatable.dart';

abstract class PathSegmentTemplate extends Equatable {
  const PathSegmentTemplate();

  factory PathSegmentTemplate.parse(String value) {
    if (value.startsWith(DynamicPathSegmentTemplate.prefix)) {
      return DynamicPathSegmentTemplate(
          value.substring(DynamicPathSegmentTemplate.prefix.length));
    }

    return StaticPathSegmentTemplate(value);
  }
}

class StaticPathSegmentTemplate extends PathSegmentTemplate {
  const StaticPathSegmentTemplate(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

class DynamicPathSegmentTemplate extends PathSegmentTemplate {
  const DynamicPathSegmentTemplate(this.name);
  final String name;

  static const prefix = ':';

  @override
  List<Object?> get props => [name];
}
