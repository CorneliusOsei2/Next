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
    
    var status = UIButton()
    var pressed = false
    var done = UIButton()
    var waiting = UIButton()
    var ongoing = UIButton()
    var tas = UIButton()
    var liveupdates = UILabel()
    var updatetickers : [String : UILabel] = [:]
    
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
        
        let _ = icon
        let _ = courseControllerName
        let _ = subheader
        let _ = joinButton
        let _ = joinButtonlabels
        
        
        setupUpdates()
        setNotQueued()
        
    }
    
    func setupTickers() -> [UILabel] {
        var sdone = UILabel()
        var swaiting = UILabel()
        var stas = UILabel()
        var songoing = UILabel()
        
        sdone.text = "1"
        sdone.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        sdone.font = .systemFont(ofSize: 36, weight: .bold)
        sdone.translatesAutoresizingMaskIntoConstraints = false
            
        swaiting.text = "2"
        swaiting.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        swaiting.font = .systemFont(ofSize: 36, weight: .bold)
        swaiting.font = .systemFont(ofSize: 36, weight: .bold)
        swaiting.translatesAutoresizingMaskIntoConstraints = false
        
        stas.text = "3"
        stas.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stas.font = .systemFont(ofSize: 36, weight: .bold)
        stas.translatesAutoresizingMaskIntoConstraints = false
        
        songoing.text = "4"
        songoing.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        songoing.font = .systemFont(ofSize: 36, weight: .bold)
        songoing.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(sdone)
        view.addSubview(swaiting)
        view.addSubview(stas)
        view.addSubview(songoing)
        
        NSLayoutConstraint.activate([
            sdone.centerXAnchor.constraint(equalTo: done.centerXAnchor, constant: 0),
            sdone.centerYAnchor.constraint(equalTo: done.centerYAnchor, constant: -20),
            songoing.centerXAnchor.constraint(equalTo: sdone.centerXAnchor, constant: 0),
            songoing.centerYAnchor.constraint(equalTo: ongoing.centerYAnchor, constant: -20),
            stas.centerXAnchor.constraint(equalTo: tas.centerXAnchor, constant: 0),
            stas.centerYAnchor.constraint(equalTo: tas.centerYAnchor, constant: -20),
            swaiting.centerXAnchor.constraint(equalTo: waiting.centerXAnchor, constant:0),
            swaiting.centerYAnchor.constraint(equalTo: waiting.centerYAnchor, constant: -20)
        ])
        
        return [sdone, songoing, stas, swaiting]
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
        title.text = "CS 1110"
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
    
    lazy var subheader: UIButton = {
        let button = UIButton()
        button.setTitle("    12:00 PM Office Hours    ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
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
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8722903132, green: 0.6250726581, blue: 0.9617945552, alpha: 1)
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(joinQueue), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: subheader.bottomAnchor, constant: 40),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            button.widthAnchor.constraint(equalToConstant: 350),
            button.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        return button
    }()
    
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
    
    
    
    lazy var joinButtonlabels: [UILabel] = {
        let title = UILabel()
        title.text = "Consulting Hours"
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.font = .systemFont(ofSize: 24, weight: .bold)
        
        
        let subtitle = UILabel()
        subtitle.text = "Derek and Cornelius         this looks trash ik ->"
        subtitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subtitle.font = .systemFont(ofSize: 12)
        
        let now = UILabel()
        now.text = "Now"
        now.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        now.font = .systemFont(ofSize: 16, weight: .bold)

        let liveupdates = UILabel()
        liveupdates.text = "Live Updates"
        liveupdates.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        liveupdates.font = .systemFont(ofSize: 36, weight: .bold)
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        now.translatesAutoresizingMaskIntoConstraints = false
        
        liveupdates.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(now)
        view.addSubview(liveupdates)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: joinButton.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: 10),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subtitle.leadingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: 10),
            now.trailingAnchor.constraint(equalTo: joinButton.trailingAnchor, constant: -10),
            now.bottomAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: -10),
            liveupdates.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 35),
            liveupdates.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)

        ])
        
        return [title, subtitle, liveupdates]
    }()
}


