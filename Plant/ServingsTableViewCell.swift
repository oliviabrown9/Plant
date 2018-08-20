//
//  ServingTableViewCell.swift
//  Plant
//
//  Created by Olivia Brown on 8/19/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class ServingsTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    var tracker: UIStackView?

    init(style: UITableViewCellStyle, reuseIdentifier: String?, numSections: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // MARK: Title Label
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview()
        }

        var trackerSubviews = [UIView]()
        let trackerSubviewWidth = calculateTrackerSectionWidth(for: numSections)
        for _ in 0..<numSections {
            let trackerSubview = UIView()
            trackerSubview.backgroundColor = UIConstants.colors.disabledGreen
            trackerSubview.layer.cornerRadius = 5
            trackerSubview.snp.makeConstraints { make in
                make.height.equalTo(26)
                make.width.equalTo(trackerSubviewWidth)
            }
            trackerSubviews.append(trackerSubview)
        }
        tracker = UIStackView(arrangedSubviews: trackerSubviews)
        guard let tracker = tracker else { fatalError() }


        tracker.distribution = .fill
        tracker.spacing = 10.0
        tracker.alignment = .center
        addSubview(tracker)

        tracker.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
        }

        for subView in tracker.subviews {
            subView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).inset(20)
            }
        }
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func calculateTrackerSectionWidth(for numSections: Int) -> Double {
        let fullWidth = Double(345)
        let spacingWidth = Double(10 * (numSections - 1))
        let myWidth = (fullWidth - spacingWidth) / Double(numSections)
        return myWidth
    }

}
