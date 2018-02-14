//
//  LoginController.swift
//  Wenyeji
//
//  Created by PAC on 2/9/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import SideMenuController

var appDelegate = UIApplication.shared.delegate as! AppDelegate

class LoginController: UIViewController {
    
    lazy var emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.title = "Email"
        textField.iconFont = UIFont(name: "FontAwesome", size: 20)
        textField.iconText = AssetName.email.rawValue
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.setPropertiesForLoginPage()
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.title = "Password"
        textField.iconFont = UIFont(name: "FontAwesome", size: 20)
        textField.iconText = AssetName.password.rawValue
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.setPropertiesForLoginPage()
        textField.delegate = self
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = StyleGuideManager.mainGreenBackgroundColor
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleFogotPassword), for: .touchUpInside)
        
        return button
    }()
    
    lazy var signupButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        emailTextField.text = "Test4@hotmail.com"
        passwordTextField.text = "caesar"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
}

extension LoginController {
    
    @objc fileprivate func handleSignUp() {
        
        let signupController = SignUpController()
        
        navigationController?.pushViewController(signupController, animated: true)
    }
}

extension LoginController {
    
    @objc fileprivate func handleFogotPassword() {
        
    }
}

//MARK: check valid
extension LoginController {
    
    fileprivate func checkInvalid() -> Bool {
        
        if (emailTextField.text?.isEmptyStr)! || !self.isValidEmail(emailTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Email!\nPlease type valid Email")
            return false
        }
        
        if (passwordTextField.text?.isEmptyStr)! || !self.isValidPassword(passwordTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Password!\nPlease type valid Password")
            return false
        }
        return true
    }
    
    fileprivate func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    fileprivate func isValidPassword(_ password: String) -> Bool {
        if password.count >= 5 {
            return true
        } else {
            return false
        }
    }
}

extension LoginController {
    
    @objc fileprivate func handleLogin() {
        
        view.endEditing(true)
        
        if !checkInvalid() {
            return
        }
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        let user = Profile(userId: nil, fname: nil, lname: nil, birthday: nil, mobile: nil, email: email, gender: nil, password: password, profileImage: nil)
        
        
        APIService.sharedInstance.hadleLogin(user: user) { (loginResponse: LoginResponse) in
            
            if let error = loginResponse.error {
                print("login error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if loginResponse.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    guard let user = loginResponse.userInfo else { return }
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.setIsLoggedIn(value: true)
                    
                    if let userId = user.userId, let fname = user.profile?.fname, let lname = user.profile?.lname {
                        userDefaults.setUserId(userId)
                        userDefaults.setUserFullName(fname + " " + lname)
                    }
                    
                    
                    
                    appDelegate.user = user
                    
                    guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController else { return }
                    let mainTabBarController = mainController.centerViewController.childViewControllers.first as! MainTabBarController
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                
                if loginResponse.message == Status.notExistEmail.rawValue {
                    self.showErrorMessage(message: AlertMessages.notExistEmail.rawValue)
                } else {
                    self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                }
            }
        }
    }
    
    private func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
}

//MARK: handle textfield invalid
extension LoginController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        
        if textField == emailTextField {
            if let emailField = textField as? SkyFloatingLabelTextFieldWithIcon {
                
                if self.isValidEmail(text) {
                    emailField.errorMessage = ""
                } else {
                    emailField.errorMessage = "Invalid Email"
                }
                
            }
            return true
        } else {
            if let passwordField = textField as? SkyFloatingLabelTextFieldWithIcon {
                if self.isValidPassword(text) {
                    passwordField.errorMessage = ""
                } else {
                    passwordField.errorMessage = "Weak Password"
                }
            }
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}

extension LoginController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupTextField()
        setupButtons()
    }
    
    
    
    private func setupButtons() {
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: forgotPasswordButton.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(signupButton)
        
        signupButton.anchor(top: loginButton.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: forgotPasswordButton.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupTextField() {
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: nil, left: nil, bottom: view.centerYAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 280, height: 50)
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: nil, left: passwordTextField.leftAnchor, bottom: passwordTextField.topAnchor, right: passwordTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.loginPageBackgroundColor
        
        let image = UIImage(named: AssetName.appIconImage.rawValue)
        let imageView = UIImageView(image: image)
        
        guard let imageWidth = image?.size.width, let imageHeigt = image?.size.height else { return }
        
        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200 * imageHeigt / imageWidth)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tempView = UIView()
        tempView.backgroundColor = StyleGuideManager.loginPageBackgroundColor
        
        imageView.addSubview(tempView)
        tempView.anchor(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
    }
}

extension SkyFloatingLabelTextFieldWithIcon {
    
    func setPropertiesForLoginPage() {
        self.placeholderColor = .darkGray
        self.lineColor = .darkGray
        self.iconColor = .darkGray
        
        self.tintColor = StyleGuideManager.defaultBackgroundColor
        self.selectedTitleColor = StyleGuideManager.defaultBackgroundColor
        self.selectedLineColor = StyleGuideManager.defaultBackgroundColor
        self.selectedIconColor = StyleGuideManager.defaultBackgroundColor
        self.textColor = .black
    }
}

