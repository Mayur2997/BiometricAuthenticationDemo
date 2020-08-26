//
//  ViewController.swift
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

class FaceIdTouchIdViewController: UIViewController {
    // MARK: - IBOutlet & Variables
    @IBOutlet weak var buttonAuth: UIButton!
     
    let context = LAContext()
     
    // MARK: - Other Method
    func showAlert(message:String) {
        let alert = UIAlertController(title: "LocalAuthentication", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func authenticate(){
        let context = LAContext()
        let reason = "use face id for Local Authentication"
        
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.showAlert(message: "User authenticated successfully")
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
extension FaceIdTouchIdViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAuth.addTarget(self, action: #selector(didTapButtonAuth), for: .touchUpInside)
        if getBiometricType() == .faceID {
            buttonAuth.setTitle("FaceID Auth", for: .normal)
        } else if getBiometricType() == .touchID {
            buttonAuth.setTitle("TouchID Auth", for: .normal)
        }
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
extension FaceIdTouchIdViewController {
    @objc func didTapButtonAuth() {
        authenticate()
    }
}


