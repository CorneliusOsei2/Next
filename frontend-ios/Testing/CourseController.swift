//
//  CourseController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/4/22.
//

import UIKit
import SwiftUI

class CourseController: UIViewController {
    
    let courseName: String
    let officeHours: [String] // Should be networked in, i dunno how we will represent this so far.
    let datestring = DateFormatter().string(from: Date()) // "yyyy-MM-dd HH:mm:ss"
    let themeColor: CGColor
    
    lazy var icon: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Sprite")
        img.layer.cornerRadius = 5
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            img.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            img.heightAnchor.constraint(equalToConstant: CGFloat(40)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(40))
        ])
        return img
    }()
    
    lazy var courseControllerName: UILabel = {
        let title = UILabel()
        title.text = self.courseName
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 36, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])

        return title
    }()
    
    lazy var leftMonth: UILabel = {
        let date = Date()
        let calendar = Calendar.current
        let title = UILabel()
        title.text = String ("< " + stringifyMonth(month: calendar.component(.month, from:date) - 1))
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 16)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: subheader.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])

        return title
    }()
    
    lazy var rightMonth: UILabel = {
        let date = Date()
        let calendar = Calendar.current
        let title = UILabel()
        title.text = String (stringifyMonth(month: calendar.component(.month, from:date) + 1) + " >")
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 16)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: subheader.bottomAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])

        return title
    }()
    
    lazy var thisMonth: UILabel = {
        let date = Date()
        let calendar = Calendar.current
        let title = UILabel()
        title.text = String(stringifyMonth(month: calendar.component(.month, from: date)))
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 36, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: subheader.bottomAnchor, constant:10),
            title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        ])
        
        return title
    }()
    
    lazy var subheader: UIButton = {
        let button = UIButton()
        button.setTitle("    Office Hour Schedule    ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = self.themeColor
        button.layer.borderWidth = 1
        button.layer.borderColor = self.themeColor
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)

        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: courseControllerName.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
        
    lazy var dayBlocks: [UIButton] = {
        let day1 = UIButton()
        let day2 = UIButton()
        let day3 = UIButton()
        let day4 = UIButton()
        var days: [UIButton] = [day1, day2, day3, day4]
        
        let date = Date()
        let calendar = Calendar.current
        
        var currentDay = calendar.component(.day, from: date) // This is broken. It does not wrap around
        var currentLead = view.safeAreaLayoutGuide.leadingAnchor
        var currentWeekday = calendar.component(.weekday, from: Date())

        var nextWeekday : ((Int) -> String) = { (d: Int) in
            let day: [Int: String] = [1: "Mon", 2: "Tues", 3: "Wed", 4: "Thurs", 5: "Fri", 6: "Sat", 0: "Sun"]
            return day[d]!
        }
        
        for day in days {
            day.setTitle("\(currentDay)\n\(nextWeekday(currentWeekday))", for: .normal)
            day.titleLabel!.numberOfLines = 0; // Dynamic number of lines
            day.setTitleColor(.black, for: .normal)
            day.contentHorizontalAlignment = .center
            day.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
            day.layer.backgroundColor = self.themeColor
            day.layer.borderWidth = 1
            day.layer.borderColor = self.themeColor
            day.layer.cornerRadius = 20
            day.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(day)

            NSLayoutConstraint.activate([
                day.topAnchor.constraint(equalTo: thisMonth.bottomAnchor, constant: 10),
                day.leadingAnchor.constraint(equalTo: currentLead, constant: 25),
                day.widthAnchor.constraint(equalToConstant: 75),
                day.heightAnchor.constraint(equalToConstant: 100)
            ])
            
            currentLead = day.trailingAnchor
            currentDay+=1
            currentWeekday = (currentWeekday + 1)%7
        }
        day1.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        day1.addTarget(self, action: #selector(getTimeslot), for: .touchUpInside)
        return days
    }()
    
    lazy var ongoing: UILabel = {
        let title = UILabel()
        title.text = "Ongoing"
        title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        title.font = .systemFont(ofSize: 48, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: dayBlocks[0].bottomAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
        
        return title
    }()
    
    lazy var timeslots: [UILabel] = {
        var timeslots: [UILabel] = [UILabel(), UILabel(), UILabel(),UILabel(), UILabel()]
        
        let date = Date()
        let calendar = Calendar.current
        
        var currentHour = calendar.component(.hour, from: date)
        // First time-line starts t minus 1 hour and last is t plus 3 hours
        currentHour -= 1
        
        var currentTopAnchor = ongoing.bottomAnchor
        
        for label in timeslots {
            let title = UILabel()
            let bigline = "   ——————————————————"
            if currentHour >= 12 {
                if (currentHour == 12) { title.text = "12:00 PM" + bigline }
                else if (currentHour == 24) { title.text = "12:00 AM" + bigline}
                else { title.text = String(currentHour - 12) + ":00 PM" + bigline}
            }
            else { title.text = String(currentHour) + ":00 AM" + bigline}
            title.textColor = .gray
            title.font = .systemFont(ofSize: 18, weight: .bold)
            
            title.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(title)
            
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: currentTopAnchor, constant: 40),
                title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ])
            currentHour += 1
            currentTopAnchor = title.bottomAnchor
        }
        return timeslots
    }()
    
    lazy var line: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "greyline")
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: ongoing.bottomAnchor, constant: 40),
            img.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
//            img.leadingAnchor.constraint(equalTo: timeslots[0].leadingAnchor, constant: 10),
//            img.bottomAnchor.constraint(equalTo: timeslots[timeslots.count - 1].bottomAnchor)
            img.heightAnchor.constraint(equalToConstant: CGFloat(400)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(400))
        ])
        return img
    }()
    
    lazy var ticker: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "Ticker")
        img.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        
        let date = Date()
        let calendar = Calendar.current
        
        let currentHour = calendar.component(.hour, from: date)
        let currentMin = calendar.component(.minute, from: date)
        
        var offset = 120.0
        
        offset += 60.0 * (Double(currentMin)/60.0)

        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: ongoing.bottomAnchor, constant: CGFloat(offset)),
            img.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            img.heightAnchor.constraint(equalToConstant: CGFloat(70)),
            img.widthAnchor.constraint(equalToConstant: CGFloat(350))
        ])
        return img
    }()
    
    init() {
        self.courseName = "CS1110"
        officeHours = []
        themeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        super.init(nibName: nil, bundle: nil)
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
        let next = TimeSlotController()
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setGradientBackground()
        let _ = icon
        let _ = courseControllerName
        let _ = subheader
        let _ = rightMonth
        let _ = leftMonth
        let _ = thisMonth
        let _ = dayBlocks
        let _ = ongoing
        let _ = timeslots
        let _ = line
        let _ = ticker
    }
    
}

struct CourseController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
