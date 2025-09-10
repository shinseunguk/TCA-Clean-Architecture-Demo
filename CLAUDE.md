## 📋 개발 규칙

### 커밋 컨벤션
다음 형식을 따라 커밋 메시지를 작성해주세요:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Type
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포매팅, 세미콜론 누락, 코드 변경이 없는 경우
- `refactor`: 코드 리팩토링
- `test`: 테스트 코드 추가
- `chore`: 빌드 업무 수정, 패키지 매니저 수정

#### 예시
```bash
feat(todo): 할일 완료 토글 기능 추가
fix(network): API 타임아웃 이슈 해결
docs: CLAUDE.md에 커밋 컨벤션 추가
refactor(user): UserRowView 컴포넌트 분리
test(domain): FetchTodosUseCase 단위 테스트 추가
```

### 커밋 시 주의사항

#### 🌏 언어 규칙
- **커밋 메시지는 반드시 한글로 작성해주세요**
- 명확하고 이해하기 쉬운 한국어 표현을 사용
- 기술 용어는 적절히 영어와 한글을 혼용 가능

#### ⚠️ Claude 서명 제거
커밋하기 전에 반드시 Claude 서명을 제거해주세요.

```bash
# 커밋 메시지에서 다음 내용들을 제거:
# 🤖 Generated with [Claude Code](https://claude.ai/code)
# Co-Authored-By: Claude <noreply@anthropic.com>
```

올바른 커밋 예시:
```bash
git commit -m "feat(todo): 할일 완료 상태 토글 기능 구현"
```
