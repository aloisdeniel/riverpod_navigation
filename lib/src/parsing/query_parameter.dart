import 'package:equatable/equatable.dart';

class QueryParameterTemplate extends Equatable {
  const QueryParameterTemplate({
    required this.name,
  });

  factory QueryParameterTemplate.parse(String value) {
    return QueryParameterTemplate(
      name: value,
    );
  }

  final String name;

  @override
  List<Object?> get props => [name];
}
