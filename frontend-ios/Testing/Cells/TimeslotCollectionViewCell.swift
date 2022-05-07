//
//  TimeslotCollectionViewCell.swift
//  Testing
//
//  Created by Joey Morquecho on 5/6/22.
//

import UIKit

class TimeslotCollectionViewCell: UICollectionViewCell {
    
    var timeLabel: UILabel!
    var instructorsLabel: UILabel!
    var timeslotTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        
        timeLabel = UILabel()
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 16)
        timeLabel.numberOfLines = 0
        timeLabel.layer.cornerRadius = 24
        timeLabel.layer.masksToBounds = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        instructorsLabel = UILabel()
        instructorsLabel.font = .systemFont(ofSize: 12)
        instructorsLabel.textColor = .white
        instructorsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(instructorsLabel)
        
        timeslotTitleLabel = UILabel()
        timeslotTitleLabel.font = .systemFont(ofSize: 16)
        timeslotTitleLabel.textColor = .white
        timeslotTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeslotTitleLabel)
        
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, startTime: String, endTime: String, color: UIColor, instructorsString: String) {
        timeslotTitleLabel.text = title
        timeLabel.text = startTime + "\n - \n" + endTime
        instructorsLabel.text = instructorsString
        contentView.backgroundColor = color
    }
    
    func setUpConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-4)
        }
        
        timeslotTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        instructorsLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(12)
            make.top.equalTo(timeslotTitleLabel.snp.bottom).offset(12)
        }
    }
}
