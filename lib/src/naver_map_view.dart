import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe' as unsafe;
import 'naver_maps_js_interop.dart';
import 'naver_map_plugin.dart';
import 'models/place.dart';

/// Naver 맵 위젯
class NaverMapWeb extends StatefulWidget {
  /// 네이버 클라우드 플랫폼 클라이언트 ID
  final String clientId;
  
  /// 초기 위도
  final double initialLatitude;
  
  /// 초기 경도
  final double initialLongitude;
  
  /// 초기 줌 레벨
  final int initialZoom;
  
  /// 줌 컨트롤 표시 여부
  final bool zoomControl;
  
  /// 지도 데이터 컨트롤 표시 여부
  final bool mapDataControl;
  
  /// 지도가 로드되었을 때 콜백
  final Function(NaverMap)? onMapReady;
  
  /// 표시할 장소들
  final List<Place> places;
  
  /// 마커 클릭 콜백
  final Function(Place)? onMarkerClick;
  
  /// 선택된 장소 ID
  final String? selectedPlaceId;
  
  /// 마커 사이즈
  final Size? markerSize;
  
  /// 선택된 마커 사이즈
  final Size? selectedMarkerSize;

  const NaverMapWeb({
    super.key,
    required this.clientId,
    this.initialLatitude = 37.5666103,
    this.initialLongitude = 126.9783882,
    this.initialZoom = 15,
    this.zoomControl = true,
    this.mapDataControl = true,
    this.onMapReady,
    this.places = const [],
    this.onMarkerClick,
    this.selectedPlaceId,
    this.markerSize,
    this.selectedMarkerSize,
  });

  @override
  State<NaverMapWeb> createState() => _NaverMapWebState();
}

class _NaverMapWebState extends State<NaverMapWeb> {
  /// 네이버 맵 객체
  NaverMap? _naverMap;
  
  /// 마커 맵 (장소 ID -> 마커)
  final Map<String, Marker> _markers = {};
  
  /// 정보창 맵 (장소 ID -> 정보창)
  final Map<String, InfoWindow> _infoWindows = {};
  
  /// DOM 요소
  web.HTMLElement? _mapElement;
  
  /// 스크립트 로드 완료 여부
  bool _isScriptLoaded = false;
  
  /// 지도 초기화 완료 여부
  bool _isMapInitialized = false;
  
  /// 고유한 뷰 ID
  late String _viewId;

  /// 기본 마커 사이즈
  Size get defaultMarkerSize => widget.markerSize ?? Size(30, 40);
  
  /// 기본 선택된 마커 사이즈
  Size get defaultSelectedMarkerSize => widget.selectedMarkerSize ?? Size(40, 50);

  @override
  void initState() {
    super.initState();
    // 고유한 뷰 ID 생성
    _viewId = 'naver-map-${DateTime.now().millisecondsSinceEpoch}';
    
    // 웹 환경에서만 작동하도록 함
    if (kIsWeb) {
      // 뷰 팩토리 등록 (NaverMapPlugin을 통해)
      NaverMapPlugin.registerMapViewFactory(_viewId);
      // 다음 프레임에서 Naver Maps API 로드
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadNaverMapsScript());
    }
  }

  @override
  void didUpdateWidget(NaverMapWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 중심 좌표 변경
    if (widget.initialLatitude != oldWidget.initialLatitude || 
        widget.initialLongitude != oldWidget.initialLongitude) {
      _updateMapCenter();
    }

    // 장소 목록 변경
    if (!listEquals(widget.places, oldWidget.places)) {
      _updateMarkers();
    }
    
    // 선택된 장소 변경
    if (widget.selectedPlaceId != oldWidget.selectedPlaceId) {
      _updateSelectedMarker(oldWidget.selectedPlaceId);
    }

    // 컨트롤 변경
    if (widget.zoomControl != oldWidget.zoomControl || 
        widget.mapDataControl != oldWidget.mapDataControl) {
      _updateMapControls();
    }
  }

  @override
  void dispose() {
    // 모든 마커 제거
    _clearAllMarkers();
    // 모든 정보창 제거
    _clearAllInfoWindows();
    // 뷰 팩토리 등록 해제
    NaverMapPlugin.unregisterMapViewFactory(_viewId);
    super.dispose();
  }

  /// Naver Maps API 스크립트 로드
  void _loadNaverMapsScript() async {
    // 이미 로드된 경우 지도 초기화만 수행
    if (_isScriptLoaded) {
      _waitForElementAndInitialize();
      return;
    }
    
    // 기존에 로드된 스크립트가 있는지 확인
    final existingScript = web.document.querySelector('script[src*="maps.js"]');
    if (existingScript != null) {
      debugPrint('Naver Maps API already loaded');
      _isScriptLoaded = true;
      _waitForElementAndInitialize();
      return;
    }
    
    try {
      // Naver Maps API URL 생성
      final scriptUrl = 'https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${widget.clientId}';
      
      // 새로운 스크립트 태그 생성
      final script = web.document.createElement('script') as web.HTMLScriptElement;
      script.type = 'text/javascript';
      script.src = scriptUrl;
      script.async = true;
      
      // 스크립트 로드 완료 이벤트 등록
      script.onload = (web.Event event) {
        _isScriptLoaded = true;
        debugPrint('Naver Maps API 스크립트 로드 완료');
        // DOM 요소가 준비될 때까지 기다린 후 지도 초기화
        _waitForElementAndInitialize();
      }.toJS;
      
      // 스크립트 로드 오류 이벤트 등록
      script.onerror = (web.Event event) {
        debugPrint('Naver Maps API 스크립트 로드 실패: $event');
      }.toJS;
      
      // DOM에 스크립트 태그 추가
      web.document.head!.appendChild(script);
      
    } catch (e) {
      debugPrint('Naver Maps API 스크립트 로드 중 오류 발생: $e');
    }
  }

  /// DOM 요소가 준비될 때까지 기다린 후 지도 초기화
  void _waitForElementAndInitialize() async {
    debugPrint('Waiting for DOM element: $_viewId');
    
    // DOM 요소가 준비될 때까지 대기
    for (int i = 0; i < 50; i++) { // 최대 5초 대기
      await Future.delayed(const Duration(milliseconds: 100));
      
      final element = web.document.getElementById(_viewId);
      if (element != null) {
        _mapElement = element as web.HTMLElement;
        debugPrint('DOM 요소 발견: $_viewId');
        
        // 요소 크기 확인
        final rect = element.getBoundingClientRect();
        debugPrint('Element dimensions: ${rect.width} x ${rect.height}');
        
        // 크기가 0이 아닌 경우에만 초기화
        if (rect.width > 0 && rect.height > 0) {
          _initializeMap();
          return;
        } else {
          debugPrint('Element has no size yet, waiting...');
        }
      }
    }
    
    debugPrint('DOM 요소를 찾을 수 없습니다: $_viewId');
  }

  /// 지도 초기화
  void _initializeMap() async {
    if (_mapElement == null) return;
    
    try {
      debugPrint('지도 초기화 시작...');
      
      // naver.maps 객체가 로드되었는지 확인  
      bool naverMapsLoaded;
      try {
        final globalThis = globalContext;
        final naver = globalThis['naver'] as JSObject?;
        naverMapsLoaded = naver != null && naver['maps'] != null;
      } catch (e) {
        naverMapsLoaded = false;
      }
      
      if (!naverMapsLoaded) {
        debugPrint('naver.maps 객체가 아직 로드되지 않았습니다. 재시도 중...');
        await Future.delayed(const Duration(milliseconds: 500));
        _initializeMap();
        return;
      }
      
      // 초기 위치 설정
      final center = LatLng(widget.initialLatitude, widget.initialLongitude);
      
      // 맵 옵션 설정
      final options = MapOptions(
        center: center as JSAny,
        zoom: widget.initialZoom,
        zoomControl: widget.zoomControl,
        mapDataControl: widget.mapDataControl,
      );
      
      // 네이버 맵 생성
      if(_isMapInitialized) {
        _naverMap!.setOptions(options);
      } else {
        _naverMap = NaverMap(_mapElement!, options);
        _isMapInitialized = true;
      }
      
      debugPrint('네이버 맵 생성 완료');
      
      if (mounted) {
        setState(() {});
      }
      
      // 마커들 추가
      _updateMarkers();
      
      // 콜백 호출
      if (widget.onMapReady != null) {
        widget.onMapReady!(_naverMap!);
      }
    } catch (e) {
      debugPrint('Error initializing Naver Map: $e');
      debugPrint('Error details: ${e.toString()}');
    }
  }

  /// 맵 중심 업데이트
  void _updateMapCenter() {
    if (_naverMap == null) return;
    
    try {
      final center = LatLng(widget.initialLatitude, widget.initialLongitude);
      _naverMap!.setCenter(center as JSAny);
    } catch (e) {
      debugPrint('Error updating map center: $e');
    }
  }

  /// 맵 컨트롤 업데이트
  void _updateMapControls() {
    if (_naverMap == null) return;
    
    try {
      final options = MapOptions(
        zoomControl: widget.zoomControl,
        mapDataControl: widget.mapDataControl,
      );
      _naverMap!.setOptions(options);
    } catch (e) {
      debugPrint('Error updating map controls: $e');
    }
  }

  /// 마커들 업데이트
  void _updateMarkers() {
    if (_naverMap == null) return;
    
    // 기존 마커들 중 없어진 것들 제거
    final currentPlaceIds = widget.places.map((p) => p.id).toSet();
    final markersToRemove = _markers.keys.where((id) => !currentPlaceIds.contains(id)).toList();
    
    for (final id in markersToRemove) {
      _removeMarker(id);
    }
    
    // 새로운 마커 추가 또는 업데이트
    for (final place in widget.places) {
      if (_markers.containsKey(place.id)) {
        // 기존 마커 업데이트
        _updateMarker(place);
      } else {
        // 새 마커 추가
        _addMarker(place);
      }
    }
  }

  /// 마커 추가
  void _addMarker(Place place) {
    try {
      final isSelected = place.id == widget.selectedPlaceId;
      final size = isSelected ? defaultSelectedMarkerSize : defaultMarkerSize;
      
      // 마커 옵션 설정
      final markerOptions = {
        'position': LatLng(place.latitude, place.longitude) as JSAny,
        'map': _naverMap as JSAny,
        'title': place.name,
        'icon': place.iconUrl != null ? {
          'url': place.iconUrl,
          'size': {'width': size.width, 'height': size.height},
          'scaledSize': {'width': size.width, 'height': size.height},
        } : null,
      }.jsify() as JSAny;
      
      // 마커 생성
      final marker = Marker(markerOptions);
      _markers[place.id] = marker;
      
      // 정보창 추가
      if (place.description != null) {
        _addInfoWindow(place);
      }
      
      // 클릭 이벤트 추가 (추후 구현)
      if (widget.onMarkerClick != null) {
        debugPrint('마커 클릭 이벤트 설정 예정: ${place.name}');
      }
      
      debugPrint('마커 추가 완료: ${place.name}');
    } catch (e) {
      debugPrint('Error adding marker: $e');
    }
  }

  /// 마커 업데이트
  void _updateMarker(Place place) {
    final marker = _markers[place.id];
    if (marker == null) return;
    
    try {
      // 위치 업데이트
      marker.setPosition(LatLng(place.latitude, place.longitude) as JSAny);
      
      // 선택 상태에 따른 아이콘 크기 변경
     // final isSelected = place.id == widget.selectedPlaceId;
     // final size = isSelected ? defaultSelectedMarkerSize : defaultMarkerSize;
      
      if (place.iconUrl != null) {
        // 아이콘 설정 기능은 추후 구현
        // 현재는 기본 마커만 표시
        debugPrint('마커 아이콘 설정: ${place.iconUrl}');
      }
    } catch (e) {
      debugPrint('Error updating marker: $e');
    }
  }

  /// 마커 제거
  void _removeMarker(String placeId) {
    final marker = _markers[placeId];
    if (marker != null) {
      marker.setMap(null);
      _markers.remove(placeId);
    }
    
    // 정보창도 제거
    _removeInfoWindow(placeId);
  }

  /// 정보창 추가
  void _addInfoWindow(Place place) {
    try {
      final content = '''
        <div style="padding: 10px; min-width: 150px;">
          <h4 style="margin: 0 0 5px 0;">${place.name}</h4>
          ${place.category != null ? '<p style="margin: 0 0 5px 0; font-size: 12px; color: #666;">${place.category}</p>' : ''}
          ${place.description != null ? '<p style="margin: 0; font-size: 14px;">${place.description}</p>' : ''}
        </div>
      ''';
      
      final infoWindowOptions = {
        'content': content,
        'maxWidth': 300,
        'backgroundColor': '#fff',
        'borderColor': '#ddd',
        'borderWidth': 1,
        'anchorSize': {'width': 10, 'height': 10},
        'anchorSkew': true,
        'anchorColor': '#fff',
        'pixelOffset': 0
      }.jsify() as JSAny;
      
      final infoWindow = InfoWindow(infoWindowOptions);
      _infoWindows[place.id] = infoWindow;
      
      // 마커 클릭 시 정보창 열기
      final marker = _markers[place.id];
      if (marker != null) {
        // 정보창 클릭 이벤트 기능은 추후 구현
        // 현재는 정보창 객체만 생성
        debugPrint('정보창 이벤트 설정 완료: ${place.name}');
      }
    } catch (e) {
      debugPrint('Error adding info window: $e');
    }
  }

  /// 정보창 제거
  void _removeInfoWindow(String placeId) {
    final infoWindow = _infoWindows[placeId];
    if (infoWindow != null) {
      infoWindow.close();
      _infoWindows.remove(placeId);
    }
  }

  /// 선택된 마커 업데이트
  void _updateSelectedMarker(String? oldSelectedId) {
    // 이전 선택 마커 크기 원복
    if (oldSelectedId != null) {
      final oldPlace = widget.places.firstWhere(
        (p) => p.id == oldSelectedId,
        orElse: () => widget.places.first,
      );
      _updateMarker(oldPlace);
    }
    
    // 새로 선택된 마커 크기 변경
    if (widget.selectedPlaceId != null) {
      final newPlace = widget.places.firstWhere(
        (p) => p.id == widget.selectedPlaceId,
        orElse: () => widget.places.first,
      );
      _updateMarker(newPlace);
      
      // 선택된 마커로 중심 이동
      _naverMap?.setCenter(LatLng(newPlace.latitude, newPlace.longitude) as JSAny);
    }
  }

  /// 모든 마커 제거
  void _clearAllMarkers() {
    for (final marker in _markers.values) {
      marker.setMap(null);
    }
    _markers.clear();
  }

  /// 모든 정보창 제거
  void _clearAllInfoWindows() {
    for (final infoWindow in _infoWindows.values) {
      infoWindow.close();
    }
    _infoWindows.clear();
  }

  /// 지도 범위를 모든 마커가 보이도록 조정
  void fitBounds() {
    if (_naverMap == null || widget.places.isEmpty) return;
    
    try {
      // bounds 계산
      double minLat = widget.places.first.latitude;
      double maxLat = widget.places.first.latitude;
      double minLng = widget.places.first.longitude;
      double maxLng = widget.places.first.longitude;
      
      for (final place in widget.places) {
        minLat = minLat > place.latitude ? place.latitude : minLat;
        maxLat = maxLat < place.latitude ? place.latitude : maxLat;
        minLng = minLng > place.longitude ? place.longitude : minLng;
        maxLng = maxLng < place.longitude ? place.longitude : maxLng;
      }
      
      final sw = LatLng(minLat, minLng);
      final ne = LatLng(maxLat, maxLng);
      final bounds = LatLngBounds(sw, ne);
      
      _naverMap!.fitBounds(bounds as JSAny);
    } catch (e) {
      debugPrint('Error fitting bounds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(
        child: Text('NaverMapView는 웹 환경에서만 지원됩니다.')
      );
    }

    return HtmlElementView(
      viewType: _viewId,
    );
  }
}