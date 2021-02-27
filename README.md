# 찰랑말랑 iOS

> SK E&S 와의 콜라보 활동으로 인한 찰랑말랑 레포 Private [2020.05 ~ 2021.11]

#### SK E&S 추가기능
- 설문조사 뷰 추가 도입.
- 설문조사에 사용할 RadioButton Logic 구현
- 설문조사(TableView)에서 필수 설문 항목에 대한 설문 여부 확인 로직(각각의 RadioButton isCheck?)
- 설문조사를 바탕으로 한 꺾은선 그래프 차트 도입. [Charts](https://github.com/danielgindi/Charts)

#### AppStore
[![](/README_Asset/icon_40pt@2x.png)](https://apps.apple.com/kr/app/찰랑말랑/id1477694079)

#### Thumbnails
<div>
<img width="200"  src="https://user-images.githubusercontent.com/32588087/64242940-683a8400-cf41-11e9-9730-34f56233064c.png">
<img width="200"  src="https://user-images.githubusercontent.com/32588087/64243038-a041c700-cf41-11e9-8fb4-46fd2c11e080.png">
<img width="200"  src="https://user-images.githubusercontent.com/32588087/64243040-a041c700-cf41-11e9-8f91-c9d2046b0243.png">
<img width="200"  src="https://user-images.githubusercontent.com/32588087/64243041-a041c700-cf41-11e9-9d54-ce9db12384ca.png">
</div>

#### TeamMate
- [s1gnature](https://github.com/s1gnature)
- [freemjstudio](https://github.com/freemjstudio)
#### Language
- Swift
#### CocoaPod
- KYDrawerController
- FSCalendar
- UIColor_Hex_Swift
- lottie-ios
- Firebase
- SwiftLint (확인 용도로만 사용)

#### Util
- PushTimer
   푸시를 받았을 때 깜짝선물을 보여주기 위한 타이머 관련 Singleton Class 입니다.
   
   <br/>
   1. shared 관련 기능 (PushTimer의 메소드) <br/>
   PushTimer.shared 로 접근합니다
   
   > - initTimer() -> Void <br/>
   > PushTimer를 초기화 하는데 사용합니다. 푸시를 받은 즉시 호출해야 합니다. 기본적으로 saveTimer()가 내장되어 있습니다. <br/>
   > - saveTimer() -> Void <br/>
   > PushTimer를 저장 하는데 사용합니다. UserDefaults에 "pushTimer" 키값으로 Timer 객체만 저장합니다. <br/>
   > - loadTimer() -> Void <br/>
   > PushTimer를 불러오는데 사용합니다. UserDefaults에 "pushTimer" 키값으로 Timer 객체를 불러와 싱글톤 객체에 초기화합니다. <br/>
   > - terminateTimer() -> Void <br/>
   > PushTimer를 제거하는데 사용합니다. Timer 객체의 terminateTimer()를 호출 후 saveTimer()를 호출하여 변경사항을 저장합니다. <br/>
   
   <br/>
   2. timer 관련 기능 <br/>
   PushTimer.shared.timer 로 접근합니다
   
   > - startTime: Int, (Default: -1) <br/>
   > timer의 시작 시간, 즉 푸시를 받은 시점의 시간을 나타냅니다. <br/>
   > - expireTime: Int, (Default: -1) <br/>
   > timer의 종료 시간, 즉 깜짝 선물의 만료 시간을 나타냅니다. <br/>
   > - isTimeout: Bool, (Defualt: True) <br/>
   > timer의 상태를 나타냅니다. <br/>
   > - color: String?, (Default: nil) <br/>
   > 깜짝 선물의 색깔을 나타냅니다. <br/>
   > - terminateTimer() -> Void <br/>
   > 위에 나열된 변수를 모두 초기값으로 초기화합니다. 즉 타이머를 중지시킵니다. <br/>

#### 기능 개발
- Firebase RemoteConfig를 통한 앱 사용 최소 버전 분기
- ~~Google admob 배너 적용~~ 기능 삭제
- Lottie를 통한 애니메이션 로직 구현
- Network 로직 작성
- Firebase를 이용한 Push 구현 (했으나 기능상 문제로 취소)
- OfflineQueue 로직 구현
   > **Trouble Shooting**
   > 기획이 명확해질 쯤 다이어리 성향이 강한 서비스에 과연 서버가 필요할까? 라는 의문점이 재기됨. (여타 다이어리 앱은 로그인 기능이 없고, 오프라인 상태에서도 이용할 수 있음)
   > 그래서 서로가 학술적인 의미로 서버(온라인)를 가져가되, 오프라인에서도 불편함 없이 사용이 가능하도록 구현을 하자! 라는 의견으로 모아짐.
   > 약 1~2주 간의 논의를 마친 뒤 나온 결론이 OfflineQueue를 클라이언트에서 만들어 오프라인 상태에서도 유저에게 마치 서비스가 잘 돌아가는 것 처럼(온라인 상태인 것 처럼) 보이게 하여 해결함.
   > OfflineQueue의 Flow는 다음과 같다
   > <br><br>
   > > didFinishLaunchingWithOptions(앱 실행 시) 에서는 UserDefaults에 저장된 OfflineQueue를 불러오고,
   > > applicationWillTerminate(앱 종료 시) 에서는 OfflineQueue를 UserDefaults에 저장한다.
   > 1. 먼저 메인화면에서 viewDidLoad를 통해 해당 유저가 작성한 데이터를 caching하여 갖고 있는다.
   > 1-1. 이 때, 인터넷 연결이 되어 있지 않다면 데이터를 가져올 수 없다는 알림을 띄워준다.
   > 2. 다음 유저가 감정을 작성하는 화면에서 완료를 눌렀을 시점에 인터넷 연결 상태를 체크한다. (서버에 요청을 보내고 response를 기다리기엔 시간이 소요되므로) 
   > 2-1(연결이 되어 있지 않은 경우). OfflineQueue에 작성된 post를 append 시킨다.
   > 2-2-1(연결이 되어 있는 경우). OfflineQueue가 비어있는지 확인 후, post가 있다면 먼저 request를 보낸다.
   > 2-2-2. request가 완료되면 OfflineQueue를 비운다.
   > 2-3. 2에서 작성 된 post를 request 한다.
   > 3. 다음 화면인 List 뷰에서 OfflineQueue가 empty가 아닐 경우 caching한 데이터에 append 시켜 collectionView에 띄워준다 (온라인데이터 + 오프라인데이터)
License
----
MIT
Copyright © 2019 [찰랑말랑 of NEXTERS](https://github.com/nexters-colary)


[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>



----


<a href="https://sourcerer.io/freemjstudio"><img src="https://avatars1.githubusercontent.com/u/41604678?v=4" height="50px" width="50px" alt=""/></a>
<a href="https://sourcerer.io/freemjstudio"><img src="https://img.shields.io/badge/Swift-9%20commits-orange.svg" alt=""></a>

