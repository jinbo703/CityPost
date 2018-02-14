//
//  SignUpController.swift
//  Wenyeji
//
//  Created by PAC on 2/10/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpController: UIViewController {
    
    var datePicker = GMDatePicker()
    var dateFormatter = DateFormatter()
    
    var genderArr = [0, 0]
    
    lazy var firstnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "First Name"
        textField.borderColor = .black
        textField.textColor = .black
        return textField
    }()
    
    lazy var lastnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Last Name"
        textField.borderColor = .black
        textField.textColor = .black
        return textField
    }()
    
    lazy var birthdayTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Date of Birth (MM/DD/YYYY)"
        textField.borderColor = .black
        textField.textColor = .black
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleDatePicker), for: .touchDown)
        return textField
    }()
    
    lazy var mobileNumberTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Mobile Number"
        textField.borderColor = .black
        textField.textColor = .black
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var emailTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Email Address"
        textField.borderColor = .black
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    lazy var passwordTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = "• Password must be 8~10 Characters\n• Password must contain 1 number and 1 letter"
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = .gray
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    lazy var creatPasswordTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Create Password"
        textField.borderColor = .black
        textField.textColor = .black
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var confirmPasswordTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Confirm Password"
        textField.borderColor = .black
        textField.textColor = .black
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var maleCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleMaleBox(isOn: isOn)
        }
        return box
    }()
    
    lazy var femaleCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
                box.checkboxValueChangedBlock = {
                    isOn in
                    self.handleFemaleBox(isOn: isOn)
                }
        return box
    }()
    
    let femaleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Female"
        return label
    }()
    
    let maleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Male"
        return label
    }()
    
    lazy var signupButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("SIGN ME UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    lazy var agreeTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        //MARK: handle text attribute
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let text = "By clicking SING ME UP you agree to our Terms of Service and Privacy Policy"
        let agreeAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: style])
        
        agreeAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], range: NSRange(location: 0, length: 39))
        
        let termsRange = NSRange(location: 40, length: 16)
        let termsAttribute = ["terms": "terms of value", NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold), NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
        agreeAttributedString.addAttributes(termsAttribute.toNSAttributedStringKeys(), range: termsRange)
        
        
        agreeAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], range: NSRange(location: 56, length: 5))
        
        
        let policyRange = NSRange(location: 61, length: 14)
        let policyAttribute = ["policy": "policy of value", NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold), NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
        agreeAttributedString.addAttributes(policyAttribute.toNSAttributedStringKeys(), range: policyRange)
        
        
        textView.attributedText = agreeAttributedString
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
//        textView.isUserInteractionEnabled = true
//        textView.addGestureRecognizer(tap)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

extension SignUpController {
    
    fileprivate func handleMaleBox(isOn: Bool) {
        
        if isOn {
            
            genderArr = [1, 0]
            self.femaleCheckBox.setOn(false)
        } else {
            genderArr = [0, 0]
        }
    }
    
    fileprivate func handleFemaleBox(isOn: Bool) {
        if isOn {
            
            genderArr = [0, 1]
            self.maleCheckBox.setOn(false)
        } else {
            genderArr = [0, 0]
        }
    }
}

//MARK: handle calendar
extension SignUpController: GMDatePickerDelegate {
    
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date){
        print(date)
        
        print(dateFormatter.string(from: date))
        
        birthdayTextField.text = dateFormatter.string(from: date)
    }
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
    
    
    @objc fileprivate func handleDatePicker() {
        
        view.endEditing(true)
        datePicker.show(inVC: self)
    }
}

extension SignUpController {
    
    @objc fileprivate func handleSignup() {
        
        guard let fname = firstnameTextField.text,
            let lname = lastnameTextField.text,
            let birthday = birthdayTextField.text,
            let mobile = mobileNumberTextField.text,
            let email = emailTextField.text,
            let password = creatPasswordTextField.text else { return }
        
        let gender = getGender()
        
        let profile = Profile(userId: nil, fname: fname, lname: lname, birthday: birthday, mobile: mobile, email: email, gender: gender, password: password, profileImage: nil)
        
        
        
        APIService.sharedInstance.handleSignup(user: profile) { (signupResponse: SignUpResponse) in
            
            if let error = signupResponse.error {
                print("signup error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if signupResponse.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    guard let userId = signupResponse.userId else { return }
                    
                    let userDefaults = UserDefaults.standard
                    
                    userDefaults.setUserId(userId)
                    userDefaults.setUserFullName(fname + " " + lname)
                    
                    let user = User(userId: userId, profile: profile, country: nil, town: nil, nearbyTowns: nil)
                    appDelegate.user = user
                    
                    let chooseCityController = ChooseCityController()
                    self.navigationController?.pushViewController(chooseCityController, animated: true)
                }
            } else {
                
                if signupResponse.message == Status.emailExist.rawValue {
                    self.showErrorMessage(message: AlertMessages.existEmail.rawValue)
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
    
    private func getGender() -> String {
        
        if genderArr[0] == 1 {
            return "0"
        } else {
            return "1"
        }
        
    }
}

extension SignUpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == birthdayTextField {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == birthdayTextField {
            return false
        }
        
        return true
    }
}

extension SignUpController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: 280.0, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
    }
    
}

extension SignUpController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupTextFields()
        setupStuff()
        setupSignupButton()
        setupDatePicker()
    }
    
    func setupDatePicker() {
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = .lightGray
        datePicker.config.headerBackgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
        datePicker.config.confirmButtonColor = UIColor.white
        datePicker.config.cancelButtonColor = UIColor.white
        
    }
    
    private func setupSignupButton() {
        
        view.addSubview(signupButton)
        signupButton.anchor(top: nil, left: birthdayTextField.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(agreeTextView)
        agreeTextView.anchor(top: nil, left: birthdayTextField.leftAnchor, bottom: signupButton.topAnchor, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        textViewDidChange(agreeTextView)
    }
    
    private func setupStuff() {
    
        
        view.addSubview(maleCheckBox)
        maleCheckBox.anchor(top: confirmPasswordTextField.bottomAnchor, left: firstnameTextField.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        view.addSubview(femaleCheckBox)
        femaleCheckBox.anchor(top: confirmPasswordTextField.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        view.addSubview(maleLabel)
        maleLabel.anchor(top: nil, left: maleCheckBox.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        maleLabel.centerYAnchor.constraint(equalTo: maleCheckBox.centerYAnchor).isActive = true
        
        view.addSubview(femaleLabel)
        femaleLabel.anchor(top: nil, left: femaleCheckBox.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        femaleLabel.centerYAnchor.constraint(equalTo: femaleCheckBox.centerYAnchor).isActive = true
        
        
    }
    
    private func setupTextFields() {
        
        view.addSubview(birthdayTextField)
        
        birthdayTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 280, height: 40)
        birthdayTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(firstnameTextField)
        firstnameTextField.anchor(top: nil, left: birthdayTextField.leftAnchor, bottom: birthdayTextField.topAnchor, right: view.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        view.addSubview(lastnameTextField)
        lastnameTextField.anchor(top: nil, left: view.centerXAnchor, bottom: firstnameTextField.bottomAnchor, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(mobileNumberTextField)
        mobileNumberTextField.anchor(top: birthdayTextField.bottomAnchor, left: birthdayTextField.leftAnchor, bottom: nil, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: mobileNumberTextField.bottomAnchor, left: birthdayTextField.leftAnchor, bottom: nil, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(passwordTextView)
        passwordTextView.anchor(top: emailTextField.bottomAnchor, left: birthdayTextField.leftAnchor, bottom: nil, right: birthdayTextField.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
        textViewDidChange(passwordTextView)
        
        view.addSubview(creatPasswordTextField)
        creatPasswordTextField.anchor(top: passwordTextView.bottomAnchor, left: birthdayTextField.leftAnchor, bottom: nil, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.anchor(top: creatPasswordTextField.bottomAnchor, left: birthdayTextField.leftAnchor, bottom: nil, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupBackground() {
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "SING UP"
    }
}
