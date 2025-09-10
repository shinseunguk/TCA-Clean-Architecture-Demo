# TCA-Clean Architecture-Demo

이 프로젝트는 **The Composable Architecture (TCA)**와 **Clean Architecture** 패턴을 결합한 iOS 앱 데모입니다.

## 🏗️ 아키텍처 개요

### Clean Architecture Layers
```
┌─────────────────┐
│  Presentation   │ ← SwiftUI + TCA
├─────────────────┤
│    Domain       │ ← Business Logic
├─────────────────┤
│     Data        │ ← Network + Repository
└─────────────────┘
```

### 의존성 방향
- **Presentation** → **Domain** ← **Data**
- 모든 의존성이 Domain을 향함 (Dependency Inversion)

## 📁 프로젝트 구조

```
TCA-Clean Architecture-Demo/
├── App/                           # 앱 진입점
│   ├── ContentView.swift
│   ├── MainTabView.swift
│   └── TCA_Clean_Architecture_DemoApp.swift
├── Domain/                        # 비즈니스 로직 레이어
│   ├── Common/
│   │   ├── NetworkError.swift
│   │   └── ValidationError.swift
│   ├── Entities/
│   │   ├── Todo.swift
│   │   └── User.swift
│   ├── Repositories/
│   │   ├── TodoRepositoryProtocol.swift
│   │   └── UserRepositoryProtocol.swift
│   └── UseCases/
│       ├── Todo/
│       │   └── FetchTodosUseCase.swift
│       └── User/
│           └── FetchUsersUseCase.swift
├── Data/                          # 데이터 레이어
│   ├── Network/
│   │   ├── TargetTypes/
│   │   │   ├── TodoAPI.swift
│   │   │   └── UserAPI.swift
│   │   ├── Services/
│   │   │   ├── TodoAPIService.swift
│   │   │   └── UserAPIService.swift
│   │   ├── NetworkConfig.swift
│   │   └── NetworkProvider.swift
│   └── Repositories/
│       ├── TodoRepository.swift
│       └── UserRepository.swift
└── Presentation/                  # UI 레이어
    ├── Dependencies/
    │   ├── TodoClient.swift
    │   └── UserClient.swift
    ├── Features/
    │   ├── Todo/
    │   │   └── TodoListFeature.swift
    │   └── User/
    │       └── UserListFeature.swift
    └── Views/
        ├── Common/
        │   └── DetailRow.swift
        ├── Todo/
        │   ├── Components/
        │   │   └── TodoRowView.swift
        │   └── TodoView.swift
        └── User/
            ├── Components/
            │   ├── UserRowView.swift
            │   └── UserDetailView.swift
            └── UserView.swift
```

## 🛠️ 기술 스택

- **Architecture**: Clean Architecture + TCA
- **UI Framework**: SwiftUI
- **State Management**: The Composable Architecture (TCA)
- **Networking**: Moya
- **Dependency Injection**: TCA Dependencies
- **API**: JSONPlaceholder (Mock API)

## 🔧 주요 명령어

### 프로젝트 빌드
```bash
xcodebuild -project "TCA-Clean Architecture-Demo.xcodeproj" -scheme "TCA-Clean Architecture-Demo" -destination "platform=iOS Simulator,name=iPhone 15" build
```

### 테스트 실행
```bash
xcodebuild test -project "TCA-Clean Architecture-Demo.xcodeproj" -scheme "TCA-Clean Architecture-Demo" -destination "platform=iOS Simulator,name=iPhone 15"
```

### 의존성 업데이트
SPM을 통해 의존성을 관리합니다:
- ComposableArchitecture
- Moya

## 🎯 주요 기능

### Todo 관리
- ✅ Todo 목록 조회
- ✅ 완료 상태 토글
- ✅ Todo 삭제
- ✅ 새로고침 기능
- ✅ 에러 핸들링

### User 관리
- 👤 사용자 목록 조회
- 👤 사용자 상세 정보
- 👤 사용자 삭제
- 👤 새로고침 기능
- 👤 에러 핸들링

## 🎨 Clean Architecture 구현

### Domain Layer
- **Entities**: 비즈니스 객체 (`Todo`, `User`)
- **Use Cases**: 비즈니스 로직 (`FetchTodosUseCase`, `FetchUsersUseCase`)
- **Repository Interfaces**: 데이터 접근 추상화
- **Common**: 공통 에러 및 유틸리티

### Data Layer
- **Repository Implementations**: Domain 인터페이스 구현
- **Network Services**: API 통신 (`Moya` 기반)
- **TargetTypes**: API 엔드포인트 정의

### Presentation Layer
- **TCA Features**: 상태 관리 및 비즈니스 로직
- **TCA Dependencies**: 의존성 주입
- **SwiftUI Views**: UI 컴포넌트
- **View Components**: 재사용 가능한 UI 컴포넌트

## 📋 TCA 패턴 적용

### State
```swift
@ObservableState
struct State: Equatable {
    var todos: [Todo] = []
    var isLoading = false
    var errorMessage: String?
}
```

### Action
```swift
enum Action {
    case onAppear
    case fetchTodos
    case todosResponse(Result<[Todo], Error>)
    case toggleTodoCompleted(Todo)
    case deleteTodo(id: Int)
}
```

### Reducer
```swift
@Reducer
struct TodoListFeature {
    @Dependency(\.todoClient) var todoClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // 상태 변경 로직
        }
    }
}
```

## 🔄 데이터 플로우

1. **View** → Action 발생
2. **Reducer** → 상태 변경 및 Effect 실행
3. **TCA Client** → UseCase 호출
4. **UseCase** → Repository 호출
5. **Repository** → API Service 호출
6. **API Service** → Network 요청
7. **응답** → Reducer로 전달
8. **State 업데이트** → View 리렌더링

## 🧪 테스트 전략

### Unit Tests
- **Domain Layer**: UseCase 로직 테스트
- **Data Layer**: Repository 구현 테스트
- **Presentation Layer**: Reducer 로직 테스트

### Integration Tests
- API 통신 테스트
- 전체 플로우 테스트

### UI Tests
- SwiftUI 뷰 테스트
- 사용자 시나리오 테스트

## 📝 코딩 컨벤션

### 네이밍
- **Protocol**: `~Protocol` 또는 `~able`
- **Implementation**: 프로토콜명에서 Protocol 제거
- **Feature**: `~Feature`
- **Client**: `~Client`

### 파일 구조
- 기능별 폴더 구분
- 컴포넌트별 파일 분리
- Common 폴더를 통한 공통 요소 관리

## 🚀 실행 방법

1. Xcode에서 프로젝트 열기
2. iOS 시뮬레이터 선택
3. ⌘+R로 실행

## 🔍 주요 학습 포인트

### Clean Architecture
- 의존성 역전 원칙 적용
- 레이어별 책임 분리
- 테스트 가능한 구조

### TCA (The Composable Architecture)
- 단방향 데이터 플로우
- 상태 관리 패턴
- 의존성 주입 시스템
- Effect를 통한 부작용 관리

### SwiftUI + TCA
- `@Bindable` 상태 바인딩
- Store를 통한 뷰-로직 분리
- 컴포넌트 재사용성

## 📚 참고 자료

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Moya](https://github.com/Moya/Moya)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

---

**개발자**: Claude Code Assistant  
**생성일**: 2025-09-10  
**버전**: 1.0.0
