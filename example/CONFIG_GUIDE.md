# 네이버 맵 클라이언트 ID 설정 가이드

## 개요
이 프로젝트는 네이버 맵 API 클라이언트 ID를 안전하게 관리하기 위해 설정 파일을 사용합니다. 이를 통해 민감한 정보를 소스 코드에서 분리하고, 환경별로 다른 설정을 사용할 수 있습니다.

## 설정 파일 구조

```
assets/config/
├── app_config.json          # 기본 설정 파일 (프로덕션용)
├── app_config.dev.json      # 개발용 설정 파일
├── app_config.staging.json  # 스테이징용 설정 파일 (선택사항)
└── app_config.prod.json     # 프로덕션용 설정 파일 (선택사항)
```

## 설정 방법

### 1. 기본 설정 파일 생성

`assets/config/app_config.json` 파일을 생성하고 본인의 네이버 맵 클라이언트 ID를 입력하세요:

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

### 2. 환경별 설정 파일 (선택사항)

개발 환경과 프로덕션 환경에서 다른 클라이언트 ID를 사용하려면:

**개발용 (`app_config.dev.json`)**:
```json
{
  "naver_map": {
    "client_id": "DEV_CLIENT_ID",
    "description": "개발용 네이버 맵 클라이언트 ID"
  },
  "app": {
    "name": "Flutter Naver Map Web Example (Development)",
    "version": "1.0.0-dev"
  }
}
```

**프로덕션용 (`app_config.prod.json`)**:
```json
{
  "naver_map": {
    "client_id": "PROD_CLIENT_ID",
    "description": "프로덕션용 네이버 맵 클라이언트 ID"
  },
  "app": {
    "name": "Flutter Naver Map Web Example",
    "version": "1.0.0"
  }
}
```

## 실행 방법

### 기본 실행 (개발 환경)
```bash
flutter run -d chrome
```

### 환경 지정 실행
```bash
# 개발 환경
flutter run -d chrome --dart-define=ENVIRONMENT=dev

# 프로덕션 환경
flutter run -d chrome --dart-define=ENVIRONMENT=prod

# 스테이징 환경
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

### 빌드 시 환경 지정
```bash
# 프로덕션 빌드
flutter build web --dart-define=ENVIRONMENT=prod

# 개발 빌드
flutter build web --dart-define=ENVIRONMENT=dev
```

## 보안 고려사항

### .gitignore 설정
실제 클라이언트 ID가 포함된 설정 파일은 git에 커밋하지 마세요:

```gitignore
# Configuration files with sensitive data
/assets/config/app_config.json
/assets/config/app_config.prod.json
/assets/config/app_config.staging.json
# 개발용 파일은 예시로 포함할 수 있음
# /assets/config/app_config.dev.json
```

### CI/CD 환경에서의 설정
1. **GitHub Actions**: Repository Secrets를 사용하여 설정 파일 생성
2. **기타 CI/CD**: 환경 변수를 통해 빌드 시점에 설정 파일 생성

예시 GitHub Actions 스크립트:
```yaml
- name: Create config file
  run: |
    mkdir -p assets/config
    echo '{
      "naver_map": {
        "client_id": "'${{ secrets.NAVER_MAP_CLIENT_ID }}'",
        "description": "네이버 맵 API 클라이언트 ID"
      },
      "app": {
        "name": "Flutter Naver Map Web Example",
        "version": "1.0.0"
      }
    }' > assets/config/app_config.json
```

## API 사용법

### AppConfig 초기화
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경별 설정 로드
  await AppConfig.instance.initialize(environment: Environment.current);
  
  runApp(MyApp());
}
```

### 클라이언트 ID 사용
```dart
// NaverMapWeb 위젯에서 사용
NaverMapWeb(
  clientId: AppConfig.instance.naverMapClientId,
  // ... 기타 설정
)

// 직접 접근
String clientId = AppConfig.instance.naverMapClientId;
String appName = AppConfig.instance.appName;
String version = AppConfig.instance.appVersion;

// 커스텀 설정값 접근
String? customValue = AppConfig.instance.getValue<String>('custom.key');
```

### 환경 확인
```dart
if (Environment.isDevelopment) {
  print('개발 환경에서 실행 중');
}

if (Environment.isProduction) {
  print('프로덕션 환경에서 실행 중');
}
```

## 네이버 클라우드 플랫폼 설정

1. [네이버 클라우드 플랫폼](https://www.ncloud.com/) 콘솔에 로그인
2. **Application > Maps** 서비스 선택
3. **Application 등록** 버튼 클릭
4. 애플리케이션 정보 입력:
   - 애플리케이션 이름
   - 서비스 환경: Web Dynamic Map
   - Web 서비스 URL 입력 (예: http://localhost:8080, https://yourdomain.com)
5. 생성된 **Client ID**를 설정 파일에 입력

## 문제 해결

### 클라이언트 ID 관련 오류
```
Exception: 네이버 맵 클라이언트 ID가 설정되지 않았습니다.
```
→ `app_config.json` 파일에서 `client_id` 값을 확인하세요.

### 설정 파일 로드 실패
```
Exception: AppConfig가 초기화되지 않았습니다.
```
→ `main()` 함수에서 `AppConfig.instance.initialize()`가 호출되었는지 확인하세요.

### 환경별 설정 파일이 없는 경우
→ 지정된 환경의 설정 파일이 없으면 자동으로 기본 설정 파일(`app_config.json`)을 사용합니다.

## 참고사항

- 설정 파일은 JSON 형식입니다.
- 중첩된 객체 구조를 지원합니다.
- `getValue<T>('path.to.value')` 메서드로 깊은 중첩 값에 접근할 수 있습니다.
- 앱 실행 시 디버그 정보가 콘솔에 출력됩니다.
