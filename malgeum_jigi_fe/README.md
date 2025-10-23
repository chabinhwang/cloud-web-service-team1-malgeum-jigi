# 맑음지기 (Malgeum Jigi) - 웹 버전

사용자의 환기 및 생활 환경 관리를 돕는 Flutter 애플리케이션입니다. 실시간 공기질 정보, 온습도 관리 가이드, 주간 생활 추천을 제공합니다.

## 프로젝트 소개

- **앱 이름**: 맑음지기
- **프레임워크**: Flutter 3.9.2+
- **언어**: Dart
- **플랫폼**: Web, Android, iOS, Windows, macOS, Linux

## 설치 및 실행

### 1. 의존성 설치

```bash
flutter pub get
```

### 2. 개발 모드에서 실행

```bash
# 웹에서 실행
flutter run -d chrome

# 또는 다른 플랫폼
flutter run -d macos       # macOS
flutter run -d windows     # Windows
flutter run -d linux       # Linux
```

## 웹 빌드 및 배포

### 웹 빌드 생성

```bash
# 릴리스 모드로 웹 빌드
flutter build web --release

# 빌드 파일은 build/web/ 디렉토리에 생성됩니다
```

### 빌드된 웹앱 로컬에서 실행

#### 방법 1: Python 사용 (추천)

```bash
cd build/web
python3 -m http.server 8000
```

브라우저에서 `http://localhost:8000` 접속

#### 방법 2: Node.js 사용

```bash
# http-server 설치 (처음 한 번만)
npm install -g http-server

# 실행
cd build/web
http-server -p 8000
```

#### 방법 3: VS Code Live Server 확장

1. VS Code에서 "Live Server" 확장 설치
2. `build/web/index.html` 마우스 우클릭
3. "Open with Live Server" 선택

#### 방법 4: Ruby 사용

```bash
cd build/web
ruby -run -ehttpd . -p8000
```

#### 방법 5: PHP 사용

```bash
cd build/web
php -S localhost:8000
```

### 배포 옵션

#### Firebase Hosting

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 프로젝트 초기화
firebase init hosting

# 배포
firebase deploy
```

#### Vercel

```bash
# Vercel CLI 설치
npm install -g vercel

# 배포
vercel --prod
```

#### Netlify

- `build/web` 폴더를 Netlify에 드래그 & 드롭하거나
- Netlify CLI 사용

#### GitHub Pages

- `build/web` 폴더를 `gh-pages` 브랜치에 배포

## 주요 명령어

```bash
# 의존성 설치
flutter pub get

# 정적 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드 캐시 정리
flutter clean

# 웹 빌드
flutter build web --release

# 개발 모드 실행
flutter run -d chrome

# 핫 리로드 (실행 중)
r

# 핫 리스타트 (실행 중)
R
```

## 프로젝트 구조

- `lib/`: 주요 애플리케이션 코드
  - `screens/`: 화면 컴포넌트 (메인, 환기, 온도·습도, 생활 가이드)
  - `theme/`: 앱 테마 및 디자인 시스템
  - `widgets/`: 재사용 가능한 위젯
  - `models/`: 데이터 모델
  - `utils/`: 유틸리티 함수
- `sdd/`: 소프트웨어 설계 문서

## 자세한 정보

프로젝트에 대한 자세한 정보는 `CLAUDE.md` 파일을 참고하세요.

- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Dart 언어 가이드](https://dart.dev/guides)
