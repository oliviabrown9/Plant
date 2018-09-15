//
//  SettingsViewController.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private let titleLabel = UILabel()
    private let servingLabel = UILabel()
    private let captionLabel = UILabel()
    private let leafButton = UIButton()
    private let calendarButton = UIButton()
    private let settingsButton = UIButton()
    private let dividerView = UIView()
    private let appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    private var currTypeIndex = 0
    private var currServingType: ServingType!
    private var currServingMaxValue: Int! {
        didSet {
            UserDefaults.standard.set(currServingMaxValue, forKey: currServingType.key)
            servingLabel.text = "\(currServingMaxValue!)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.colors.defaultGreen
        currServingType = appDelegate.servingsManager.allServingTypes[currTypeIndex]
        print(currServingType.key)

        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        setUpServingsUI()

        view.addSubview(dividerView)
        dividerView.backgroundColor = UIConstants.colors.disabledGreen

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(345)
            make.centerX.equalToSuperview()
            make.top.equalTo(captionLabel.snp.bottom).offset(40)
        }

        setUpAboutSection()
        setUpBottomButtons()
    }

    @objc func displayServings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToLeft, forKey: kCATransition)
        navigationController?.popToRootViewController(animated: false)
    }

    @objc func displayAverage() {
        navigationController?.view.layer.add(CustomTransitions().transitionToLeft, forKey: kCATransition)
        navigationController?.pushViewController(AverageViewController(), animated: false)
    }

    @objc func plusTapped() {
        currServingMaxValue += 1
    }

    @objc func minusTapped() {
        if currServingMaxValue > 1 {
            currServingMaxValue -= 1
        }
    }

    private func setUpServingsUI() {
        currServingMaxValue = appDelegate.servingsManager.getMaxServings(for: currServingType.key)
        servingLabel.font = UIFont.systemFont(ofSize: 70, weight: .black)
        servingLabel.textColor = .white
        view.addSubview(servingLabel)

        servingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }

        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        plusButton.titleLabel?.textColor = .white
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        view.addSubview(plusButton)

        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(servingLabel.snp.trailing).offset(20)
            make.centerY.equalTo(servingLabel)
        }

        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        minusButton.titleLabel?.textColor = .white
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        view.addSubview(minusButton)

        minusButton.snp.makeConstraints { make in
            make.trailing.equalTo(servingLabel.snp.leading).offset(-20)
            make.centerY.equalTo(servingLabel)
        }

        captionLabel.text = "leafy vegetables"
        captionLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        captionLabel.textColor = .white
        view.addSubview(captionLabel)

        captionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(servingLabel.snp.bottom)
        }
    }

    private func setUpAboutSection() {
        let aboutTitleLabel = UILabel()
        aboutTitleLabel.text = "About"
        aboutTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        aboutTitleLabel.textColor = .white
        view.addSubview(aboutTitleLabel)

        aboutTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(dividerView.snp.bottom).offset(30)
        }

        let aboutLabel = UILabel()
        let aboutString = "This is some text to describe the app, and it keeps going and going and going and going and going on and on. This is some text to describe the app, and it keeps going and going and going and going and going on and on and on and on and on and on and on."
        aboutLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        aboutLabel.numberOfLines = 0
        aboutLabel.lineBreakMode = .byWordWrapping
        aboutLabel.textColor = .white

        let attr = NSMutableAttributedString(string: aboutString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        aboutLabel.attributedText = attr;
        view.addSubview(aboutLabel)

        aboutLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(aboutTitleLabel.snp.bottom).offset(10)
        }

        let rateButton = UIButton()
        rateButton.setTitle("Rate plant", for: .normal)
        rateButton.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        rateButton.titleLabel?.textColor = .white
        view.addSubview(rateButton)

        rateButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(aboutLabel.snp.bottom).offset(25)
        }
    }

    private func setUpBottomButtons() {
        // MARK: Leaf Button
        leafButton.setImage(#imageLiteral(resourceName: "leafNotInUse") , for: .normal)
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
        calendarButton.addTarget(self, action: #selector(displayAverage), for: .touchUpInside)

        // MARK: Settings Button
        settingsButton.setImage(#imageLiteral(resourceName: "settingsInUse"), for: .normal)
        view.addSubview(settingsButton)

        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.centerY.equalTo(calendarButton)
        }
    }
}
