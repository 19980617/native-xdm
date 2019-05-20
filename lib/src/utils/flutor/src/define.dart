import 'package:flutter/material.dart';

class RouterOption {
  RouterOption({
    @required this.path,
    this.widget,
    this.name,
    this.beforeEnter,
    this.beforeLeave,
    this.children,
    this.transition,
    this.transitionsBuilder,
    this.transitionDuration,
  }) : assert(path != null);

  final String path;
  final String name;
  final WidgetHandle widget;
  final FutureHookHandle beforeEnter;
  final FutureHookHandle beforeLeave;
  final List<RouterOption> children;
  final RouterTranstion transition;
  final RouteTransitionsBuilder transitionsBuilder;
  final  Duration transitionDuration;

  String regexp;
  List<String> paramName = [];

  RouterOption.fromMap(Map<String, dynamic> route)
    : assert(route['path'] != null),
      path = route['path'],
      widget = route['widget'],
      name = route['name'],
      beforeEnter = route['beforeEnter'],
      beforeLeave = route['beforeLeave'],
      children = route['children'],
      transition = route['transition'],
      transitionsBuilder = route['transitionsBuilder'],
      transitionDuration = route['transitionDuration'],
      regexp = route['regexp'],
      paramName = route['paramName'];

  String getChildrenStr() {
    String childStr = '';
    if (children != null) {
      childStr = ', children: [';
      for (var child in children) {
        childStr += child.toString();
      }
      childStr += ']';
    }
    return childStr;
  }

  @override
  String toString() => '{path: $path, name: $name, regexp: $regexp${getChildrenStr()}}';
}

/// Future路由钩子
typedef Future FutureHookHandle<T>(RouterNode to, RouterNode from);

/// void路由钩子
typedef void VoidHookHandle<T>(RouterNode to, RouterNode from);

/// 路由配置函数
typedef Widget WidgetHandle<T>({ Map<String, dynamic>params, Map<String, dynamic>query });

/// 错误处理函数
typedef void ExceptionHandle<T>(FlutorException error);

enum RouterTranstion {
  auto,
  none,
  slideRight,
  slideLeft,
  slideBottom,
  fadeIn,
  custom,
}

class FlutorException implements Exception {
  const FlutorException([this.msg]);
  final String msg;

  String toString() => msg ?? 'FlutorException';
}


class MatchedRoute {
  MatchedRoute(this.route, { params, query }): params=params??{}, query=query??{};
  final RouterOption route;
  Map<String, dynamic> params;
  Map<String, dynamic> query;

  @override
  String toString() => '{route: $route, params: $params, query: $query}';
}

class RouterNode {
  RouterNode(this.route, [this.flutorRoute]) {
    if (route != null) {
      path = route.settings.name;
      params = flutorRoute?.params;
      query = flutorRoute?.query;
    }
  }
  final Route route;
  final MatchedRoute flutorRoute;
  String path;
  Map<String, dynamic> params;
  Map<String, dynamic> query;

  @override
  String toString() => '{path: $path, params: $params, query: $query}';
}