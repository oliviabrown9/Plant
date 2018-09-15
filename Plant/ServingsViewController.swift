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

        let titleLabel = UILabel()
        titleLabel.text = "Today"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        //TODO: Change to custom tab bar
        setUpBottomButtons()

        // MARK: Table View
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UIConstants.layout.tableViewHeight
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(10)
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
        calendarButton.addTarget(self, action: #selector(displayAverage), for: .touchUpInside)

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

    @objc func displayAverage() {
        navigationController?.view.layer.add(CustomTransitions().transitionToLeft, forKey: kCATransition)
        navigationController?.pushViewController(AverageViewController(), animated: false)
    }

    @objc func displaySettings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToRight, forKey: kCATransition)
        navigationController?.pushViewController(SettingsViewController(), animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension ServingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentServings = currentServings else { fatalError() }
        var cell: ServingsTableViewCell? = nil
        switch indexPath.row {
        case 0:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: currentServings.leafyVegetables)
            cell?.titleLabel.text = "leafy vegetables"
        case 1:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: currentServings.otherVegetables)
            cell?.titleLabel.text = "other vegetables"
        case 2:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: currentServings.berries)
            cell?.titleLabel.text = "berries"
        case 3:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 3, numFilled: currentServings.otherFruit)
            cell?.titleLabel.text = "other fruit"
        case 4:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 5, numFilled: currentServings.wholeGrains)
            cell?.titleLabel.text = "whole grains"
        case 5:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 2, numFilled: currentServings.legumes)
            cell?.titleLabel.text = "legumes"
        case 6:
            cell = ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: currentServings.nutsAndSeeds)
            cell?.titleLabel.text = "nuts & seeds"
        default:
            break
        }

        cell?.selectionStyle = .none
        return cell ?? ServingsTableViewCell(style: .default , reuseIdentifier: "ServingCell", numSections: 1, numFilled: 0)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentServings = currentServings else { return }
        switch indexPath.row {
        case 0:
            appDelegate.servingsManager.addServing(to: currentServings.leafyVegetables, for: ServingsManager.ServingsKey.leafyVegetables)
        case 1:
            appDelegate.servingsManager.addServing(to: currentServings.otherVegetables, for: ServingsManager.ServingsKey.otherVegetables)
        case 2:
            appDelegate.servingsManager.addServing(to: currentServings.berries, for: ServingsManager.ServingsKey.berries)
        case 3:
            appDelegate.servingsManager.addServing(to: currentServings.otherFruit, for: ServingsManager.ServingsKey.otherFruit)
        case 4:
            appDelegate.servingsManager.addServing(to: currentServings.wholeGrains, for: ServingsManager.ServingsKey.wholeGrains)
        case 5:
            appDelegate.servingsManager.addServing(to: currentServings.legumes, for: ServingsManager.ServingsKey.legumes)
        case 6:
            appDelegate.servingsManager.addServing(to: currentServings.nutsAndSeeds, for: ServingsManager.ServingsKey.nutsAndSeeds)
        default:
            fatalError() // Unknown cell
        }
        tableView.reloadData()
    }
}

