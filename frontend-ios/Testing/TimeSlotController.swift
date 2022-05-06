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
    
    var status = UIButton()
    var pressed = false
    var done = UIButton()
    var waiting = UIButton()
    var ongoing = UIButton()
    var tas = UIButton()
//    var liveupdates = UILabel()
    var updatetickers : [String : UILabel] = [:]

    var timeslotId: String = ""
    var courseCode: String = ""
    var courseColor: UIColor = .white
    
    var icon: UIImageView!
    var courseCodeLabel: UILabel!
    var joinButton: UIButton!
    var liveUpatesLabel: UILabel!
    
    var doneLabel: UILabel!
    var waitingLabel: UILabel!
    var ongoingLabel: UILabel!
    var instructorsCountLabel: UILabel!
    
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
        
        joinButton = UIButton()
        joinButton.backgroundColor = courseColor
        joinButton.layer.borderWidth = 1
        joinButton.layer.cornerRadius = 20

        joinButton.addTarget(self, action: #selector(joinQueue), for: .touchUpInside)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joinButton)

        liveUpatesLabel = UILabel()
        liveUpatesLabel.text = "Live Updates"
        liveUpatesLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        liveUpatesLabel.font = .systemFont(ofSize: 36, weight: .bold)
        liveUpatesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(liveUpatesLabel)
        
        setUpTickers()
        setUpConstraints()
    }
    
    init(timeslotId: String, courseId: String, courseCode: String, courseColor: UIColor) {
        super .init(nibName: nil, bundle: nil)
        self.timeslotId = timeslotId
        self.courseCode = courseCode
        self.courseColor = courseColor
        
        if let sessionToken = userDefaults.value(forKey: Constants.UserDefaults.sessionToken) as? String {
            NetworkManager.get_queue_info(fromSessionToken: sessionToken, forCourseId: courseId, forTimeslotId: timeslotId) { queueInfoResponse in
                self.ongoingLabel.text = String(queueInfoResponse.ongoing)
                self.waitingLabel.text = String(queueInfoResponse.waiting)
                self.doneLabel.text = String(queueInfoResponse.completed)
                self.instructorsCountLabel.text = String(queueInfoResponse.instructor_count)
            }
        } else {
            // Session token doesn't exist
            UIApplication.shared.windows.first?.rootViewController = LoginController()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    
    
    func setUpTickers() {
        doneLabel = UILabel()
        doneLabel.backgroundColor = courseColor
        doneLabel.textColor = .white
        doneLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        doneLabel.layer.cornerRadius = 24
        doneLabel.layer.masksToBounds = true
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneLabel)
        
        ongoingLabel = UILabel()
        ongoingLabel.backgroundColor = courseColor
        ongoingLabel.textColor = .white
        ongoingLabel.font = .systemFont(ofSize: 36, weight: .bold)
        ongoingLabel.layer.cornerRadius = 24
        ongoingLabel.layer.masksToBounds = true
        ongoingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ongoingLabel)
        
        waitingLabel = UILabel()
        waitingLabel.backgroundColor = courseColor
        waitingLabel.textColor = .white
        waitingLabel.font = .systemFont(ofSize: 36, weight: .bold)
        waitingLabel.layer.cornerRadius = 24
        waitingLabel.layer.masksToBounds = true
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waitingLabel)
        
        instructorsCountLabel = UILabel()
        instructorsCountLabel.backgroundColor = courseColor
        instructorsCountLabel.textColor = .white
        instructorsCountLabel.font = .systemFont(ofSize: 36, weight: .bold)
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
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(courseCodeLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalTo(view.frame.width * (313.0/375.0))
        }
        
        liveUpatesLabel.snp.makeConstraints { make in
            make.top.equalTo(joinButton.snp.bottom).offset(34)
            make.left.equalToSuperview().offset(22)
        }
        
        
        let innerSpacing = view.frame.width * (24.0 / 375)
        let width = (view.frame.width - (innerSpacing * 3)) / 2
        
        doneLabel.snp.makeConstraints { make in
            make.top.equalTo(liveUpatesLabel.snp.bottom).offset(22)
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
    
    
    func setNotQueued() {
        status.setTitle("   NOT QUEUED  ", for: .normal)
        status.setTitleColor(.white, for: .normal)
        status.layer.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        status.layer.borderWidth = 1
        status.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        status.layer.cornerRadius = 20
        status.translatesAutoresizingMaskIntoConstraints = false
        status.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)

        view.addSubview(status)
        
        NSLayoutConstraint.activate([
            status.topAnchor.constraint(equalTo: joinButton.topAnchor, constant: 5),
            status.trailingAnchor.constraint(equalTo: joinButton.trailingAnchor, constant: -5),
            status.widthAnchor.constraint(equalToConstant: 100),
            status.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func joinQueue() {
        if pressed {
            status.setTitle("   Left X  ", for: .normal)
            status.setTitleColor(.white, for: .normal)
            status.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            status.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            pressed = false
        } else {
            status.setTitle("   Joined √  ", for: .normal)
            status.setTitleColor(.white, for: .normal)
            status.layer.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            status.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            pressed = true
        }
        
    }
    
    func setupUpdates() {
//        done, waiting, ongoing, tas
        done.setTitle("Done", for: .normal)
        done.setTitleColor(.white, for: .normal)
        done.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        done.layer.cornerRadius = 20
        done.translatesAutoresizingMaskIntoConstraints = false
        done.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        waiting.setTitle("Waiting", for: .normal)
        waiting.setTitleColor(.white, for: .normal)
        waiting.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        waiting.layer.cornerRadius = 20
        waiting.translatesAutoresizingMaskIntoConstraints = false
        waiting.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        ongoing.setTitle("Ongoing", for: .normal)
        ongoing.setTitleColor(.white, for: .normal)
        ongoing.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        ongoing.layer.cornerRadius = 20
        ongoing.translatesAutoresizingMaskIntoConstraints = false
        ongoing.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        tas.setTitle("TAs", for: .normal)
        tas.setTitleColor(.white, for: .normal)
        tas.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        tas.layer.cornerRadius = 20
        tas.translatesAutoresizingMaskIntoConstraints = false
        tas.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        
        view.addSubview(done)
        view.addSubview(waiting)
        view.addSubview(ongoing)
        view.addSubview(tas)
        
        NSLayoutConstraint.activate([
//            done.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  200),
            done.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 410),
            done.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            done.widthAnchor.constraint(equalToConstant: 150),
            done.heightAnchor.constraint(equalToConstant: 170),
            waiting.topAnchor.constraint(equalTo: done.topAnchor),
            waiting.leadingAnchor.constraint(equalTo: done.trailingAnchor, constant: 40),
            waiting.widthAnchor.constraint(equalTo: done.widthAnchor),
            waiting.heightAnchor.constraint(equalToConstant: 100),
            ongoing.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            ongoing.widthAnchor.constraint(equalTo: done.widthAnchor),
            ongoing.topAnchor.constraint(equalTo: done.bottomAnchor, constant: 20),
            ongoing.leadingAnchor.constraint(equalTo: done.leadingAnchor),
            tas.leadingAnchor.constraint(equalTo: waiting.leadingAnchor),
            tas.trailingAnchor.constraint(equalTo: waiting.trailingAnchor),
            tas.topAnchor.constraint(equalTo: waiting.bottomAnchor, constant: 20),
            tas.bottomAnchor.constraint(equalTo: ongoing.bottomAnchor)
        
        ])
        
    }
    
    
    
//    lazy var joinButtonlabels: [UILabel] = {
//        let title = UILabel()
//        title.text = "Consulting Hours"
//        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        title.font = .systemFont(ofSize: 24, weight: .bold)
//
//
//        let subtitle = UILabel()
//        subtitle.text = "Derek and Cornelius         this looks trash ik ->"
//        subtitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        subtitle.font = .systemFont(ofSize: 12)
//
//        let now = UILabel()
//        now.text = "Now"
//        now.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        now.font = .systemFont(ofSize: 16, weight: .bold)

//        let liveupdates = UILabel()
//        liveupdates.text = "Live Updates"
//        liveupdates.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        liveupdates.font = .systemFont(ofSize: 36, weight: .bold)
//
//
//        title.translatesAutoresizingMaskIntoConstraints = false
//        subtitle.translatesAutoresizingMaskIntoConstraints = false
//        now.translatesAutoresizingMaskIntoConstraints = false
//
//        liveupdates.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(title)
//        view.addSubview(subtitle)
//        view.addSubview(now)
//        view.addSubview(liveupdates)
        
//        NSLayoutConstraint.activate([
//            title.topAnchor.constraint(equalTo: joinButton.topAnchor, constant: 10),
//            title.leadingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: 10),
//            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
//            subtitle.leadingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: 10),
//            now.trailingAnchor.constraint(equalTo: joinButton.trailingAnchor, constant: -10),
//            now.bottomAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: -10),
//            liveupdates.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 35),
//            liveupdates.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
//
//        ])
//
//        return [title, subtitle, liveupdates]
//    }()
}


