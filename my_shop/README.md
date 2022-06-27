# 나의 가방샵 UI

간단한 쇼핑몰 클론입니다.


# Code snippets

### Desktop 화면 크기 제한
```dart
import 'package:desktop_window/desktop_window.dart';
```
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/screen_limit.dart#L12
  
  
### 무한 화면의 확장 제한(모바일 뷰처럼 제한된다)
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/screen_limit.dart#L13-L18

Scaffold 를 감싼다.
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/home_screen.dart#L12-L19
  
  
### GridView 사용법
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/components/body.dart#L25-L41
  
  
### 페이지 이동법
이동
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/components/body.dart#L35-L40

돌아가기
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/details/details_screen.dart#L34
  

### Hero 위젯 사용법
두 위젯을 같은 tag로 연결한다. 하나의 child를 두기 때문에 여러 위젯을 동시에 Hero 효과를 주기 위해서는 따로 따로 감싸야한다.
https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/components/item_card.dart#L31

https://github.com/treestae/demo_flutter/blob/cff0c57ae04599269c402226dbe4ccafb0807d2e/my_shop/lib/screens/details/components/product_title_with_image.dart#L42-L48
