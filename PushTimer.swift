import Foundation
import UIKit

class PushTimer {
    /// timer 싱글톤 패턴
    static let shared = PushTimer()
    var timer = PTimer(startTime: -1)
    var currentTime: Int {
        get {
            let date = Date()
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "HH:mm:ss"
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            let currentTime = hour * 3600 + minutes * 60 + seconds
            return currentTime
        }
    }
    /// 남은 시간
    var leftTime: Int {
        get {
            let _leftTime = self.timer.expireTime - self.currentTime
            if _leftTime < 0 {
                self.terminateTimer()
            }
            return _leftTime
        }
    }
    
    // MARK: - Init
    /// [필수, init] Push로 받은 SpecialGift를 통해 Timer를 초기화 합니다. 만료 시간은 1일 후 입니다.
    func initTimer(specialGift: SpecialGift) {
        self.timer.isTimeout = false
        self.timer.color = color
        self.timer.specialGift = specialGift
        self.timer.startTime = self.currentTime
        saveTimer()
        print("## Timer Initialized!")
    }
    /// timer를 UserDefaults에 저장합니다
    func saveTimer() {
        do {
            // Timer 클래스를 data로 변환
            let pushTimer = try NSKeyedArchiver.archivedData(withRootObject: self.timer, requiringSecureCoding: false)
            // UserDefaults에 저장
            UserDefaults.standard.set(pushTimer, forKey: "pushTimer")
            print("##PushTimer Saved on UserDefaults")
        } catch {
            print("##Save Timer Err")
            print(error)
        }
    }
    /// timer를 UserDefaults에서 불러와 싱글톤에 초기화합니다.
    func loadTimer() {
        let archivedData = UserDefaults.standard.object(forKey: "pushTimer")
        do {
            let timer = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData as! Data) as! PTimer
            self.timer = timer
            print("##PushTimer Load from UserDefaults")
        }catch {
            print("##Load Timer Err")
            print(error)
        }
        
        // timeout
        if self.timer.color == nil {
            self.timer.isTimeout = true
        }
    }
    /// 타이머에 관한 프로퍼티를 모두 삭제합니다
    func terminateTimer() {
        self.timer.terminateTimer()
        self.saveTimer()
    }
}

class PTimer: NSObject, NSCoding {
    var specialGift: SpecialGift?
    
    /// 시작 시간이 currentTime으로 할당되면 종료 시간(expireTime)을 해당 시간으로 부터 1일 뒤로 설정합니다.
    var startTime: Int = -1 {
        willSet(newValue) {
            expireTime = newValue + (24 * 60 * 60)
        }
        didSet{
            print("타이머 시작 시각: \(startTime), 타이머 만료 시각: \(expireTime)")
        }
    }
 
    var expireTime: Int = -1 {
        willSet(newValue) {
            if newValue > 1 {self.isTimeout = false}
        }
    }
    var isTimeout = true
    var color: String?
    
    /// UserDefault에 저장할 timer를 초기화 합니다. default startTime은 -1 입니다.
    init(startTime: Int = -1) {
        self.startTime = startTime
    }
    private override init(){
    
    }
    
    fileprivate func terminateTimer(){
        self.startTime = -1
        self.expireTime = -1
        self.isTimeout = true
        self.color = nil
    }
    
    required init?(coder: NSCoder) {
        self.specialGift = coder.decodeObject(forKey: "specialGift") as? SpecialGift
        self.startTime = coder.decodeInteger(forKey: "startTime")
        self.expireTime = coder.decodeInteger(forKey: "expireTime")
        self.color = coder.decodeObject(forKey: "color") as? String
        self.isTimeout = coder.decodeBool(forKey: "isTimeout")
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.specialGift?.encode(), forKey: "specialGift")
        coder.encode(self.startTime, forKey: "startTime")
        coder.encode(self.expireTime, forKey: "expireTime")
        coder.encode(self.color, forKey: "color")
        coder.encode(self.isTimeout, forKey: "isTimeout")
    }
}

// 푸시로 받은 데이터들을 캡슐화 하는게 목적이므로 구조체 선언
struct SpecialGift {
    let postIdArray: [Int]
    let month: String
    let color: String
    let subtitle: String
    
    /// 푸시로 받은 userInfo를 통해 SpecialGift 구조체를 초기화 합니다
    init?(userInfo: [AnyHashable:Any]) {
        let dataDic = userInfo as NSDictionary
        guard var postIdString = dataDic["postId"] as? String else {return nil}
        guard let month = dataDic["month"] as? String else {return nil}
        guard let color = dataDic["color"] as? String else {return nil}
        guard let subtitle = dataDic["subtitle"] as? String else {return nil}
        
        postIdString.removeFirst()
        postIdString.removeLast()
        let postIdTok = postIdString.components(separatedBy: ",")
        var postIdIntArray = [Int]()
        for value in postIdTok {
            if let value = value as? Int {
                postIdIntArray.append(value)
            }
        }
        
        self.postIdArray = postIdIntArray
        self.month = month
        self.color = color
        self.subtitle = subtitle
        
        print("## SpecialGift init")
        print("postID: \(self.postIdArray)")
        print("month: \(self.month)")
        print("color: \(self.color)")
        print("subtitle: \(self.subtitle)\n")
    }
    
    func encode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(postIdArray, forKey: "postIdArray")
        archiver.encode(month, forKey: "month")
        archiver.encode(color, forKey: "color")
        archiver.encode(subtitle, forKey: "subtitle")
        
        return archiver.encodedData
    }
    init?(data: Data) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        defer {
            unarchiver.finishDecoding()
        }
        guard let postIdArray =  unarchiver.decodeObject(forKey: "postIdArray") as? [Int] else { return nil }
        guard let month = unarchiver.decodeObject(forKey: "month") as? String else { return nil }
        guard let color = unarchiver.decodeObject(forKey: "color") as? String else { return nil }
        guard let subtitle = unarchiver.decodeObject(forKey: "subtitle") as? String else { return nil }
        self.postIdArray = postIdArray
        self.month = month
        self.color = color
        self.subtitle = subtitle
    }
}


