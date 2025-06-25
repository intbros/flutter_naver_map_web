// Naver Maps JS Interop
import 'dart:js_interop';
import 'package:web/web.dart';

// 네이버 맵스 JS 객체에 대한 접근자
@JS()
@staticInterop
class NaverMapsJS {
  external static JSObject get maps;
}

/// LatLng 클래스 인터페이스
@JS('naver.maps.LatLng')
@staticInterop
class LatLng {
  external factory LatLng(double lat, double lng);
}

extension LatLngExtension on LatLng {
  @JS('lat')
  external double get lat;

  @JS('lng')
  external double get lng;

  @JS('toString')
  external String toMapString();
}

/// LatLngBounds 클래스 인터페이스
@JS('naver.maps.LatLngBounds')
@staticInterop
class LatLngBounds {
  external factory LatLngBounds(LatLng sw, LatLng ne);
}

/// Point 클래스 인터페이스
@JS('naver.maps.Point')
@staticInterop
class Point {
  external factory Point(int x, int y);
}

extension PointExtension on Point {
  @JS('x')
  external int get x;

  @JS('y')
  external int get y;
}

/// Size 클래스 인터페이스
@JS('naver.maps.Size')
@staticInterop
class Size {
  external factory Size(int width, int height);
}

extension SizeExtension on Size {
  @JS('width')
  external int get width;
  
  @JS('height')
  external int get height;
}

/// MapOptions 인터페이스
@JS()
@anonymous
@staticInterop
class MapOptions {
  external factory MapOptions({
    JSAny? center,
    int? zoom,
    JSAny? minZoom,
    JSAny? maxZoom,
    JSAny? mapTypes,
    String? mapTypeId,
    bool? zoomControl,
    JSAny? zoomControlOptions,
    bool? mapDataControl,
    JSAny? mapDataControlOptions,
    bool? scaleControl,
    JSAny? scaleControlOptions,
    bool? mapTypeControl,
    JSAny? mapTypeControlOptions,
    bool? logoControl,
    JSAny? logoControlOptions,
  });
}

/// Map 클래스 인터페이스
@JS('naver.maps.Map')
@staticInterop
class NaverMap {
  external factory NaverMap(HTMLElement element, [MapOptions? options]);
}

extension NaverMapExtension on NaverMap {
  @JS('setOptions')
  external void setOptions(MapOptions options);

  @JS('setCenter')
  external void setCenter(JSAny center);

  @JS('setZoom')
  external void setZoom(int zoom, [JSAny? options]);

  @JS('panTo')
  external void panTo(JSAny latLng, [JSAny? options]);

  @JS('panBy')
  external void panBy(JSAny point);

  @JS('panToBounds')
  external void panToBounds(JSAny bounds, [JSAny? options]);

  @JS('getCenter')
  external LatLng getCenter();

  @JS('getZoom')
  external int getZoom();

  @JS('getBounds')
  external LatLngBounds getBounds();

  @JS('fitBounds')
  external void fitBounds(JSAny bounds, [JSAny? options]);
}

/// Marker 클래스 인터페이스
@JS('naver.maps.Marker')
@staticInterop
class Marker {
  external factory Marker(JSAny options);
}

extension MarkerExtension on Marker {
  @JS('setMap')
  external void setMap(JSAny? map);

  @JS('getMap')
  external NaverMap? getMap();

  @JS('setPosition')
  external void setPosition(JSAny position);

  @JS('getPosition')
  external LatLng getPosition();

  @JS('setVisible')
  external void setVisible(bool visible);

  @JS('getVisible')
  external bool getVisible();
  
  /// JSAny로 캐스팅하기 위한 헬퍼 메서드
  JSAny get asJSAny => this as JSAny;
}

/// InfoWindow 클래스 인터페이스
@JS('naver.maps.InfoWindow')
@staticInterop
class InfoWindow {
  external factory InfoWindow(JSAny options);
}

extension InfoWindowExtension on InfoWindow {
  @JS('open')
  external void open(NaverMap map, [JSAny? anchor]);

  @JS('close')
  external void close();

  @JS('setContent')
  external void setContent(String content);

  @JS('setPosition')
  external void setPosition(JSAny position);
}

/// Polyline 클래스 인터페이스
@JS('naver.maps.Polyline')
@staticInterop
class Polyline {
  external factory Polyline(JSAny options);
}

/// Circle 클래스 인터페이스
@JS('naver.maps.Circle')
@staticInterop
class Circle {
  external factory Circle(JSAny options);
}

/// Polygon 클래스 인터페이스
@JS('naver.maps.Polygon')
@staticInterop
class Polygon {
  external factory Polygon(JSAny options);
}
