//
//  HomeViewController.swift
//  LocalAuthenticationDemo
//
//  Created by Mayur Parmar on 26/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlet & Variables
    @IBOutlet weak var switchFaceId: UISwitch!
    @IBOutlet weak var buttonLogout: UIButton!
    
    // MARK: - Other Method
    func setupUI() {
        let userData  = UserDefaults.standard.dictionary(forKey: "userData")
        switchFaceId.isOn  = userData?["faceID"] as? Bool ?? false
        buttonLogout.addTarget(self, action: #selector(didTapButtonLogout), for: .touchUpInside)
        switchFaceId.addTarget(self, action: #selector(didTapswitch), for: .touchUpInside)
    }
}


// MARK: - View Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}


//MARK:- IBAction
extension HomeViewController {
    @objc func didTapswitch(_ sender: UISwitch) {
        var userData  = UserDefaults.standard.dictionary(forKey: "userData")
        userData?["faceID"] = sender.isOn 
        UserDefaults.standard.set(userData, forKey: "userData")
    }
    
    @objc func didTapButtonLogout() {
        var userData  = UserDefaults.standard.dictionary(forKey: "userData")
        userData?["status"] = "offline"
        UserDefaults.standard.set(userData, forKey: "userData")
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

