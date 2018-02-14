//
//  ChooseCityController.swift
//  Wenyeji
//
//  Created by PAC on 2/10/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
import SideMenuController

class ChooseCityController: UIViewController {
    
    let cellId = "cellId"
    
    var profileController: ProfileController?
    
    var titleLabel: UILabel!
    var selectedCountry: Country?
    var selectedTown: Town?
    var towns = [Town]()
    var connectedTowns = [Town]()
    var nearbyTowns = [Town]()
    
    lazy var nextDoneButton: UIBarButtonItem = {
        let nextDoneButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(handleRightButton))
        return nextDoneButton
    }()
    
    let neighborhoodLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Choose your neighborhood"
        label.textAlignment = .center
        return label
    }()
    
    lazy var countryTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Choose your Country"
        textField.borderColor = .black
        textField.textColor = .black
        textField.addTarget(self, action: #selector(handleChooseCountry(sender:)), for: .touchDown)
        textField.delegate = self
        return textField
    }()
    
    let countryLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()
    
    lazy var cityTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Choose your City or Town"
        textField.borderColor = .black
        textField.textColor = .black
        textField.addTarget(self, action: #selector(handleChooseCity), for: .touchDown)
        textField.delegate = self
        return textField
    }()
    
    let townLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .singleLine
        tv.separatorColor = .white
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchTowns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


extension ChooseCityController {
    
    fileprivate func fetchTowns() {
        
        guard let selectedCountry = selectedCountry, let countryName = selectedCountry.countryName, let countryId = selectedCountry.countryId else { return }
        
        countryTextField.text = countryName
        let country = Country(countryId: countryId, countryName: nil, members: nil)
        
        handleGetTowns(country: country)
    }
}

extension ChooseCityController {
    
    func handleConnectedNearbyTown(connected: Bool, index: Int) {
        
        if connected {
            self.nearbyTowns[index].connected = "1"
        } else {
            self.nearbyTowns[index].connected = "0"
        }
    }
}

//MARK: handle table view
extension ChooseCityController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyTowns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NearbyTownCell
        
        let nearbyTown = self.nearbyTowns[indexPath.row]
        cell.nearbyTown = nearbyTown
        cell.chooseCityController = self
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChooseCityController {
    
    fileprivate func handleGetNearbyTowns(town: Town) {
        
        guard let countryId = self.selectedCountry?.countryId, let townId = town.townId else { return }
        let locationInfo = LocationInfo(userId: nil, countryId: countryId, townId: townId, nearbyTowns: nil)
        
        APIService.sharedInstance.getNearbyTowns(locationInfo: locationInfo) { (response: GetNearbyTownsResponse) in
            
            if let error = response.error {
                print("fetch towns error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if response.status == Status.success.rawValue {
                guard let towns = response.nearbyTowns else { return }
                
                self.nearbyTowns = towns.map { Town(townId: $0.townId, townName: $0.townName, members: $0.members, lat: nil, lon: nil, connected: "0") }
                
                DispatchQueue.main.async {
                    self.tableView.backgroundColor = StyleGuideManager.townsTableViewBackgroundColor
                    self.tableView.reloadData()
                }
            } else {
                
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
            }
            
        }
        
    }
    
}

extension ChooseCityController {
    
    @objc fileprivate func handleChooseCity() {
        
        
        guard self.towns.count > 0 else {
            self.showErrorMessage(message: AlertMessages.chooseCountry.rawValue)
            return
        }
        
        SRPopView.sharedManager().shouldShowAutoSearchBar = true
        
        let filteredArray = self.towns.map { $0.townName! }
        
        SRPopView.show(withButton: titleLabel, andArray: filteredArray, andHeading: "Wenyeji") { (townName) in
            
            guard let townName = townName else { return }
            self.cityTextField.text = townName
            
            guard let selectedTown = self.getTown(townName) else { return }
            self.selectedTown = selectedTown
            
            guard let members = selectedTown.members else { return }
            let townInfo = townName + "\n" + members + " Members"
            self.townLabel.text = townInfo
            
            self.handleGetNearbyTowns(town: selectedTown)
        }
    }
    
    private func getTown(_ townName: String) -> Town? {
        
        for i in 0..<self.towns.count {
            
            if townName == self.towns[i].townName {
                let selectedTown = self.towns[i]
                return selectedTown
            }
            
        }
        
        return nil
    }
}

extension ChooseCityController {
    
    @objc fileprivate func handleChooseCountry(sender: ToplessTextField) {
        
        view.endEditing(true)
        
        let title = "Choose your Country"
        let array = ["Kenya", "Tanzania", "Uganda"]
        let picker = self.setPickerWith(title: title, array: array, sender: sender)
        
        picker.show()
    }
    
    fileprivate func setPickerWith(title: String, array: [String], sender: ToplessTextField) -> ActionSheetStringPicker {

        let picker = ActionSheetStringPicker(title: title, rows: array, initialSelection: 0, doneBlock: { (nil, index, value) in

            guard let countryName = value as? String else { return }
            let countryId = String(index + 1)
            
            self.countryTextField.text = countryName
            self.selectedCountry = Country(countryId: countryId, countryName: countryName, members: "0")
            let country = Country(countryId: countryId, countryName: nil, members: nil)
            
            self.cityTextField.text = nil
            self.townLabel.text = nil
            
            self.handleGetTowns(country: country)

        }, cancel: { (cancelPicker) in
            return
        }, origin: sender)

        let doneImage = UIImage(named: AssetName.checked.rawValue)?.withRenderingMode(.alwaysOriginal)
        let doneButton = UIBarButtonItem(image: doneImage, style: .plain, target: nil, action: nil)

        let cancelImage = UIImage(named: AssetName.cancelPicker.rawValue)?.withRenderingMode(.alwaysOriginal)
        let cancelButton = UIBarButtonItem(image: cancelImage, style: .plain, target: nil, action: nil)

        picker?.setDoneButton(doneButton)
        picker?.setCancelButton(cancelButton)

        return picker!

    }
}

extension ChooseCityController {
    
    fileprivate func handleGetTowns(country: Country) {
        
        APIService.sharedInstance.fetchTownsInCountry(country) { (getTownsResponse: GetTownsResponse) in
            
            if let error = getTownsResponse.error {
                print("fetch towns error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if getTownsResponse.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    self.handleTowns(getTownsResponse)
                }
            } else {
                
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
            }
        }
    }
    
    private func handleTowns(_ getTownsResponse: GetTownsResponse) {
        
        guard let towns = getTownsResponse.towns else { return }
        guard let country = getTownsResponse.country else { return }
        
        self.towns.removeAll()
        self.towns = towns
        
        self.selectedCountry?.members = country.members
        guard let countryMembers = self.selectedCountry?.members, let countryName = self.selectedCountry?.countryName else { return }
        let countryInfo = countryName + "\n" + countryMembers + " Members"
        self.countryLabel.text = countryInfo
        
        if let selectedTown = selectedTown, let selectedTownName = selectedTown.townName {
            self.cityTextField.text = selectedTownName
            
            guard let tempTown = self.getTown(selectedTownName) else { return }
            self.selectedTown = tempTown
            
            guard let members = tempTown.members else { return }
            let townInfo = selectedTownName + "\n" + members + " Members"
            self.townLabel.text = townInfo
            
    
            self.tableView.backgroundColor = .lightGray
            self.tableView.reloadData()

            
        }
    }
    
    private func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
}

extension ChooseCityController {
    
    
    @objc fileprivate func handleRightButton() {
        
        if let _ = profileController {
            handleDone()
            
        } else {
            handleNext()
        }
    }
    
    private func handleDone() {
        
        guard let country = self.selectedCountry else { return }
        guard let town = self.selectedTown else { return }
        
        profileController?.resetCountry(country, town: town, nearbyTowns: self.nearbyTowns)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func handleNext() {
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        guard let countryId = self.selectedCountry?.countryId else { return }
        guard let townId = self.selectedTown?.townId else { return }
        
        var nearbyTownsString = [String]()
        
        for nearbyTown in self.nearbyTowns {
            
            if nearbyTown.connected == "1" {
                guard let townId = nearbyTown.townId else { return }
                nearbyTownsString.append(townId)
            }
        }
        
        let locationInfo = LocationInfo(userId: userId, countryId: countryId, townId: townId, nearbyTowns: nearbyTownsString)
        
        
        APIService.sharedInstance.handleRequestLocationAfterSignup(locationInfo: locationInfo) { (generalResponse: GeneralResponse) in
            
            if let error = generalResponse.error {
                print("request location error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if generalResponse.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    
                    UserDefaults.standard.setIsLoggedIn(value: true)
                    
                    appDelegate.user?.country = self.selectedCountry
                    appDelegate.user?.town = self.selectedTown
                    appDelegate.user?.nearbyTowns = self.nearbyTowns
                    
                    guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController else { return }
                    let mainTabBarController = mainController.centerViewController.childViewControllers.first as! MainTabBarController
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            } else {
                
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
            }
            
        }
    }
}

extension ChooseCityController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension ChooseCityController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupLabels()
        setupTextFields()
        setupTableView()
    }
    
    private func setupTableView() {
        
        let nearbyLabel = UILabel()
        nearbyLabel.text = "• Connect with nearby neighborhoods"
        
        view.addSubview(nearbyLabel)
        nearbyLabel.anchor(top: townLabel.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: nil, right: neighborhoodLabel.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        tableView.register(NearbyTownCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: nearbyLabel.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: neighborhoodLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    private func setupLabels() {
        
        view.addSubview(neighborhoodLabel)
        neighborhoodLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 310, height: 30)
        neighborhoodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func setupTextFields() {
        view.addSubview(countryTextField)
        countryTextField.anchor(top: neighborhoodLabel.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: nil, right: neighborhoodLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(countryLabel)
        countryLabel.anchor(top: countryTextField.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: nil, right: neighborhoodLabel.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
        view.addSubview(cityTextField)
        cityTextField.anchor(top: countryLabel.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: nil, right: neighborhoodLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(townLabel)
        townLabel.anchor(top: cityTextField.bottomAnchor, left: neighborhoodLabel.leftAnchor, bottom: nil, right: neighborhoodLabel.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
    }
    
    private func setupBackground() {
        
        view.backgroundColor = .white
        navigationItem.title = ""
        navigationItem.hidesBackButton = true
        
        var buttonTitle = "Next"
        
        if let _ = profileController {
            buttonTitle = "Done"
            navigationItem.hidesBackButton = false
        }
        nextDoneButton.title = buttonTitle
        
        navigationItem.rightBarButtonItem = nextDoneButton
    }
}
