//
//  HomeController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/2/22.
//

import UIKit
import SwiftUI
import SnapKit

class HomeController: UIViewController {
    
    var logo: UIImageView!
    var header: UILabel!
    var collectionView: UICollectionView!
    
    let cellPadding:CGFloat = 24
    
    // Reuse identifiers
    let coursesReuseIdentifier = "coursesReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setGradientBackground()
        
        logo = UIImageView(image: UIImage(named: "Sprite"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        header = UILabel()
        header.textAlignment = .left
        header.text = "Hi, [User's name]"
        header.font = UIFont.boldSystemFont(ofSize: 22)
        header.numberOfLines = 0
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        let verticalLayout = UICollectionViewFlowLayout()
        verticalLayout.scrollDirection = .vertical
        verticalLayout.minimumLineSpacing = cellPadding
        verticalLayout.minimumInteritemSpacing = cellPadding
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalLayout)
        collectionView.backgroundColor = .none
        
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: coursesReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        setUpConstraints()
    }
    
    func setGradientBackground() {
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
    
    func setUpConstraints() {
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(6)
            make.width.height.equalTo(32)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: coursesReuseIdentifier, for: indexPath) as! CourseCollectionViewCell
        // TODO: add cell initialization

        return cell
    }
}

extension HomeController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: add request to fetch course timeslots
        
    }
    
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width - 32
        return CGSize(width: size, height: 66)
    }
}
