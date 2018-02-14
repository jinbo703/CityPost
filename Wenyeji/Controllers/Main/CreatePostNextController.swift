//
//  CreatePostSetLocationController.swift
//  Wenyeji
//
//  Created by PAC on 2/13/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SVProgressHUD

enum PostAction: String {
    case add = "ADD"
    case edit = "EDIT"
    case delete = "DELETE"
}

class CreatePostNextController: UIViewController {
    
    let cellId = "cellId"
    
    var postAction: PostAction?
    var postsController: PostsController?
    var myPostsController: MyPostsController?
    
    var post: Post?
    var nearbyTowns = [Town]()
    
    var scopes = [0, 0, 0]
    
    let countryLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Post in my Country (Kenya)"
        return label
    }()
    
    let townLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Post in my Town (Los Angels)"
        return label
    }()
    
    let nearbyTownsLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Post in my Town + Near by Towns"
        return label
    }()
    
    lazy var countryCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleCoutryCheckBox(isOn: isOn)
        }
        return box
    }()
    
    lazy var townCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleTownCheckBox(isOn: isOn)
        }
        return box
    }()
    
    lazy var nearbyTownsCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleNearbyTownsCheckBox(isOn: isOn)
        }
        return box
    }()
    
    lazy var postButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
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
        
        fetchUserInfo()
    }
}

extension CreatePostNextController {
    
    fileprivate func fetchUserInfo() {
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        
        if let user = appDelegate.user {
            self.setLocationInfo(user: user)
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
                        
                        DispatchQueue.main.async {
                            self.setLocationInfo(user: fetchedUser)
                        }
                    }
                } else {
                    
                    self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                }
                
            })
            
        }
        
    }
    
    private func setLocationInfo(user: User) {
        if let country = user.country?.countryName {
            let attributedString = GlobalFunction.getAttributedString(firstString: "Post in my Country ", secondString: "(\(country))")
            countryLabel.attributedText = attributedString
        }
        
        if let town = user.town?.townName {
            let attributedString = GlobalFunction.getAttributedString(firstString: "Post in my Town ", secondString: "(\(town))")
            townLabel.attributedText = attributedString
        }
    }
}

extension CreatePostNextController {
    
    @objc fileprivate func handleCoutryCheckBox(isOn: Bool) {
        
        if isOn {
            self.scopes = [1, 0, 0]
            self.townCheckBox.setOn(false)
            self.nearbyTownsCheckBox.setOn(false)
        } else {
            self.scopes[0] = 0
        }
    }
    
    @objc fileprivate func handleTownCheckBox(isOn: Bool) {
        if isOn {
            self.scopes = [0, 1, 0]
            self.countryCheckBox.setOn(false)
            self.nearbyTownsCheckBox.setOn(false)
        } else {
            self.scopes[1] = 0
        }
    }
    
    @objc fileprivate func handleNearbyTownsCheckBox(isOn: Bool) {
        
        if isOn {
            fetchNearbyTowns()
            self.scopes = [0, 0, 1]
            self.countryCheckBox.setOn(false)
            self.townCheckBox.setOn(false)
        } else {
            self.nearbyTowns.removeAll()
            self.tableView.reloadData()
            self.scopes[2] = 0
        }
        
    }
}

extension CreatePostNextController {
    
    @objc fileprivate func handlePost() {
        
        guard var post = self.post else { return }
        
        var scope = 1
        var connectedTowns = [String]()
        
        var checked = false
        
        for i in 0..<self.scopes.count {
            if scopes[i] == 1 {
                checked = true
                scope += i
                
                if i == 2 {
                    
                    for town in self.nearbyTowns {
                        if town.connected == "1" {
                            if let townId = town.townId {
                                connectedTowns.append(townId)
                            }
                        }
                    }
                    
                }
            }
        }
        
        if !checked {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.checkedWhereToPost.rawValue)
            return
        }
        
        let timestamp = Date().timeIntervalSince1970 as Double
        
        post.scope = String(scope)
        post.nearbyTowns = connectedTowns
        post.timestamp = String(timestamp)
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        guard let action = self.postAction else { return }
        
        let createPostRequest = CreatePostRequest(userId: userId, action: action.rawValue, post: post)
        APIService.sharedInstance.addPost(createPostRequest: createPostRequest) { (response: GeneralResponse) in
            if let error = response.error {
                print("new post error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if response.status == Status.success.rawValue {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: {
                        self.postsController?.fetchPosts()
                        self.myPostsController?.fetchPosts()
                    })
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
}

extension CreatePostNextController {
    
    fileprivate func fetchNearbyTowns() {
        
        guard let nearbyTowns = appDelegate.user?.nearbyTowns else { return }
        
        self.nearbyTowns.removeAll()
        
        for nearbyTown in nearbyTowns {
            if nearbyTown.connected == "1" {
                self.nearbyTowns.append(nearbyTown)
            }
        }
        
        self.tableView.reloadData()
    }
}

extension CreatePostNextController {
    
    func handleConnectedNearbyTown(connected: Bool, index: Int) {
        
        if connected {
            self.nearbyTowns[index].connected = "1"
        } else {
            self.nearbyTowns[index].connected = "0"
        }
    }
}

//MARK: handle table view
extension CreatePostNextController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyTowns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NearbyTownCell
        
        let nearbyTown = self.nearbyTowns[indexPath.row]
        cell.nearbyTown = nearbyTown
        cell.creatPostNextController = self
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension CreatePostNextController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = .white
        
        setupStuff()
        setupPostButton()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(NearbyTownCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: nearbyTownsLabel.bottomAnchor, left: nearbyTownsLabel.leftAnchor, bottom: postButton.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: -5, paddingBottom: 10, paddingRight: 20, width: 0, height: 0)
    }
    
    private func setupPostButton() {
        
        view.addSubview(postButton)
        postButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: 200, height: 40)
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupStuff() {
        
        view.addSubview(countryCheckBox)
        countryCheckBox.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        view.addSubview(countryLabel)
        countryLabel.anchor(top: nil, left: countryCheckBox.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        countryLabel.centerYAnchor.constraint(equalTo: countryCheckBox.centerYAnchor).isActive = true
        
        view.addSubview(townCheckBox)
        townCheckBox.anchor(top: countryCheckBox.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        view.addSubview(townLabel)
        townLabel.anchor(top: nil, left: townCheckBox.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        townLabel.centerYAnchor.constraint(equalTo: townCheckBox.centerYAnchor).isActive = true
        
        view.addSubview(nearbyTownsCheckBox)
        nearbyTownsCheckBox.anchor(top: townCheckBox.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        view.addSubview(nearbyTownsLabel)
        nearbyTownsLabel.anchor(top: nil, left: nearbyTownsCheckBox.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        nearbyTownsLabel.centerYAnchor.constraint(equalTo: nearbyTownsCheckBox.centerYAnchor).isActive = true
    }
}
