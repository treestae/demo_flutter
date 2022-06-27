# 스네이크 게임
추억의 뱀 게임입니다.

과일(빨간점)을 먹을수록 뱀의 길이가 길어지며
스테이지 밖 또는 자기 몸에 부딪히면 게임이 종료 됩니다.

## 조작법
게임 시작 및 종료: Space 또는 시작 버튼

이동: 시간에 따라 자동 이동
방향 전환: 화면 드래그 or 키보드 방향키

속도 조절: 넘버패드 +, - 또는 +, - 버튼

<br/><br/>




# Code snippets
<br/>

## 드래그 방향 검사
https://github.com/treestae/demo_flutter/blame/main/snake/lib/main.dart#L72-L85
<br/>
  

## 키보드 리스너 등록
https://github.com/treestae/demo_flutter/blame/main/snake/lib/main.dart#L67-L70
<br/>
  
  
## 키보드 입력값 구분
https://github.com/treestae/demo_flutter/blame/main/snake/lib/main.dart#L252-L277
<br/>
  
  
## 속도 변경에 따른 Timer.interval의 주기 변경
https://github.com/treestae/demo_flutter/blame/main/snake/lib/main.dart#L182-L205
<br/>
  
  
## enum의 반대 방향값 리턴 확장함수
아직(Dart 2.17)까지는 선언과 동시에 자신의 값을 리턴할 수는 없다.(재귀 호출로 무한 반복되기 때문)
https://github.com/treestae/demo_flutter/blob/main/snake/lib/snake.dart#L114-L135
<br/>
