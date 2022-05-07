//
//  CourseController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/4/22.
//

import UIKit
import SwiftUI

class CourseController: UIViewController {
    let userDefaults = UserDefaults.standard
    
    var courseCode: String = ""
    var courseColor: UIColor = .white
    var courseId: String = ""
    var timeslots: [Timeslot] = []
    
    var icon: UIImageView!
    var courseCodeLabel: UILabel!
    var monthLabel: UILabel!
    
    var leftMonthLabel: UILabel!
    var rightMonthLabel: UILabel!
    
    var ongoingLabel: UILabel!
    
    var timeslotsCollectionView: UICollectionView!
    let cellPadding:CGFloat = 24
    
    // Reuse identifiers
    let timeslotsReuseIdentifier = "timeslotsReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setGradientBackground()
        
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
    
        let date = Date()
        let calendar = Calendar.current
        
        monthLabel = UILabel()
        monthLabel.text = String(stringifyMonth(month: calendar.component(.month, from: date)))
        monthLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        monthLabel.font = .systemFont(ofSize: 36, weight: .bold)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthLabel)
        
        leftMonthLabel = UILabel()
        leftMonthLabel.text = String ("< " + stringifyMonth(month: calendar.component(.month, from:date) - 1))
        leftMonthLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        leftMonthLabel.font = .systemFont(ofSize: 16)
        leftMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftMonthLabel)
        
        rightMonthLabel = UILabel()
        rightMonthLabel.text = String (stringifyMonth(month: calendar.component(.month, from:date) + 1) + " >")
        rightMonthLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rightMonthLabel.font = .systemFont(ofSize: 16)
        rightMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightMonthLabel)
    
        ongoingLabel = UILabel()
        ongoingLabel.text = "Ongoing"
        ongoingLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ongoingLabel.font = .systemFont(ofSize: 48, weight: .bold)
        ongoingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ongoingLabel)
        
        let verticalLayout = UICollectionViewFlowLayout()
        verticalLayout.scrollDirection = .vertical
        verticalLayout.minimumLineSpacing = cellPadding
        verticalLayout.minimumInteritemSpacing = cellPadding
        
        timeslotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalLayout)
        timeslotsCollectionView.backgroundColor = .none
        
        timeslotsCollectionView.register(TimeslotCollectionViewCell.self, forCellWithReuseIdentifier: timeslotsReuseIdentifier)
        
        timeslotsCollectionView.delegate = self
        timeslotsCollectionView.dataSource = self
        timeslotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeslotsCollectionView)
        
        setUpConstraints()
    }
    
//    let officeHours: [String] // Should be networked in, i dunno how we will represent this so far.
//    let datestring = DateFormatter().string(from: Date()) // "yyyy-MM-dd HH:mm:ss"
//    let themeColor: CGColor
        
//    TODO: implement below as collectionview
//    lazy var dayBlocks: [UIButton] = {
//        let day1 = UIButton()
//        let day2 = UIButton()
//        let day3 = UIButton()
//        let day4 = UIButton()
//        var days: [UIButton] = [day1, day2, day3, day4]
//
//        let date = Date()
//        let calendar = Calendar.current
//
//        var currentDay = calendar.component(.day, from: date) // This is broken. It does not wrap around
//        var currentLead = view.safeAreaLayoutGuide.leadingAnchor
//        var currentWeekday = calendar.component(.weekday, from: Date())
//
//        var nextWeekday : ((Int) -> String) = { (d: Int) in
//            let day: [Int: String] = [1: "Mon", 2: "Tues", 3: "Wed", 4: "Thurs", 5: "Fri", 6: "Sat", 0: "Sun"]
//            return day[d]!
//        }
//
//        for day in days {
//            day.setTitle("\(currentDay)\n\(nextWeekday(currentWeekday))", for: .normal)
//            day.titleLabel!.numberOfLines = 0; // Dynamic number of lines
//            day.setTitleColor(.black, for: .normal)
//            day.contentHorizontalAlignment = .center
//            day.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
////            day.layer.backgroundColor = self.themeColor
//            day.layer.borderWidth = 1
////            day.layer.borderColor = self.themeColor
//            day.layer.cornerRadius = 20
//            day.translatesAutoresizingMaskIntoConstraints = false
//
//            view.addSubview(day)
//
//            NSLayoutConstraint.activate([
//                day.topAnchor.constraint(equalTo: thisMonth.bottomAnchor, constant: 10),
//                day.leadingAnchor.constraint(equalTo: currentLead, constant: 25),
//                day.widthAnchor.constraint(equalToConstant: 75),
//                day.heightAnchor.constraint(equalToConstant: 100)
//            ])
//
//            currentLead = day.trailingAnchor
//            currentDay+=1
//            currentWeekday = (currentWeekday + 1)%7
//        }
//        day1.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        day1.addTarget(self, action: #selector(getTimeslot), for: .touchUpInside)
//        return days
//    }()
    
//    lazy var timeslots: [UILabel] = {
//        var timeslots: [UILabel] = [UILabel(), UILabel(), UILabel(),UILabel(), UILabel()]
//
//        let date = Date()
//        let calendar = Calendar.current
//
//        var currentHour = calendar.component(.hour, from: date)
//        // First time-line starts t minus 1 hour and last is t plus 3 hours
//        currentHour -= 1
//
//        var currentTopAnchor = ongoing.bottomAnchor
//
//        for label in timeslots {
//            let title = UILabel()
//            let bigline = "   ——————————————————"
//            if currentHour >= 12 {
//                if (currentHour == 12) { title.text = "12:00 PM" + bigline }
//                else if (currentHour == 24) { title.text = "12:00 AM" + bigline}
//                else { title.text = String(currentHour - 12) + ":00 PM" + bigline}
//            }
//            else { title.text = String(currentHour) + ":00 AM" + bigline}
//            title.textColor = .gray
//            title.font = .systemFont(ofSize: 18, weight: .bold)
//
//            title.translatesAutoresizingMaskIntoConstraints = false
//
//            view.addSubview(title)
//
//            NSLayoutConstraint.activate([
//                title.topAnchor.constraint(equalTo: currentTopAnchor, constant: 40),
//                title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            ])
//            currentHour += 1
//            currentTopAnchor = title.bottomAnchor
//        }
//        return timeslots
//    }()
    
    
    
    init(courseId: String, courseCode: String, courseColor: UIColor) {
        super .init(nibName: nil, bundle: nil)
        self.courseCode = courseCode
        self.courseColor = courseColor
        self.courseId = courseId
        
        let date = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from:date))
        let day = String(calendar.component(.day, from:date))

        if let sessionToken = userDefaults.value(forKey: Constants.UserDefaults.sessionToken) as? String {
            NetworkManager.get_timeslots(fromSessionToken: sessionToken, forCourseId: courseId, forMonth: month, forDay: day) { timeslotsResponse in
                self.timeslots = timeslotsResponse.timeslots
                DispatchQueue.main.async {
                    self.timeslotsCollectionView.reloadData()
                }
            }
        } else {
            // Session token doesn't exist
            UIApplication.shared.windows.first?.rootViewController = LoginController()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    
    // Required initializer...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stringifyMonth(month: Int) -> String {
        let monthDic:[Int: String] = [1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June",
                                      7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]
        if (month < 1 || month > 12) { return "WTF ARE YOU DOING" }
        else {return monthDic[month]!}
    }
    
    func setGradientBackground() {
//        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.783, green: 1, blue: 0.961, alpha: 0.7).cgColor,
            UIColor(red: 0.783, green: 1, blue: 0.961, alpha: 0.7).cgColor
        ]
        gradientLayer.locations = [0, 0.96, 1]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc func getTimeslot() {
        let next = TimeslotController()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func setUpConstraints() {
        icon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
        }
        
        courseCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(courseCodeLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        leftMonthLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(monthLabel.snp.centerY)
        }
        
        rightMonthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(monthLabel.snp.centerY)
        }
        
        ongoingLabel.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        timeslotsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ongoingLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

extension CourseController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeslots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeslotsReuseIdentifier, for: indexPath) as! TimeslotCollectionViewCell
        let timeslot = self.timeslots[indexPath.item]
        var instructorNames: [String] = []
        for instructor in timeslot.instructors {
            instructorNames.append(instructor.name)
        }
        cell.configure(title: timeslot.title ,startTime: timeslot.start_time, endTime: timeslot.end_time, color: self.courseColor, instructorsString: instructorNames.joined(separator: ", "))
            
        return cell
    }
}

extension CourseController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let timeslot = self.timeslots[indexPath.item]
        var instructorNames: [String] = []
        for instructor in timeslot.instructors {
            instructorNames.append(instructor.name)
        }
        
        self.navigationController?.pushViewController(TimeslotController(timeslotId: timeslot.id, timeslotName: timeslot.title, timeslotInstructors: instructorNames.joined(separator: ","), courseId: self.courseId, courseCode: self.courseCode, courseColor: self.courseColor), animated: true)
    }
    
}

extension CourseController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * (313.0 / 375.0)
        return CGSize(width: width, height: 120)
    }
}

