//
//  CourseCollectionViewCell.swift
//  Testing
//
//  Created by Joey Morquecho on 5/4/22.
//

import UIKit

// CourseCollectionViewCell is in a collection view in HomeController
class CourseCollectionViewCell: UICollectionViewCell {
    
    var courseCodeLabel: UILabel!
    var courseUserTypeLabel: UILabel!
    
    let courseCodeLabelHeight = 92
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        
        courseCodeLabel = UILabel()
        courseCodeLabel.backgroundColor = .white
        courseCodeLabel.text = " " + "CS 2110"
        courseCodeLabel.font = courseCodeLabel.font.withSize(16)
        courseCodeLabel.layer.cornerRadius = 6
        courseCodeLabel.layer.masksToBounds = true
        courseCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(courseCodeLabel)
        
        courseUserTypeLabel = UILabel()
        courseUserTypeLabel.backgroundColor = .white
        courseUserTypeLabel.textAlignment = .center
        courseUserTypeLabel.text = "Student"
        courseUserTypeLabel.font = courseUserTypeLabel.font.withSize(11)
        courseUserTypeLabel.layer.cornerRadius = 12
        courseUserTypeLabel.layer.masksToBounds = true
        courseUserTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(courseUserTypeLabel)
        
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Assigns Course code and user status for cell.
    func configure(code: String, userType: String, color: UIColor) {
        self.courseCodeLabel.text = "  " + code
        self.courseUserTypeLabel.text = userType
        self.contentView.backgroundColor = color
    }
    
    func setUpConstraints() {
        courseCodeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(92)
            make.height.equalTo(32)
        }
        
        courseUserTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(64)
            make.height.equalTo(24)
        }
    }
}
