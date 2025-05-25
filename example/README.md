# Flutter Naver Map Web 예제 모음

Flutter에서 네이버 지도를 웹에서 사용하는 다양한 예제들을 제공합니다.

## 🎯 예제 개요

이 예제 애플리케이션은 Flutter Naver Map Web 패키지의 다양한 기능과 사용법을 보여줍니다. 각 예제는 독립적으로 실행 가능하며, 실제 개발에서 활용할 수 있는 실용적인 코드를 제공합니다.

## 📁 예제 목록

### 1. 기본 지도 보기 (`basic_map_example.dart`)
가장 간단한 형태의 네이버 지도를 표시하는 예제입니다.

**주요 기능:**
- 서울시청을 중심으로 한 기본 지도 표시
- 줌 컨트롤과 지도 데이터 컨트롤 활성화
- 기본적인 NaverMapWeb 위젯 사용법

```dart
NaverMapWeb(
  clientId: 'YOUR_CLIENT_ID', // 실제 클라이언트 ID로 변경 필요
  initialLatitude: 37.5666103,  // 서울시청 위도
  initialLongitude: 126.9783882, // 서울시청 경도
  initialZoom: 13,
  zoomControl: true,
  mapDataControl: true,
)
```

### 2. 여러 마커 표시 (`multiple_markers_example.dart`)
서울의 주요 관광지에 마커를 표시하고 상호작용하는 예제입니다.

**주요 기능:**
- 5개의 서울 주요 관광지 마커 표시 (서울시청, 경복궁, N서울타워, 명동성당, 동대문 DDP)
- 마커 클릭 이벤트 처리 및 SnackBar 알림
- 선택된 마커 정보를 상단에 표시
- 플로팅 액션 버튼을 통한 마커 목록 모달 제공
- 선택된 마커 시각적 하이라이트

**포함된 장소:**
- 서울시청: 서울특별시의 행정 중심지
- 경복궁: 조선시대 정궁
- N서울타워: 서울의 랜드마크
- 명동성당: 한국 천주교의 중심
- 동대문 디자인 플라자: 현대적 디자인 복합공간

### 3. 다양한 크기의 지도 위젯 (`various_sizes_example.dart`)
여러 가지 크기와 레이아웃으로 지도 위젯을 배치하는 방법을 보여주는 예제입니다.

**포함된 레이아웃:**
- **작은 지도 (200×200)**: 정사각형 형태의 소형 지도
- **중간 크기 지도 (카드 형태)**: 400×300 크기의 카드로 래핑된 지도
- **와이드 지도 (16:9 비율)**: 전체 너비의 와이드스크린 지도
- **격자 배치 (2×2)**: 4개 도시(서울, 부산, 제주, 인천)의 격자 배치
- **플렉서블 레이아웃**: 메인 지도와 서브 지도들의 비율 조정

**표시되는 지역:**
- 서울: 37.5666103, 126.9783882 (줌 13)
- 부산: 35.1796, 129.0756 (줌 13)
- 제주도: 33.4996, 126.5312 (줌 11)
- 인천: 37.4563, 126.7052 (줌 12)

## 🚀 실행 방법

### 예제 선택 페이지 실행
```bash
cd example
flutter run -d chrome
```

### 개별 예제 직접 실행
각 예제 파일에는 독립적인 `main()` 함수가 포함되어 있어 직접 실행할 수 있습니다.

```bash
# 기본 지도 예제
flutter run -t lib/examples/basic_map_example.dart -d chrome

# 여러 마커 예제  
flutter run -t lib/examples/multiple_markers_example.dart -d chrome

# 다양한 크기 예제
flutter run -t lib/examples/various_sizes_example.dart -d chrome
```

## ⚙️ 설정 방법

### 1. 네이버 클라이언트 ID 설정 (중요!)

이 프로젝트는 보안을 위해 클라이언트 ID를 설정 파일로 관리합니다. 

**단계별 설정:**

1. **설정 파일 생성**: `assets/config/app_config.json` 파일을 생성하고 본인의 클라이언트 ID를 입력하세요.

```json
{
  "naver_map": {
    "client_id": "YOUR_ACTUAL_NAVER_MAP_CLIENT_ID",
    "description": "네이버 맵 API 클라이언트 ID"
  },
  "app": {
    "name": "Flutter Naver Map Web Example",
    "version": "1.0.0"
  }
}
```

2. **환경별 설정 (선택사항)**: 개발/프로덕션 환경에서 다른 ID를 사용하려면 `app_config.dev.json`, `app_config.prod.json` 파일을 추가로 생성하세요.

3. **실행**: 설정 파일 생성 후 예제를 실행하면 자동으로 클라이언트 ID를 로드합니다.

**자세한 설정 방법은 [CONFIG_GUIDE.md](CONFIG_GUIDE.md)를 참조하세요.**

### 2. 클라이언트 ID 발급 방법
1. [네이버 클라우드 플랫폼](https://www.ncloud.com/) 회원가입
2. Console > Services > Application Service > Maps 메뉴 이동
3. 새 애플리케이션 등록
4. "Web Dynamic Map" 서비스 선택
5. 도메인 정보 등록 (개발 시에는 `localhost:port` 등록)
6. 발급받은 클라이언트 ID를 코드에 적용

### 3. 도메인 등록
웹에서 실행할 때는 네이버 클라우드 플랫폼에 사용할 도메인을 등록해야 합니다:
- 개발 환경: `localhost:포트번호`
- 프로덕션 환경: 실제 도메인

## 📱 화면 구성

### 메인 화면 (ExampleSelectionPage)
- 3개의 예제를 카드 형태로 표시
- 각 카드는 제목, 설명, 아이콘으로 구성
- 하단에 주의사항 안내

### 예제별 화면 구성
- **기본 지도**: 전체 화면 지도
- **여러 마커**: 상단 정보 표시 + 지도 + 플로팅 버튼
- **다양한 크기**: 스크롤 가능한 다양한 레이아웃 데모

## 🛠️ 기술 구현 세부사항

### NaverMapWeb 주요 속성
| 속성 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `clientId` | String | 필수 | 네이버 클라우드 플랫폼 클라이언트 ID |
| `initialLatitude` | double | 37.5666103 | 초기 지도 중심 위도 |
| `initialLongitude` | double | 126.9783882 | 초기 지도 중심 경도 |
| `initialZoom` | int | 15 | 초기 줌 레벨 (1-21) |
| `zoomControl` | bool | true | 줌 컨트롤 버튼 표시 |
| `mapDataControl` | bool | true | 지도 데이터 컨트롤 표시 |
| `places` | List<Place> | [] | 표시할 마커 목록 |
| `selectedPlaceId` | String? | null | 선택된 마커 ID |
| `onMarkerClick` | Function? | null | 마커 클릭 콜백 |
| `onMapReady` | Function? | null | 지도 준비 완료 콜백 |

### Place 모델
```dart
Place({
  required String id,           // 고유 식별자
  required String name,         // 장소명
  required double latitude,     // 위도
  required double longitude,    // 경도
  String? description,          // 설명 (선택)
  String? category,             // 카테고리 (선택)
  String? iconUrl,              // 커스텀 아이콘 URL (선택)
})
```

## 📂 파일 구조

```
example/
├── lib/
│   ├── main.dart                           # 메인 예제 선택 페이지
│   └── examples/
│       ├── basic_map_example.dart          # 기본 지도 예제
│       ├── multiple_markers_example.dart   # 여러 마커 예제
│       └── various_sizes_example.dart      # 다양한 크기 예제
├── web/
│   ├── index.html                          # 웹 진입점
│   └── ...
├── pubspec.yaml                            # 의존성 설정
└── README.md                               # 이 파일
```

## 💡 개발 팁

### 1. 성능 최적화
- 많은 지도 위젯을 동시에 사용할 때는 필요에 따라 지연 로딩 고려
- 마커가 많을 때는 화면에 보이는 영역의 마커만 표시
- 지도 크기가 작을 때는 불필요한 컨트롤 비활성화

### 2. 반응형 디자인
```dart
// 화면 크기에 따른 지도 높이 조정
double mapHeight = MediaQuery.of(context).size.height * 0.6;
```

### 3. 에러 처리
```dart
NaverMapWeb(
  onMapReady: (map) {
    print('지도 로드 성공');
  },
  // 네트워크 오류나 API 한계 등에 대한 처리 추가
)
```

### 4. 상태 관리
```dart
// 선택된 마커 상태 관리
String? selectedPlaceId;

onMarkerClick: (Place place) {
  setState(() {
    selectedPlaceId = place.id;
  });
}
```

## ⚠️ 주의사항

1. **클라이언트 ID 보안**: 실제 서비스에서는 클라이언트 ID를 환경 변수로 관리하세요
2. **도메인 등록**: 프로덕션 배포 전 도메인을 네이버 클라우드 플랫폼에 등록하세요
3. **웹 전용**: 이 예제들은 Flutter Web에서만 작동합니다
4. **API 한도**: 네이버 지도 API 사용 한도를 확인하고 적절히 관리하세요

## 🔗 관련 링크

- [Flutter Naver Map Web 패키지](https://pub.dev/packages/flutter_naver_map_web)
- [네이버 지도 API 공식 문서](https://navermaps.github.io/maps.js.ncp/docs/index.html)
- [네이버 클라우드 플랫폼](https://www.ncloud.com/)

## 📄 라이선스

이 예제들은 MIT 라이선스 하에 배포됩니다. 실제 서비스 개발 시 네이버 지도 API의 이용약관을 반드시 확인하세요.

**NAVER 지도 API v3의 모든 저작권은 네이버에 있습니다.**