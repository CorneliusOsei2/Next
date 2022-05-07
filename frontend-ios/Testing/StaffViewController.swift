//
//  StaffViewController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/6/22.
//

import UIKit
import SwiftUI

class StaffViewController: UIViewController, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    let cellPadding: CGFloat = 24

    let coursesReuseIdentifier = "coursesReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
    }
    
    func setUpConstraints() {
        collectionView.snp.makeConstraint { (make) in
            make.top.equalTo(header.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension StaffViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

extension StaffViewController: UICollectionViewDelegate {

}

extension StaffViewController: UICollectionViewDelegateFlowLayout {
    f
}
