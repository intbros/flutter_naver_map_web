import 'package:flutter/material.dart';
import 'package:flutter_naver_map_web/flutter_naver_map_web.dart';
import 'package:flutter_naver_map_web_example/config/app_config.dart';

/// 마커 클릭 이벤트 예제 페이지
class MarkerClickExample extends StatefulWidget {
  const MarkerClickExample({super.key});

  @override
  State<MarkerClickExample> createState() => _MarkerClickExampleState();
}

class _MarkerClickExampleState extends State<MarkerClickExample> {
  String? _selectedPlaceId;
  String _lastClickedPlace = '없음';

  // 샘플 장소 데이터
  final List<Place> _places = [
    const Place(
      id: '1',
      name: '서울시청',
      latitude: 37.5666103,
      longitude: 126.9783882,
      description: '서울특별시 시청입니다.',
      category: '관공서',
      iconUrl: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png',
    ),
    const Place(
      id: '2',
      name: '경복궁',
      latitude: 37.5796,
      longitude: 126.9770,
      description: '조선 왕조의 법궁입니다.',
      category: '관광지',
      iconUrl: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
    ),
    const Place(
      id: '3',
      name: '명동',
      latitude: 37.5636,
      longitude: 126.9834,
      description: '쇼핑과 맛집이 가득한 관광 명소입니다.',
      category: '쇼핑',
      iconUrl: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
    ),
    const Place(
      id: '4',
      name: '홍대입구',
      latitude: 37.5563,
      longitude: 126.9236,
      description: '젊음의 거리, 홍익대학교 근처입니다.',
      category: '상업지구',
      iconUrl: 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png',
    ),
    const Place(
      id: '5',
      name: '강남역',
      latitude: 37.4979,
      longitude: 127.0276,
      description: '대한민국의 중심지 강남입니다.',
      category: '상업지구',
      iconUrl: 'https://maps.google.com/mapfiles/ms/icons/purple-dot.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 지도 마커 클릭 예제'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // 상태 정보 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '마커 클릭 이벤트 테스트',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('마지막 클릭한 장소: $_lastClickedPlace'),
                Text('선택된 장소 ID: ${_selectedPlaceId ?? "없음"}'),
                const SizedBox(height: 8),
                Text(
                  '지도의 마커를 클릭해보세요!',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // 지도 영역
          Expanded(
            child: NaverMapWeb(
              clientId:
                  AppConfig.instance.naverMapClientId, // 실제 클라이언트 ID로 교체하세요
              initialLatitude: 37.5666103,
              initialLongitude: 126.9783882,
              initialZoom: 12,
              zoomControl: true,
              mapDataControl: true,
              places: _places,
              selectedPlaceId: _selectedPlaceId,
              onMarkerClick: _onMarkerClick,
              onMapReady: (map) {
                debugPrint('지도 준비 완료!');
                // 모든 마커가 보이도록 지도 범위 조정
                // map.fitBounds() 호출 가능
              },
            ),
          ),

          // 버튼들
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showPlaceInfo,
                    child: const Text('장소 정보'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 마커 클릭 이벤트 핸들러
  void _onMarkerClick(Place place) {
    debugPrint('마커 클릭됨: ${place.name}');

    setState(() {
      _lastClickedPlace = place.name;
      _selectedPlaceId = place.id;
    });

    // 스낵바로 클릭 정보 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${place.name} 마커를 클릭했습니다!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );

    // 다이얼로그로 상세 정보 표시 (선택사항)
    _showPlaceDetailDialog(place);
  }

  /// 장소 상세 정보 다이얼로그
  void _showPlaceDetailDialog(Place place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(place.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.category != null) Text('카테고리: ${place.category}'),
              const SizedBox(height: 8),
              Text(
                  '위치: ${place.latitude.toStringAsFixed(6)}, ${place.longitude.toStringAsFixed(6)}'),
              const SizedBox(height: 8),
              if (place.description != null) Text('설명: ${place.description}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  /// 장소 정보 표시
  void _showPlaceInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('등록된 장소 목록'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                final isSelected = place.id == _selectedPlaceId;

                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: isSelected ? Colors.red : Colors.grey,
                  ),
                  title: Text(
                    place.name,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.red : Colors.black,
                    ),
                  ),
                  subtitle: Text(place.category ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedPlaceId = place.id;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}

/// 단독 실행 가능한 앱 예제
class MarkerClickExampleApp extends StatelessWidget {
  const MarkerClickExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네이버 지도 마커 클릭 예제',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MarkerClickExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AppConfig 초기화
  await AppConfig.instance.initialize(environment: Environment.current);

  // 디버그 정보 출력
  AppConfig.instance.printDebugInfo();

  runApp(const MarkerClickExampleApp());
}
