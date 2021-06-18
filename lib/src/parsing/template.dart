import 'package:equatable/equatable.dart';
import 'package:riverpod_navigation/src/parsing/query_parameter.dart';
import 'package:riverpod_navigation/src/parsing/path_segment.dart';

import 'match.dart';

class UriTemplate extends Equatable {
  const UriTemplate({
    required this.pathSegments,
    required this.queryParameters,
  });

  factory UriTemplate.parse(String value) {
    assert(value.isNotEmpty);
    final uriSplit = value.split('?');
    final segmentSplit =
        uriSplit.first.split('/').where((x) => x.isNotEmpty).toList();
    final querySplit =
        uriSplit.length > 1 ? uriSplit.last.split('&') : const <String>[];
    return UriTemplate(
      pathSegments: [
        ...segmentSplit.map(
          (x) => PathSegmentTemplate.parse(x),
        ),
      ],
      queryParameters: [
        ...querySplit.map(
          (x) => QueryParameterTemplate.parse(x),
        ),
      ],
    );
  }
  final List<PathSegmentTemplate> pathSegments;
  final List<QueryParameterTemplate> queryParameters;

  UriTemplate operator +(UriTemplate other) {
    return UriTemplate(
      pathSegments: [
        ...pathSegments,
        ...other.pathSegments,
      ],
      queryParameters: other.queryParameters,
    );
  }

  TemplateMatch match(Uri uri) {
    if (uri.pathSegments.length != pathSegments.length) {
      return TemplateMatch.failed();
    }
    final parameters = <String, String>{};
    for (var i = 0; i < pathSegments.length; i++) {
      final segment = uri.pathSegments[i];
      final segmentTemplate = pathSegments[i];
      if (segmentTemplate is StaticPathSegmentTemplate) {
        if (segment != segmentTemplate.value) {
          return TemplateMatch.failed();
        }
      } else if (segmentTemplate is DynamicPathSegmentTemplate) {
        parameters[segmentTemplate.name] = segment;
      }
    }

    for (var queryTemplate in queryParameters) {
      final value = uri.queryParameters[queryTemplate.name];
      if (value != null) {
        parameters[queryTemplate.name] = value;
      }
    }

    return TemplateMatch.success(
      template: this,
      parameters: parameters,
    );
  }

  Uri buildUri(
    Map<String, String> parameters, {
    bool withQueryString = true,
  }) {
    final path = '/' +
        ([
          ...pathSegments.map((segment) {
            if (segment is StaticPathSegmentTemplate) {
              return segment.value;
            }

            if (segment is DynamicPathSegmentTemplate) {
              final value = parameters[segment.name];
              if (value == null)
                throw Exception(
                    'Missing segment path parameter "${segment.name}"');
              return value;
            }

            throw Exception('Unsupported segment type');
          }),
        ]).join('/');

    final queryArguments = <String>[];
    if (withQueryString) {
      for (var queryParam in queryParameters) {
        final value = parameters[queryParam.name];
        if (value != null) {
          queryArguments.add('${queryParam.name}=$value');
        }
      }
    }
    final queryString =
        (queryArguments.isNotEmpty ? '?${queryArguments.join('&')}' : '');
    return Uri.parse(path + queryString);
  }

  @override
  List<Object?> get props => [
        pathSegments,
        queryParameters,
      ];
}
