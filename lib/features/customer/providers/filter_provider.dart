import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

@riverpod
class ServiceTypeFilter extends _$ServiceTypeFilter {
  @override
  String? build() => null; // null = all

  void setFilter(String? type) => state = type;
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}
