import 'package:flutter/material.dart';
import 'package:flutter_naver_map_web/flutter_naver_map_web.dart';
import '../config/app_config.dart';

/// 여러 마커를 표시하는 예제
class MultipleMarkersExample extends StatefulWidget {
  const MultipleMarkersExample({super.key});

  @override
  State<MultipleMarkersExample> createState() => _MultipleMarkersExampleState();
}

class _MultipleMarkersExampleState extends State<MultipleMarkersExample> {
  String? selectedPlaceId;

  // 서울의 주요 관광지들
  final List<Place> places = [
    const Place(
      id: 'seoul_city_hall',
      name: '서울시청',
      latitude: 37.5666103,
      longitude: 126.9783882,
      description: '서울특별시의 행정 중심지',
    ),
    const Place(
      id: 'gyeongbokgung',
      name: '경복궁',
      latitude: 37.5796212,
      longitude: 126.9770162,
      description: '조선시대 정궁',
    ),
    const Place(
      id: 'namsan_tower',
      name: 'N서울타워',
      latitude: 37.5511694,
      longitude: 126.9882266,
      description: '서울의 랜드마크',
    ),
    const Place(
      id: 'myeongdong',
      name: '명동성당',
      latitude: 37.5633824,
      longitude: 126.9874696,
      description: '한국 천주교의 중심',
    ),
    const Place(
      id: 'dongdaemun',
      name: '동대문 디자인 플라자',
      latitude: 37.5673828,
      longitude: 127.0093845,
      description: '현대적 디자인 복합공간',
    ),
  ];

  void onMarkerClick(Place place) {
    setState(() {
      selectedPlaceId = place.id;
    });
    
    // 스낵바로 선택된 마커 정보 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${place.name} 마커를 클릭했습니다!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여러 마커 표시'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 선택된 장소 정보 표시
          if (selectedPlaceId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택된 장소: ${places.firstWhere((p) => p.id == selectedPlaceId).name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    places.firstWhere((p) => p.id == selectedPlaceId).description ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          // 지도
          Expanded(
            child: NaverMapWeb(
              clientId: AppConfig.instance.naverMapClientId,
              initialLatitude: 37.5666103,  // 서울시청 중심
              initialLongitude: 126.9783882,
              initialZoom: 14,
              zoomControl: true,
              mapDataControl: true,
              places: places,
              selectedPlaceId: selectedPlaceId,
              onMarkerClick: onMarkerClick,
              onMapReady: (map) {
                debugPrint('지도가 준비되었습니다 - 총 ${places.length}개의 마커가 표시됩니다');
              },
            ),
          ),
        ],
      ),
      // 마커 목록을 보여주는 플로팅 액션 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '마커 목록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...places.map((place) => ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: selectedPlaceId == place.id 
                        ? Colors.red 
                        : Colors.grey,
                    ),
                    title: Text(place.name),
                    subtitle: Text(place.description ?? ''),
                    onTap: () {
                      setState(() {
                        selectedPlaceId = place.id;
                      });
                      Navigator.pop(context);
                    },
                  )),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.list, color: Colors.white),
      ),
    );
  }
}

/// 이 예제를 실행하는 앱
class MultipleMarkersApp extends StatelessWidget {
  const MultipleMarkersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '여러 마커 예제',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const MultipleMarkersExample(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // AppConfig 초기화
  await AppConfig.instance.initialize(environment: Environment.current);
  
  runApp(const MultipleMarkersApp());
}
