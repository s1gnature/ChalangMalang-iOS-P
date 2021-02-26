# 찰랑말랑 iOS

#### AppStore
Click Here!
[![](/Colendar/Assets.xcassets/AppIcon.appiconset/icon_40pt@2x.png)](https://apps.apple.com/kr/app/찰랑말랑/id1477694079)

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

