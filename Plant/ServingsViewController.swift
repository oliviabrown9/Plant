//
//  ServingsViewController.swift
//  Plant
//
//  Created by Olivia Brown on 8/19/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class ServingsViewController: UIViewController {

    private let tableView = UITableView()
    private let leafButton = UIButton()
    private let calendarButton = UIButton()
    private let settingsButton = UIButton()
    private let appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    private var currentServings: DailyServing?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.colors.defaultGreen
        setUpBottomButtons()

        // MARK: Table View
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UIConstants.layout.tableViewHeight
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(UIConstants.layout.tableViewTopInset)
            make.bottom.equalTo(leafButton.snp.top).inset(UIConstants.layout.tableViewBottomInset)
        }
        tableView.dataSource = self
        tableView.delegate = self

        currentServings = appDelegate.servingsManager.fetchToday()
    }

    private func setUpBottomButtons() {
        // MARK: Leaf Button
        leafButton.setImage(#imageLiteral(resourceName: "leafInUse") , for: .disabled)
        leafButton.isEnabled = false
        view.addSubview(leafButton)

        leafButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().priority(.required)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(UIConstants.layout.leafBottomOffset).priority(.medium)
            make.centerX.equalToSuperview()
        }

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

        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.centerY.equalTo(calendarButton)

        }
    }
}

extension ServingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ServingsTableViewCell? = nil
        switch indexPath.row {
        case 0:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2)
            cell?.titleLabel.text = "leafy vegetables"
        case 1:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2)
            cell?.titleLabel.text = "other vegetables"
        case 2:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1)
            cell?.titleLabel.text = "berries"
        case 3:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 3)
            cell?.titleLabel.text = "other fruit"
        case 4:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 5)
            cell?.titleLabel.text = "whole grains"
        case 5:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2)
            cell?.titleLabel.text = "legumes"
        case 6:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1)
            cell?.titleLabel.text = "nuts & seeds"
        default:
            break
        }

        cell?.selectionStyle = .none
        return cell ?? ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentServings = currentServings else { return }
        switch indexPath.row {
        case 0:
            appDelegate.servingsManager.save(numServings: currentServings.leafyVegetables + Int16(1), for: "leafyVegetables")
        case 1:
            appDelegate.servingsManager.save(numServings: currentServings.otherVegetables + Int16(1), for: "otherVegetables")
        case 2:
            appDelegate.servingsManager.save(numServings: currentServings.berries + Int16(1), for: "berries")
        case 3:
            appDelegate.servingsManager.save(numServings: currentServings.otherFruit + Int16(1), for: "otherFruit")
        case 4:
            appDelegate.servingsManager.save(numServings: currentServings.wholeGrains + Int16(1), for: "wholeGrains")
        case 5:
            appDelegate.servingsManager.save(numServings: currentServings.legumes + Int16(1), for: "legumes")
        case 6:
            appDelegate.servingsManager.save(numServings: currentServings.nutsAndSeeds + Int16(1), for: "nutsAndSeeds")
        default:
            // Unknown cell
            fatalError()
        }
        print(appDelegate.servingsManager.servingsHistory)
    }
}

