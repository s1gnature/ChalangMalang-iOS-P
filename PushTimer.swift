//
//  PushTimer.swift
//  Colendar
//
//  Created by mong on 2020/12/29.
//  Copyright © 2020 찰랑말랑. All rights reserved.
//

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
//            let currentDate = formatter.string(from: date)
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
//            let day = calendar.component(.day, from: date)
            
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
    
    /// [필수, init] Push Timer를 init합니다 - test용도 -> timerAfter(몇초 후?), color(어떤 감정 색?)
    func initTimer(timeAfter: Int, color: String) {
        self.timer.isTimeout = false
        self.timer.color = color
        self.timer.expireTime = self.currentTime + timeAfter // 삭제 요망
        saveTimer()
        print("## Timer Initialized!")
    }
    /// [필수, init] Push Timer를 init합니다 - test용도 -> timerAfter(몇초 후?), color(어떤 감정 색?)
    func initTimerWithUserInfo(timeAfter: Int, color: String, userInfo: [AnyHashable:Any]) {
        self.timer.isTimeout = false
        self.timer.color = color
        self.timer.specialGift = SpecialGift(userInfo: userInfo)
        self.timer.expireTime = self.currentTime + timeAfter // 삭제 요망
        saveTimer()
        print("## Timer Initialized!")
    }
    /// [필수, init] Push Timer를 init합니다 - test용도 -> timerAfter(몇초 후?), color(어떤 감정 색?)
    func initTimerWithSpecialGift(timeAfter: Int, color: String, specialGift: SpecialGift) {
        self.timer.isTimeout = false
        self.timer.color = color
        self.timer.specialGift = specialGift
        self.timer.expireTime = self.currentTime + timeAfter // 삭제 요망
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
        
        // timeout init
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
    
    var startTime: Int = -1 {
        willSet(newValue) {
            expireTime = newValue + 1000
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
    
    fileprivate func terminateTimer(){
        self.startTime = -1
        self.expireTime = -1
        self.isTimeout = true
        self.color = nil
    }
    
    /// Test: 시작 시간을 지정합니다
    init(startTime: Int) {
        self.startTime = startTime
    }
    /// Test: SpecialGift 구조체를 파라미터로 사용합니다
    init(specialGift: SpecialGift) {
        self.specialGift = specialGift
    }
    /// 푸시의 userInfo를 파라미터로 사용합니다
    init(userInfo: [AnyHashable:Any]) {
        self.specialGift = SpecialGift(userInfo: userInfo)
    }
    private override init(){
    
    }
    required init?(coder: NSCoder) {
        self.specialGift = coder.decodeObject(forKey: "specialGift") as? SpecialGift
        self.startTime = coder.decodeInteger(forKey: "startTime")
        self.expireTime = coder.decodeInteger(forKey: "expireTime")
        self.color = coder.decodeObject(forKey: "color") as? String
        self.isTimeout = coder.decodeBool(forKey: "isTimeout")
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.specialGift, forKey: "specialGift")
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
    
    /// Test 용도, 삭제 필
    init(postIdArray: [Int], month: String, color: String, subtitle: String){
        self.postIdArray = postIdArray
        self.month = month
        self.color = color
        self.subtitle = subtitle
        
        print("## SpecialGift init")
        print("postID: \(self.postIdArray)")
        print("month: \(self.month)")
        print("color: \(self.color)")
        print("subtitle: \(self.subtitle)\n")
    }
    
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
}

