import 'package:equatable/equatable.dart';
import 'package:riverpod_navigation/src/parsing/template.dart';

abstract class TemplateMatch extends Equatable {
  const TemplateMatch();

  bool get isSuccess => this is SuccessTemplateMatch;

  factory TemplateMatch.failed() => const FailedRouteMatch();

  const factory TemplateMatch.success({
    required UriTemplate template,
    required Map<String, String> parameters,
  }) = SuccessTemplateMatch;
}

class FailedRouteMatch extends TemplateMatch {
  const FailedRouteMatch();

  @override
  List<Object?> get props => [];
}

class SuccessTemplateMatch extends TemplateMatch {
  const SuccessTemplateMatch({
    required this.template,
    required this.parameters,
  });
  final UriTemplate template;
  final Map<String, String> parameters;

  String? get(String key) => parameters[key];

  @override
  List<Object?> get props => [
        template,
        parameters,
      ];
}
