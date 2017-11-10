//
//  IssueCollectionViewCell.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 10..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit

class IssueCollectionViewCell: UICollectionViewCell {
    @IBOutlet var stateButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var commentCountButton: UIButton!
}

extension IssueCollectionViewCell {
    static var cellFromNib: IssueCollectionViewCell {
        guard let cell = Bundle.main.loadNibNamed("IssueCollectionViewCell", owner: nil, options: nil)?.first as? IssueCollectionViewCell else { return IssueCollectionViewCell() }
     
        return cell
    }
    
    override func awakeFromNib() {
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //변경하기: apple mvc에서는 view가 model을 알지 못한다.
    func update(data issue: Model.Issue) {
        titleLabel.text = issue.title
        //변경하기: 모델로 분리
        let createAt =  issue.createdAt?.string(dateFormat: "dd MMM") ?? "-"
        //변경하기: 모델로 분리
        contentLabel.text = "#\(issue.number) \(issue.state.rawValue) on \(createAt) by \(issue.user.login)"
        //변경하기: 모델로 분리
        stateButton.isSelected = issue.state == .closed
        
        commentCountButton.setTitle("\(issue.comments)", for: .normal)
        let commentCountHidden = issue.comments == 0
        commentCountButton.isHidden = commentCountHidden
    }
}

//변경하기: 이건 따로 관리하자
extension Date {
    func string(dateFormat: String, locale: String = "en-US") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale(identifier: locale)
        return format.string(from: self)
    }
}
