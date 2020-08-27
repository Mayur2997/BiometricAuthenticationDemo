//
//  LoginViewController.swift
//  LocalAuthenticationDemo
//
//  Created by Mayur Parmar on 26/08/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit
import LocalAuthentication

//Mark: For select type of your biometric
enum BiometricType{
    case touchID
    case faceID
    case none
}

class LoginViewController: UIViewController {
    // MARK: - IBOutlet & Variables
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonFaceIDLogin: UIButton!
     
    // MARK: - Other Method
    func showAlert(message:String) {
        let alert = UIAlertController(title: "LocalAuthentication", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkLogin() -> Bool {
        if txtEmail.text! == "admin@gmail.com" && txtPassword.text! == "123456" {
            return true
        } else {
            return false
        }
    }
    
    func isFaceIDEnable() -> Bool {
        let userData = UserDefaults.standard.dictionary(forKey: "userData") ?? nil
        if userData != nil {
            return userData?["faceID"] as? Bool ?? false
        }
        return false
    }
    
    // detect your device.
    func getBiometricType() -> BiometricType {
        let authenticationContext = LAContext()
        authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch (authenticationContext.biometryType){
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
    func authenticate() {
        let context = LAContext()
        let reason = "use face id for Local Authentication"
        
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.txtEmail.text = ""
                        self.txtPassword.text = ""
                        let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        } else {
            let message: String
            switch authError {
            case LAError.authenticationFailed?:
              message = "There was a problem verifying your identity."
            case LAError.userCancel?:
              message = "You pressed cancel."
            case LAError.userFallback?:
              message = "You pressed password."
            case LAError.biometryNotAvailable?:
              message = "Face ID/Touch ID is not available."
            case LAError.biometryNotEnrolled?:
              message = "Face ID/Touch ID is not set up."
            case LAError.biometryLockout?:
              message = "Face ID/Touch ID is locked."
            default:
              message = "Face ID/Touch ID may not be configured"
            }
            self.showAlert(message: "\(message)")
        }
    }
}


// MARK: - View Life Cycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if getBiometricType() == .faceID {
            buttonFaceIDLogin.setTitle("Login with FaceID", for: .normal)
        } else if getBiometricType() == .touchID {
            buttonFaceIDLogin.setTitle("Login with TouchID", for: .normal)
        }  
        buttonLogin.addTarget(self, action: #selector(didTapButtonLogin), for: .touchUpInside)
        buttonFaceIDLogin.addTarget(self, action: #selector(didTapButtonFaceID), for: .touchUpInside)
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
extension LoginViewController {
    @objc func didTapButtonLogin() {
        if checkLogin() {
            let userData = UserDefaults.standard.dictionary(forKey: "userData") ?? nil
            if userData == nil {
                UserDefaults.standard.set(["user" : "admin@gmail.com", "faceID" : false, "status": "active"], forKey: "userData")
            } else {
                var userData  = UserDefaults.standard.dictionary(forKey: "userData")
                userData?["status"] = "active"
                UserDefaults.standard.set(userData, forKey: "userData")
            }
            self.txtEmail.text = ""
            self.txtPassword.text = ""
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func didTapButtonFaceID() {
        if isFaceIDEnable() {
            authenticate()
        } else {
            self.showAlert(message: "FaceID or TouchID is disable")
        }
    }
}

