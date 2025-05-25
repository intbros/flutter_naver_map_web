import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;
// ignore: unused_import
import 'dart:js_interop';
import 'dart:ui_web';

/// 네이버 맵 플러그인 등록 클래스
class NaverMapPlugin {
  /// 등록된 뷰 팩토리 ID들을 저장하는 Set
  static final Set<String> _registeredViewIds = <String>{};
  
  static void registerWith(Registrar registrar) {
    if (kIsWeb) {
      debugPrint('NaverMapPlugin 등록 완료');
    }
  }

  /// 네이버 맵 뷰 팩토리 등록
  /// [viewId] - 고유한 뷰 ID
  /// 반환값: 생성된 HTML 요소
  static web.HTMLElement registerMapViewFactory(String viewId) {
    if (_registeredViewIds.contains(viewId)) {
      debugPrint('View factory already registered for ID: $viewId');
      // 이미 등록된 경우 기존 요소 반환
      final existingElement = web.document.getElementById(viewId);
      if (existingElement != null) {
        return existingElement as web.HTMLElement;
      }
    }

    debugPrint('Registering view factory with ID: $viewId');
    
    // 단순한 div 생성 (ID를 viewId와 일치시킴)
    final container = web.document.createElement('div') as web.HTMLDivElement
      ..id = viewId
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'relative';  // 지도가 제대로 렌더링되도록 position 설정

    try {
      // platformViewRegistry에 등록
      platformViewRegistry.registerViewFactory(
        viewId, 
        (int viewId) => container
      );
      
      // 등록된 뷰 ID 저장
      _registeredViewIds.add(viewId);
      
      debugPrint('View factory registered successfully for ID: $viewId');
      return container;
    } catch (e) {
      debugPrint('Error registering view factory for ID $viewId: $e');
      rethrow;
    }
  }

  /// 뷰 팩토리 등록 해제
  /// [viewId] - 해제할 뷰 ID
  static void unregisterMapViewFactory(String viewId) {
    if (_registeredViewIds.contains(viewId)) {
      _registeredViewIds.remove(viewId);
      debugPrint('View factory unregistered for ID: $viewId');
    }
  }

  /// 등록된 모든 뷰 팩토리 ID 목록 반환
  static List<String> getRegisteredViewIds() {
    return _registeredViewIds.toList();
  }

  /// 특정 뷰 ID가 등록되어 있는지 확인
  static bool isViewFactoryRegistered(String viewId) {
    return _registeredViewIds.contains(viewId);
  }
}
