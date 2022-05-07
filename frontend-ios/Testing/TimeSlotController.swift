//
//  TimeSlot.swift
//  Testing
//
//  Created by Derek Sanchez on 5/5/22.
//

import SwiftUI

import UIKit
import SwiftUI

class TimeslotController: UIViewController {
    let userDefaults = UserDefaults.standard
    
//    var status = UIButton()
//    var pressed = false
//    var done = UIButton()
//    var waiting = UIButton()
//    var ongoing = UIButton()
//    var tas = UIButton()
////    var liveupdates = UILabel()
//    var updatetickers : [String : UILabel] = [:]

    var timeslotId: String = ""
    var courseId = ""
    var courseCode: String = ""
    var courseColor: UIColor = .white
    
    var timeslotName = ""
    var timeslotInstructors = ""
    var inQueue = false
    
    var icon: UIImageView!
    var courseCodeLabel: UILabel!
    var timeslotView: UIView!
    var timeslotNameLabel: UILabel!
    var timeslotInstructorsLabel: UILabel!
    var queueButton: UIButton!
    
    var liveUpdatesLabel: UILabel!
    var doneLabel: UILabel!
    var waitingLabel: UILabel!
    var ongoingLabel: UILabel!
    var instructorsCountLabel: UILabel!
    
    let countLabelFont: UIFont = .systemFont(ofSize: 28, weight: .bold)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required initializer...
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        icon = UIImageView()
        icon.image = UIImage(named: "Sprite")
        icon.layer.cornerRadius = 5
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        
        courseCodeLabel = UILabel()
        courseCodeLabel.text = self.courseCode
        courseCodeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        courseCodeLabel.font = .systemFont(ofSize: 36, weight: .bold)
        courseCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(courseCodeLabel)
        
        timeslotView = UIView()
        timeslotView.backgroundColor = courseColor
        timeslotView.layer.borderWidth = 1
        timeslotView.layer.cornerRadius = 20
        timeslotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeslotView)
        
        timeslotNameLabel = UILabel()
        timeslotNameLabel.text = self.timeslotName
        timeslotNameLabel.textColor = .white
        timeslotNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        timeslotNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeslotNameLabel)
        
        timeslotInstructorsLabel = UILabel()
        timeslotInstructorsLabel.text = self.timeslotInstructors
        timeslotInstructorsLabel.textColor = .white
        timeslotInstructorsLabel.font = .systemFont(ofSize: 14)
        timeslotInstructorsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeslotInstructorsLabel)
        
        queueButton = UIButton()
        queueButton.backgroundColor = .white
        queueButton.setTitleColor(.black, for: .normal)
        queueButton.titleLabel?.font = .systemFont(ofSize: 14)
        queueButton.setTitle(inQueue ? "LEAVE" : "JOIN", for: .normal)
        queueButton.addTarget(self, action: #selector(toggleJoin), for: .touchUpInside)
        queueButton.layer.cornerRadius = 8
        queueButton.layer.masksToBounds = true
        queueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(queueButton)

        liveUpdatesLabel = UILabel()
        liveUpdatesLabel.text = "Live Updates"
        liveUpdatesLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        liveUpdatesLabel.font = .systemFont(ofSize: 36, weight: .bold)
        liveUpdatesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(liveUpdatesLabel)
        
        setUpTickers()
        setUpConstraints()
    }
    
    init(timeslotId: String, timeslotName: String, timeslotInstructors: String, courseId: String, courseCode: String, courseColor: UIColor) {
        super .init(nibName: nil, bundle: nil)
        self.timeslotId = timeslotId
        self.courseCode = courseCode
        self.courseColor = courseColor
        self.courseId = courseId
        
        self.timeslotName = timeslotName
        self.timeslotInstructors = timeslotInstructors
        
        requestCounts()
    }
    
    func requestCounts() {
        if let sessionToken = userDefaults.value(forKey: Constants.UserDefaults.sessionToken) as? String {
            NetworkManager.get_queue_info(fromSessionToken: sessionToken, forCourseId: courseId, forTimeslotId: timeslotId) { queueInfoResponse in
                self.ongoingLabel.text = String(queueInfoResponse.ongoing) + "\nOngoing"
                self.waitingLabel.text = String(queueInfoResponse.waiting) + "\nWaiting"
                self.doneLabel.text = String(queueInfoResponse.completed) + "\nDone"
                self.inQueue = queueInfoResponse.in_queue
                self.queueButton.setTitle(self.inQueue ? "LEAVE" : "JOIN", for: .normal)
                
                let suffix = queueInfoResponse.instructor_count == 1 ? "TA" : "TAs"
                self.instructorsCountLabel.text = String(queueInfoResponse.instructor_count) + "\n" + suffix
            }
        } else {
            // Session token doesn't exist
            UIApplication.shared.windows.first?.rootViewController = LoginController()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func setUpTickers() {
        doneLabel = UILabel()
        doneLabel.textAlignment = .center
        doneLabel.numberOfLines = 0
        doneLabel.backgroundColor = courseColor
        doneLabel.textColor = .white
        doneLabel.font = countLabelFont
        doneLabel.layer.cornerRadius = 24
        doneLabel.layer.masksToBounds = true
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneLabel)
        
        ongoingLabel = UILabel()
        ongoingLabel.textAlignment = .center
        ongoingLabel.numberOfLines = 0
        ongoingLabel.backgroundColor = courseColor
        ongoingLabel.textColor = .white
        ongoingLabel.font = countLabelFont
        ongoingLabel.layer.cornerRadius = 24
        ongoingLabel.layer.masksToBounds = true
        ongoingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ongoingLabel)
        
        waitingLabel = UILabel()
        waitingLabel.textAlignment = .center
        waitingLabel.numberOfLines = 0
        waitingLabel.backgroundColor = courseColor
        waitingLabel.textColor = .white
        waitingLabel.font = countLabelFont
        waitingLabel.layer.cornerRadius = 24
        waitingLabel.layer.masksToBounds = true
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waitingLabel)
        
        instructorsCountLabel = UILabel()
        instructorsCountLabel.textAlignment = .center
        instructorsCountLabel.numberOfLines = 0
        instructorsCountLabel.backgroundColor = courseColor
        instructorsCountLabel.textColor = .white
        instructorsCountLabel.font = countLabelFont
        instructorsCountLabel.layer.cornerRadius = 24
        instructorsCountLabel.layer.masksToBounds = true
        instructorsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructorsCountLabel)
    }
    
    func setUpConstraints() {
        icon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        courseCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        timeslotView.snp.makeConstraints { make in
            make.top.equalTo(courseCodeLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalTo(view.frame.width * (313.0/375.0))
        }
        
        timeslotNameLabel.snp.makeConstraints { make in
            make.top.equalTo(timeslotView.snp.top).offset(10)
            make.left.equalTo(timeslotView.snp.left).offset(18)
        }
        
        timeslotInstructorsLabel.snp.makeConstraints { make in
            make.top.equalTo(timeslotNameLabel.snp.bottom).offset(2)
            make.left.equalTo(timeslotView.snp.left).offset(18)
        }
        
        queueButton.snp.makeConstraints { make in
            make.bottom.equalTo(timeslotView.snp.bottom).offset(-6)
            make.right.equalTo(timeslotView.snp.right).offset(-8)
        }
        
        liveUpdatesLabel.snp.makeConstraints { make in
            make.top.equalTo(timeslotView.snp.bottom).offset(34)
            make.left.equalToSuperview().offset(22)
        }
        
        let innerSpacing = view.frame.width * (24.0 / 375)
        let width = (view.frame.width - (innerSpacing * 3)) / 2
        
        doneLabel.snp.makeConstraints { make in
            make.top.equalTo(liveUpdatesLabel.snp.bottom).offset(22)
            make.height.equalTo(108)
            make.width.equalTo(width)
            make.left.equalTo(innerSpacing)
        }
        
        ongoingLabel.snp.makeConstraints { make in
            make.top.equalTo(doneLabel.snp.bottom).offset(30)
            make.height.equalTo(160)
            make.width.equalTo(width)
            make.left.equalToSuperview().offset(innerSpacing)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.top.equalTo(doneLabel.snp.top)
            make.height.equalTo(180)
            make.width.equalTo(width)
            make.right.equalToSuperview().offset(-innerSpacing)
        }
        
        instructorsCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(ongoingLabel.snp.bottom)
            make.height.equalTo(77)
            make.width.equalTo(width)
            make.right.equalToSuperview().offset(-innerSpacing)
        }
        
        
    }
    
    @objc func toggleJoin() {
        inQueue.toggle()
        let text = inQueue ? "LEAVE" : "JOIN"
        queueButton.setTitle(text, for: .normal)
        if inQueue {
            if let sessionToken = userDefaults.value(forKey: Constants.UserDefaults.sessionToken) as? String {
                NetworkManager.join_queue(fromSessionToken: sessionToken, forCourseId: self.courseId, forTimeslotId: self.timeslotId) { _ in
                    self.requestCounts()
                }
            } else {
                // Session token doesn't exist
                UIApplication.shared.windows.first?.rootViewController = LoginController()
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        } else {
            if let sessionToken = userDefaults.value(forKey: Constants.UserDefaults.sessionToken) as? String {
                NetworkManager.leave_queue(fromSessionToken: sessionToken, forCourseId: self.courseId, forTimeslotId: self.timeslotId) { _ in
                    self.requestCounts()
                }
            } else {
                // Session token doesn't exist
                UIApplication.shared.windows.first?.rootViewController = LoginController()
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    
    
}


