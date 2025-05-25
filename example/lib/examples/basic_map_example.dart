import 'package:flutter/material.dart';
import 'package:flutter_naver_map_web/flutter_naver_map_web.dart';
import '../config/app_config.dart';

/// 기본 지도만 표시하는 가장 간단한 예제
class BasicMapExample extends StatelessWidget {
  const BasicMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기본 지도 보기'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: NaverMapWeb(
        clientId: AppConfig.instance.naverMapClientId,
        initialLatitude: 37.5666103,  // 서울시청 위도
        initialLongitude: 126.9783882, // 서울시청 경도
        initialZoom: 13,
        zoomControl: true,
        mapDataControl: true,
      ),
    );
  }
}

/// 이 예제를 실행하는 앱
class BasicMapApp extends StatelessWidget {
  const BasicMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기본 지도 예제',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BasicMapExample(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // AppConfig 초기화
  await AppConfig.instance.initialize(environment: Environment.current);
  
  // 디버그 정보 출력
  AppConfig.instance.printDebugInfo();
  
  runApp(const BasicMapApp());
}
