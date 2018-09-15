//
//  AverageViewController.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit
import SnapKit

class AverageViewController: UIViewController {

    private let tableView = UITableView()
    private let leafButton = UIButton()
    private let calendarButton = UIButton()
    private let settingsButton = UIButton()
    private var averageServings: ServingsManager.AverageServing!
    private let appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.colors.defaultGreen
        setUpBottomButtons()

        averageServings = appDelegate.servingsManager.fetchWeeklyAverage()

        let titleLabel = UILabel()
        titleLabel.text = "Weekly Average"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }

        let averageLabel = UILabel()
        averageLabel.text = "\(averageServings.totalCompleted)%"
        averageLabel.font = UIFont.systemFont(ofSize: 70, weight: .black)
        averageLabel.textColor = .white
        view.addSubview(averageLabel)

        averageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }

        let captionLabel = UILabel()
        captionLabel.text = "fully completed"
        captionLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        captionLabel.textColor = .white
        view.addSubview(captionLabel)

        captionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(averageLabel.snp.bottom)
        }

        // MARK: Table View
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UIConstants.layout.tableViewHeight
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(captionLabel.snp.bottom).offset(30)
            make.bottom.equalTo(leafButton.snp.top).inset(UIConstants.layout.tableViewBottomInset)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setUpBottomButtons() {
        // MARK: Leaf Button
        leafButton.setImage(#imageLiteral(resourceName: "leafInUse") , for: .normal)
        leafButton.isEnabled = true
        view.addSubview(leafButton)

        leafButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().priority(.required)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(UIConstants.layout.leafBottomOffset).priority(.medium)
            make.centerX.equalToSuperview()
        }
        leafButton.addTarget(self, action: #selector(displayServings), for: .touchUpInside)

        // MARK: Calendar Button
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNotInUse") , for: .normal)
        view.addSubview(calendarButton)

        calendarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.bottom.equalToSuperview().inset(UIConstants.layout.sideButtonBottomInset)
        }

        // MARK: Settings Button
        settingsButton.setImage(#imageLiteral(resourceName: "settingsNotInUse"), for: .normal)
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(displaySettings), for: .touchUpInside)

        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.centerY.equalTo(calendarButton)
        }
    }

    @objc func displayServings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToRight, forKey: kCATransition)
        navigationController?.popToRootViewController(animated: false)
    }

    @objc func displaySettings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToRight, forKey: kCATransition)
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}

extension AverageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let averageServings = averageServings else { fatalError() }
        var cell: ServingsTableViewCell? = nil
        switch indexPath.row {
        case 0:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: Int16(averageServings.leafyVegetables))
            cell?.titleLabel.text = "leafy vegetables"
        case 1:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: Int16(averageServings.otherVegetables))
            cell?.titleLabel.text = "other vegetables"
        case 2:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: Int16(averageServings.berries))
            cell?.titleLabel.text = "berries"
        case 3:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 3, numFilled: Int16(averageServings.otherFruit))
            cell?.titleLabel.text = "other fruit"
        case 4:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 5, numFilled: Int16(averageServings.wholeGrains))
            cell?.titleLabel.text = "whole grains"
        case 5:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: Int16(averageServings.legumes))
            cell?.titleLabel.text = "legumes"
        case 6:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: Int16(averageServings.nutsAndSeeds))
            cell?.titleLabel.text = "nuts & seeds"
        default:
            break
        }

        cell?.selectionStyle = .none
        return cell ?? ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: 0)
    }
}
