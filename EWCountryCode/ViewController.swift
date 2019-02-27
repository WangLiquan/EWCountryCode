//
//  ViewController.swift
//  EWCountryCode
//
//  Created by Ethan.Wang on 2018/11/14.
//  Copyright © 2018 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let showButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - 200)/2, y: 450, width: 200, height: 50))
        button.backgroundColor = UIColor.gray
        button.setTitle("选择国家区号", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(onClickShowButton), for: .touchUpInside)
        return button
    }()
    private let showCountryLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - 300)/2, y: 250, width: 300, height: 75))
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "国家"
        return label
    }()
    private let showCodeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - 300)/2, y: 350, width: 300, height: 75))
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "地区"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "demo"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(showCountryLabel)
        self.view.addSubview(showCodeLabel)
        self.view.addSubview(showButton)
    }

    @objc private func onClickShowButton() {
        let vc = EWCountryCodeViewController()
        vc.backCountryCode = { [weak self] country, code in
            self?.showCountryLabel.text = country
            self?.showCodeLabel.text = code
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
