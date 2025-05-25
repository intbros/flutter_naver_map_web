# 변경 로그 (Changelog)

이 프로젝트의 모든 주목할 만한 변경사항이 이 파일에 문서화됩니다.

형식은 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)를 기반으로 하며,
이 프로젝트는 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)을 따릅니다.

## [0.0.1] - 2025-5-25

### 추가됨 (Added)
- 🗺️ **NaverMapWeb 위젯**: 네이버 지도 API v3와 완전히 통합된 인터랙티브 지도 위젯
- 📍 **동적 마커 관리**: Place 모델을 통한 마커 추가, 제거, 업데이트 기능
- 💬 **정보창(InfoWindow) 지원**: HTML 콘텐츠가 포함된 풍부한 정보창 표시
- 🎯 **지도 컨트롤**: 줌 컨트롤과 지도 데이터 컨트롤 지원
- 🔧 **타입 안전한 JavaScript 통합**: 최신 `dart:js_interop`을 사용한 견고한 상호운용성
- 🌐 **Flutter Web 전용 최적화**: 웹 환경에 특화된 성능 최적화
- 🚀 **간편한 설정**: HTML 수정 없이 클라이언트 ID만으로 지도 사용 가능

### 핵심 기능 (Core Features)
- **NaverMapWeb 위젯**: 
  - 클라이언트 ID를 통한 직접적인 네이버 지도 API 통합
  - 초기 위치, 줌 레벨, 컨트롤 옵션 설정 가능
- **Place 모델**: 
  - `id`, `name`, `latitude`, `longitude` 필수 속성
  - `description`, `category`, `iconUrl` 선택적 속성
- **마커 시스템**:
  - 다중 마커 동시 표시 지원
  - 마커 선택 상태 관리 및 시각적 피드백
  - 기본 마커 크기와 선택된 마커 크기 커스터마이징
- **이벤트 처리**:
  - `onMapReady` 콜백: 지도 초기화 완료 시 호출
  - `onMarkerClick` 콜백: 마커 클릭 시 호출
- **자동 스크립트 로딩**: 네이버 지도 API 스크립트 동적 로딩
- **DOM 관리**: 고유 ID를 가진 DOM 요소 생성 및 생명주기 관리

### 기술 세부사항 (Technical Details)
- **의존성 (Dependencies)**: 
  - `web: ^1.1.1` - 최신 웹 API 지원
  - `flutter_web_plugins` - Flutter Web 플러그인 아키텍처
- **최소 요구사항**:
  - Flutter SDK: `>=3.32.0`
  - Dart SDK: `>=3.5.0 <4.0.0`
- **플랫폼 지원**: 웹 전용 (HTML 렌더러 및 CanvasKit)
- **아키텍처**: 팩토리 패턴을 사용한 플러그인 기반 뷰 관리

### 구현된 클래스 및 메서드 (Implemented Classes & Methods)

#### NaverMapWeb 위젯
- 주요 매개변수:
  - `clientId` (필수): 네이버 클라우드 플랫폼 클라이언트 ID
  - `initialLatitude`, `initialLongitude`: 초기 지도 중심 좌표
  - `initialZoom`: 초기 줌 레벨
  - `zoomControl`, `mapDataControl`: 컨트롤 표시 옵션
  - `places`: 표시할 장소 목록
  - `selectedPlaceId`: 선택된 장소 ID
  - `markerSize`, `selectedMarkerSize`: 마커 크기 설정

#### NaverMapPlugin 클래스
- `registerMapViewFactory()`: 고유 뷰 ID로 지도 뷰 팩토리 등록
- `unregisterMapViewFactory()`: 뷰 팩토리 등록 해제
- `isViewFactoryRegistered()`: 뷰 팩토리 등록 상태 확인

#### JavaScript Interop 클래스들
- `LatLng`: 위도/경도 좌표 표현
- `NaverMap`: 네이버 지도 인스턴스
- `Marker`: 지도 마커 객체
- `InfoWindow`: 정보창 객체
- `MapOptions`: 지도 옵션 설정

### 예제 애플리케이션 (Example Applications)
- **기본 지도 예제** (`basic_map_example.dart`): 가장 간단한 지도 표시
- **다중 마커 예제** (`multiple_markers_example.dart`): 여러 마커와 상호작용
- **다양한 크기 예제** (`various_sizes_example.dart`): 다양한 레이아웃의 지도 위젯

### 보안 및 모범 사례 (Security & Best Practices)
- `dart:js_interop`을 사용한 타입 안전한 JavaScript 통합
- 안전한 클라이언트 ID 처리 (생성된 코드에 노출되지 않음)
- 적절한 리소스 정리 및 메모리 관리
- 고유 ID를 통한 DOM 요소 생명주기 관리
- 재시도 로직을 통한 견고한 DOM 요소 대기 처리

### 문서화 (Documentation)
- 한국어 README 문서
- API 레퍼런스 문서
- 문제 해결 가이드
- 모범 사례 권장사항
- 실용적인 코드 예제

### 품질 보증 (Quality Assurance)
- `flutter_lints: ^3.0.0`을 통한 정적 분석
- 포괄적인 예제 애플리케이션
- 오류 처리 및 엣지 케이스 처리
- 웹 환경을 위한 성능 최적화
- 디버깅 지원 및 로깅

## [계획된 기능] - Unreleased

### 예정된 기능 (Planned Features)
- 📐 **그리기 도구**: 폴리라인, 폴리곤, 원형 그리기 지원
- 🎨 **커스텀 테마**: 지도 스타일링 및 테마 옵션
- 📊 **데이터 레이어**: GeoJSON 및 KML 파일 지원
- 🔍 **검색 통합**: 장소 검색 및 지오코딩 기능
- 📍 **마커 클러스터링**: 대용량 데이터셋을 위한 마커 클러스터링
- 🎯 **길찾기**: 경로 계획 및 내비게이션 기능
- 📐 **측정 도구**: 거리 및 면적 측정 유틸리티
- 🎪 **애니메이션**: 마커 애니메이션 및 부드러운 전환효과

### 검토 중인 기능 (Under Consideration)
- 더 나은 IDE 지원을 위한 TypeScript 정의
- 오프라인 지도 캐싱 기능
- 커스텀 지도 컨트롤 및 UI 요소
- 고급 마커 커스터마이징 옵션
- 실시간 위치 추적
- 히트맵 시각화
- 스트리트 뷰 통합

### 개선 예정 사항 (Planned Improvements)
- 마커 클릭 이벤트 완전 구현
- 정보창 이벤트 처리 개선
- 커스텀 마커 아이콘 지원 확대
- 지도 경계 자동 조정 기능 개선
- 성능 최적화 및 메모리 사용량 개선

---

**참고**: 이 패키지는 Flutter Web 전용으로 설계되었습니다. 네이버 지도가 모바일 플랫폼용 별도의 네이티브 SDK를 제공하므로 모바일 플랫폼 지원(iOS/Android)은 계획되어 있지 않습니다.

질문, 버그 리포트, 기능 요청은 [GitHub 저장소](https://github.com/intbros/flutter_naver_map_web)를 방문해주세요.

## 라이선스 (License)

이 프로젝트는 MIT 라이선스 하에 배포됩니다. NAVER 지도 API v3의 모든 저작권은 네이버에 있습니다.