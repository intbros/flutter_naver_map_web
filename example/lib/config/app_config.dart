import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 앱 설정을 관리하는 클래스
class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._();
  
  AppConfig._();

  late Map<String, dynamic> _config;
  bool _isInitialized = false;

  /// 설정 파일을 로드합니다
  /// [environment]가 null이면 기본 설정 파일을 사용합니다
  Future<void> initialize({String? environment}) async {
    if (_isInitialized) return;
    
    String configPath = 'assets/config/app_config.json';
    
    // 환경별 설정 파일 사용
    if (environment != null) {
      configPath = 'assets/config/app_config.$environment.json';
    }
    
    try {
      final configString = await rootBundle.loadString(configPath);
      _config = json.decode(configString);
      _isInitialized = true;
    } catch (e) {
      // 환경별 파일이 없으면 기본 파일 사용
      if (environment != null) {
        final defaultConfigString = await rootBundle.loadString('assets/config/app_config.json');
        _config = json.decode(defaultConfigString);
        _isInitialized = true;
      } else {
        rethrow;
      }
    }
  }

  /// 네이버 맵 클라이언트 ID를 가져옵니다
  String get naverMapClientId {
    _checkInitialized();
    final clientId = _config['naver_map']?['client_id'] as String?;
    
    if (clientId == null || clientId.isEmpty || clientId == 'YOUR_NAVER_MAP_CLIENT_ID_HERE') {
      throw Exception(
        '네이버 맵 클라이언트 ID가 설정되지 않았습니다. '
        'assets/config/app_config.json 파일에서 client_id를 설정해주세요.'
      );
    }
    
    return clientId;
  }

  /// 앱 이름을 가져옵니다
  String get appName {
    _checkInitialized();
    return _config['app']?['name'] as String? ?? 'Flutter Naver Map Web Example';
  }

  /// 앱 버전을 가져옵니다
  String get appVersion {
    _checkInitialized();
    return _config['app']?['version'] as String? ?? '1.0.0';
  }

  /// 전체 설정을 가져옵니다
  Map<String, dynamic> get config {
    _checkInitialized();
    return Map<String, dynamic>.from(_config);
  }

  /// 특정 경로의 설정값을 가져옵니다
  /// 예: getValue('naver_map.client_id')
  T? getValue<T>(String path) {
    _checkInitialized();
    
    final keys = path.split('.');
    dynamic value = _config;
    
    for (final key in keys) {
      if (value is Map<String, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        return null;
      }
    }
    
    return value as T?;
  }

  /// 초기화 여부를 확인합니다
  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('AppConfig가 초기화되지 않았습니다. initialize()를 먼저 호출해주세요.');
    }
  }

  /// 디버그 정보를 출력합니다
  void printDebugInfo() {
    if (!_isInitialized) {
      debugPrint('AppConfig: 초기화되지 않음');
      return;
    }
    
    debugPrint('=== AppConfig Debug Info ===');
    debugPrint('App Name: $appName');
    debugPrint('App Version: $appVersion');
    debugPrint('Naver Map Client ID: ${naverMapClientId.substring(0, 5)}...');
    debugPrint('==========================');
  }
}

/// 환경별 설정을 관리하는 유틸리티 클래스
class Environment {
  static const String development = 'dev';
  static const String production = 'prod';
  static const String staging = 'staging';
  
  /// 현재 환경을 반환합니다
  /// dart-define으로 ENVIRONMENT 값을 설정할 수 있습니다
  static String get current {
    return const String.fromEnvironment('ENVIRONMENT', defaultValue: development);
  }
  
  /// 개발 환경인지 확인합니다
  static bool get isDevelopment => current == development;
  
  /// 프로덕션 환경인지 확인합니다
  static bool get isProduction => current == production;
  
  /// 스테이징 환경인지 확인합니다
  static bool get isStaging => current == staging;
}
