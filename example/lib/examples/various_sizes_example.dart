import 'package:flutter/material.dart';
import 'package:flutter_naver_map_web/flutter_naver_map_web.dart';
import '../config/app_config.dart';

/// 다양한 크기의 NaverMapView 위젯을 배치하는 예제
class VariousSizesExample extends StatefulWidget {
  const VariousSizesExample({super.key});

  @override
  State<VariousSizesExample> createState() => _VariousSizesExampleState();
}

class _VariousSizesExampleState extends State<VariousSizesExample> {
  // 각 지도의 중심 좌표
  final Map<String, Map<String, dynamic>> mapLocations = {
    'seoul': {
      'name': '서울',
      'lat': 37.5666103,
      'lng': 126.9783882,
      'zoom': 13,
    },
    'busan': {
      'name': '부산',
      'lat': 35.1796,
      'lng': 129.0756,
      'zoom': 13,
    },
    'jeju': {
      'name': '제주도',
      'lat': 33.4996,
      'lng': 126.5312,
      'zoom': 11,
    },
    'incheon': {
      'name': '인천',
      'lat': 37.4563,
      'lng': 126.7052,
      'zoom': 12,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다양한 크기의 지도 위젯'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 작은 지도 (정사각형)
            _buildSectionTitle('1. 작은 지도 (200×200)'),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NaverMapWeb(
                  clientId: AppConfig.instance.naverMapClientId,
                  initialLatitude: mapLocations['seoul']!['lat'],
                  initialLongitude: mapLocations['seoul']!['lng'],
                  initialZoom: mapLocations['seoul']!['zoom'],
                  zoomControl: false,
                  mapDataControl: false,
                  onMapReady: (map) => debugPrint('작은 지도 준비 완료'),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. 중간 크기 지도 (카드 형태)
            _buildSectionTitle('2. 중간 크기 지도 (카드 형태)'),
            Card(
              elevation: 4,
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      color: Colors.purple.shade50,
                      child: Text(
                        '부산 지역',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: NaverMapWeb(
                        clientId: AppConfig.instance.naverMapClientId,
                        initialLatitude: mapLocations['busan']!['lat'],
                        initialLongitude: mapLocations['busan']!['lng'],
                        initialZoom: mapLocations['busan']!['zoom'],
                        zoomControl: true,
                        mapDataControl: false,
                        onMapReady: (map) => debugPrint('부산 지도 준비 완료'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 3. 와이드 지도 (16:9 비율)
            _buildSectionTitle('3. 와이드 지도 (16:9 비율)'),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NaverMapWeb(
                  clientId: AppConfig.instance.naverMapClientId,
                  initialLatitude: mapLocations['jeju']!['lat'],
                  initialLongitude: mapLocations['jeju']!['lng'],
                  initialZoom: mapLocations['jeju']!['zoom'],
                  zoomControl: true,
                  mapDataControl: true,
                  onMapReady: (map) => debugPrint('제주도 지도 준비 완료'),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 4. 격자 배치 (2×2)
            _buildSectionTitle('4. 격자 배치 (2×2)'),
            SizedBox(
              height: 400,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: mapLocations.entries.map((entry) {
                  final location = entry.value;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            location['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: NaverMapWeb(
                              clientId: AppConfig.instance.naverMapClientId,
                              initialLatitude: location['lat'],
                              initialLongitude: location['lng'],
                              initialZoom: location['zoom'],
                              zoomControl: false,
                              mapDataControl: false,
                              onMapReady: (map) => debugPrint('${location['name']} 지도 준비 완료'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),

            // 5. 플렉서블 레이아웃
            _buildSectionTitle('5. 플렉서블 레이아웃'),
            Row(
              children: [
                // 왼쪽 - 큰 지도
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: NaverMapWeb(
                        clientId: AppConfig.instance.naverMapClientId,
                        initialLatitude: mapLocations['seoul']!['lat'],
                        initialLongitude: mapLocations['seoul']!['lng'],
                        initialZoom: mapLocations['seoul']!['zoom'],
                        zoomControl: true,
                        mapDataControl: true,
                        onMapReady: (map) => debugPrint('메인 지도 준비 완료'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 오른쪽 - 작은 지도들
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 146,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: NaverMapWeb(
                            clientId: AppConfig.instance.naverMapClientId,
                            initialLatitude: mapLocations['busan']!['lat'],
                            initialLongitude: mapLocations['busan']!['lng'],
                            initialZoom: mapLocations['busan']!['zoom'],
                            zoomControl: false,
                            mapDataControl: false,
                            onMapReady: (map) => debugPrint('서브 지도 1 준비 완료'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 146,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: NaverMapWeb(
                            clientId: AppConfig.instance.naverMapClientId,
                            initialLatitude: mapLocations['jeju']!['lat'],
                            initialLongitude: mapLocations['jeju']!['lng'],
                            initialZoom: mapLocations['jeju']!['zoom'],
                            zoomControl: false,
                            mapDataControl: false,
                            onMapReady: (map) => debugPrint('서브 지도 2 준비 완료'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }
}

/// 이 예제를 실행하는 앱
class VariousSizesApp extends StatelessWidget {
  const VariousSizesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '다양한 크기 지도 예제',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const VariousSizesExample(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // AppConfig 초기화
  await AppConfig.instance.initialize(environment: Environment.current);
  
  runApp(const VariousSizesApp());
}
