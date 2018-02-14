//
//  SettingController.swift
//  Wenyeji
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import ImagePicker
import SVProgressHUD
import SDWebImage

enum ProfileControllerStatus {
    case mine
    case others
}

class ProfileController: UIViewController {
    
    var profileControllerStatus: ProfileControllerStatus = .mine
    
    var userId: String?
    var profileImageString = ""
    
    var user: User? {
        
        didSet {
        }
    }
    
    var datePicker = GMDatePicker()
    var dateFormatter = DateFormatter()
    
    let profileEmailCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let profileMobileCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    let profileCountryCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let profileTownCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let profileNearbyTownsCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.makeLetterAvatar(withUsername: "Unknown User")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorColor = .white
        tv.separatorStyle = .singleLine
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    lazy var firstnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "First Name"
        textField.text = ""
        textField.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var lastnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Last Name"
        textField.text = ""
        textField.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var birthdayTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Date of Birth (MM/DD/YYYY)"
        textField.text = ""
        textField.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = .white
                textField.delegate = self
        textField.isUserInteractionEnabled = false
                textField.addTarget(self, action: #selector(handleDatePicker), for: .touchDown)
        return textField
    }()
    
    let emailTextField: ToplessTextField = {
        let textField = ToplessTextField()
        textField.frame = CGRect(x: 20, y: 10, width: DEVICE_WIDTH - 40, height: 40)
        textField.placeholder = "Email"
        textField.borderColor = .white
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let mobileTextField: ToplessTextField = {
        let textField = ToplessTextField()
        textField.frame = CGRect(x: 20, y: 10, width: DEVICE_WIDTH - 40, height: 40)
        textField.placeholder = "Mobile Number"
        textField.borderColor = .white
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: DEVICE_WIDTH - 40, height: 40)
        label.text = "My Country"
        label.textColor = .black
        return label
    }()
    
    let townLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: DEVICE_WIDTH - 40, height: 40)
        label.text = "My Town/City"
        label.textColor = .black
        return label
    }()
    
    let nearbyTownsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: DEVICE_WIDTH - 40, height: 40)
        label.text = "My Nearby Town/City"
        label.textColor = .black
        return label
    }()
    
    lazy var editDoneButton: UIBarButtonItem = {
        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditDone))
        return rightBarButton
    }()
    
    lazy var shottingButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.shottingIcon.rawValue)
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleShotting), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchProfile()
    }
    
    
}

//MARK: handle calendar
extension ProfileController: GMDatePickerDelegate {
    
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

extension ProfileController {
    @objc fileprivate func handleShotting() {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        var selectImage: UIImage = UIImage()
        for image in images{
            selectImage = image
        }
        
        guard let resizedImage = selectImage.resized(toWidth: 200) else { return }
        
        guard let imageString = GlobalFunction.getBase64StringFromImage(resizedImage) else { return }
        profileImageString = imageString
        self.profileImageView.image = resizedImage
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ProfileController: UITextFieldDelegate {
    
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

extension ProfileController {
    
    func resetCountry(_ country: Country, town: Town, nearbyTowns: [Town]) {
        
        user?.country = country
        user?.town = town
        user?.nearbyTowns = nearbyTowns
        
        setupLocationInfo()
    }
    
    fileprivate func setupLocationInfo() {
        if let countryName = user?.country?.countryName {
            let countryAttirbutedString = GlobalFunction.getAttributedString(firstString: "Country:  ", secondString: countryName)
            countryLabel.attributedText = countryAttirbutedString
        }
        
        if let townName = user?.town?.townName {
            let townAttributedString = GlobalFunction.getAttributedString(firstString: "Town/City:  ", secondString: townName)
            townLabel.attributedText = townAttributedString
        }
        
        if let nearbyTowns = user?.nearbyTowns {
            
            var connectedCount = 0
            let nearbyTownsCount = nearbyTowns.count
            
            for nearbyTown in nearbyTowns {
                if nearbyTown.connected == "1" {
                    connectedCount += 1
                }
            }
            
            let nearbyTownsAttributedString = GlobalFunction.getAttributedString(firstString: "Nearby Town/City:  ", secondString: "\(String(connectedCount)) of \(String(nearbyTownsCount))")
            nearbyTownsLabel.attributedText = nearbyTownsAttributedString
        }
    }
}

extension ProfileController {
    
    fileprivate func fetchProfile() {
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        
        if let user = appDelegate.user {
            self.user = user
            setupProfile()
        } else {
            let user = User(userId: userId, profile: nil, country: nil, town: nil, nearbyTowns: nil)
            APIService.sharedInstance.fetchProfile(user: user, completion: { (response: GetProfileResponse) in
                
                if let error = response.error {
                    print("new fetch profile error: ", error)
                    self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                    return
                }
                
                if response.status == Status.success.rawValue {
                    if let fetchedUser = response.userInfo {
                        appDelegate.user = fetchedUser
                        self.user = fetchedUser
                        
                        DispatchQueue.main.async {
                            self.setupProfile()
                        }
                    }
                } else {
                    
                    self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                }
                
            })
            
        }
        
    }
    
    fileprivate func setupProfile() {
        
        guard let user = self.user else { return }

        editDoneButton.title = "Edit"
        shottingButton.isHidden = true
        firstnameTextField.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        birthdayTextField.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        emailTextField.borderColor = .white
        mobileTextField.borderColor = .white
        
        firstnameTextField.isUserInteractionEnabled = false
        birthdayTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        mobileTextField.isUserInteractionEnabled = false
        
        if let email = user.profile?.email {
            let emailAttirbutedString = GlobalFunction.getAttributedString(firstString: "Email:  ", secondString: email)
            self.emailTextField.attributedText = emailAttirbutedString
        }

        if let mobile = user.profile?.mobile {
            let mobileAttributedString = GlobalFunction.getAttributedString(firstString: "Mobile Number:  ", secondString: mobile)
            mobileTextField.attributedText = mobileAttributedString
        }
        
        if let birthday = user.profile?.birthday {
            birthdayTextField.text = "Birthday:  " + birthday
        }
        
        if let imageString = user.profile?.profileImage {
            
            if let urlStr = (ServerUrls.profileImageBaseUrl + imageString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlStr) {
                profileImageView.sd_addActivityIndicator()
                profileImageView.sd_setImage(with: url, completed: nil)
            }
            
            
        } else {
            if let fullName = UserDefaults.standard.getFullname() {
                self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: fullName)
            } else {
                if let fname = user.profile?.fname, let lname = user.profile?.lname {
                    self.profileImageView.image = UIImage.makeLetterAvatar(withUsername: fname + " " + lname)
                }
            }
        }
        
        if let fullName = UserDefaults.standard.getFullname() {
            self.firstnameTextField.text = fullName
        } else {
            if let fname = user.profile?.fname, let lname = user.profile?.lname {
                self.firstnameTextField.text = fname + " " + lname
                UserDefaults.standard.setUserFullName(fname + " " + lname)
            }
            
        }

        setupLocationInfo()
        
    }
}

extension ProfileController {
    
    private func handleEdit() {
        editDoneButton.title = "Done"
        
        firstnameTextField.borderColor = .white
        birthdayTextField.borderColor = .white
        emailTextField.borderColor = .black
        mobileTextField.borderColor = .black
        
        firstnameTextField.isUserInteractionEnabled = true
        birthdayTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        mobileTextField.isUserInteractionEnabled = true
        shottingButton.isHidden = false
        
        if let birhtday = user?.profile?.birthday {
            birthdayTextField.text = birhtday
        }
        
        if let email = user?.profile?.email {
            emailTextField.text = email
        }
        
        if let mobile = user?.profile?.mobile {
            mobileTextField.text = mobile
        }
    }
    
    private func handleDone() {
        
        
        if !checkInvalid() {
            return
        }
        
        
        guard let fullname = firstnameTextField.text else { return }
        guard let birthday = birthdayTextField.text else { return }
        guard let mobile = mobileTextField.text else { return }
        guard let email = emailTextField.text else { return }
        
        let fullNameArr = fullname.components(separatedBy: " ")
        let fname = fullNameArr[0]
        var lname = ""
        if fullNameArr.count > 1 {
            lname = fullNameArr[1]
        }
        
        let profile = Profile(userId: nil, fname: fname, lname: lname, birthday: birthday, mobile: mobile, email: email, gender: nil, password: nil, profileImage: profileImageString)
        
        self.user?.profile = profile
        
        guard let user = self.user,
            let userId = user.userId,
            let countryId = user.country?.countryId,
            let townId = user.town?.townId,
            let nearbyTowns = user.nearbyTowns else { return }
        
        var nearbyTownsString = [String]()
        
        for nearbyTown in nearbyTowns {
            if nearbyTown.connected == "1" {
                if let nearbyTownId = nearbyTown.townId {
                    nearbyTownsString.append(nearbyTownId)
                }
                
            }
        }
        
        let updateUser = UpdateUser(userId: userId, profile: profile, countryId: countryId, townId: townId, nearbyTowns: nearbyTownsString)
        
        APIService.sharedInstance.updateProfile(user: updateUser) { (response) in
            if let error = response.error {
                print("new post error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if response.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    self.setupProfile()
                    self.showErrorMessage(message: "Success!")
                }
            } else {
                
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
            }
        }
    }
    
    fileprivate func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
    
    @objc fileprivate func handleEditDone() {
        
        if editDoneButton.title == "Edit" {
            
            handleEdit()
            
        } else {
            handleDone()
            
        }
        
    }
}

//MARK: check valid
extension ProfileController {
    
    fileprivate func checkInvalid() -> Bool {
        
        if (emailTextField.text?.isEmptyStr)! || !self.isValidEmail(emailTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Email!\nPlease type valid Email")
            return false
        }
        
        if (firstnameTextField.text?.isEmptyStr)! || !self.isValidPassword(firstnameTextField.text!) {
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
        if password.count >= 1 {
            return true
        } else {
            return false
        }
    }
}

extension ProfileController {
    
    func resetUser(country: Country, town: Town, nearbyTowns: [Town]) {
        
        self.user?.country = country
        self.user?.town = town
        self.user?.nearbyTowns = nearbyTowns
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return self.profileEmailCell
            } else {
                return self.profileMobileCell
            }
        } else {
            if indexPath.row == 0 {
                return self.profileCountryCell
            } else if indexPath.row == 1 {
                return self.profileTownCell
            } else {
                return self.profileNearbyTownsCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.editDoneButton.title == "Done" {
            
            if indexPath.section == 1 {
                
                let chooseCityController = ChooseCityController()
                
                guard let country = user?.country else { return }
                guard let town = user?.town else { return }
                guard let nearbyTowns = user?.nearbyTowns else { return }
                
                chooseCityController.selectedCountry = country
                chooseCityController.selectedTown = town
                chooseCityController.nearbyTowns = nearbyTowns
                chooseCityController.profileController = self
                navigationController?.pushViewController(chooseCityController, animated: true)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.backgroundColor = StyleGuideManager.townsTableViewBackgroundColor
            return view
        } else {
            
            return nil
        }
    }
}


extension ProfileController {
    
    fileprivate func setupViews() {
        setupBackground()
        setupNavBar()
        setupImageView()
        setupTextFields()
        setupTableView()
        setupCells()
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
    
    private func setupCells() {
        profileEmailCell.addSubview(emailTextField)
        profileMobileCell.addSubview(mobileTextField)
        profileCountryCell.addSubview(countryLabel)
        profileTownCell.addSubview(townLabel)
        profileNearbyTownsCell.addSubview(nearbyTownsLabel)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Profile"
        
        
        navigationItem.rightBarButtonItem = editDoneButton
    }
    
    private func setupTextFields() {
        
        view.addSubview(birthdayTextField)
        birthdayTextField.anchor(top: nil, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        view.addSubview(firstnameTextField)
        firstnameTextField.anchor(top: nil, left: birthdayTextField.leftAnchor, bottom: birthdayTextField.topAnchor, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 0, height: 40)
        
//        view.addSubview(lastnameTextField)
//        lastnameTextField.anchor(top: nil, left: birthdayTextField.centerXAnchor, bottom: firstnameTextField.bottomAnchor, right: birthdayTextField.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupImageView() {
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        if profileControllerStatus == .mine {
            
            view.addSubview(shottingButton)
            shottingButton.anchor(top: nil, left: nil, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
            
            shottingButton.isHidden = true
        }
    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
    }
}
