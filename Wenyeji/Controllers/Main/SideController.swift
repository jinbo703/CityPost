//
//  SideController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD

class SideController: UIViewController {
    
    let cellId = "cellId"
    
    let titles = [[AssetName.home.rawValue, "Home"],
                  [AssetName.event.rawValue, "Event"],
                  [AssetName.chat.rawValue, "Chat"],
                  [AssetName.alarm.rawValue, "Notifications"],
                  ["", ""],
                  [AssetName.profileIcon.rawValue, "My Profile"],
                  [AssetName.setting.rawValue, "Setting"],
                  ["", ""],
                  [AssetName.logout.rawValue, "Logout"]]
    
    let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: "background")?.withRenderingMode(.alwaysOriginal)
        let backgooundImageView = UIImageView(image: backgroundImage)
        backgooundImageView.contentMode = .scaleAspectFill
        return backgooundImageView
    }()
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(x: 55, y: 25, width: 80, height: 80))
        profileImageView.image = UIImage.makeLetterAvatar(withUsername: "John Nik")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        return profileImageView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .reloadSideMenu, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadSideMenu, object: nil)
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    
}

extension SideController {
}

extension SideController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        let title = titles[indexPath.row][1]
        cell.imageView?.image = UIImage(named: titles[indexPath.row][0])?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .white
        cell.textLabel?.text = title
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var navController: UINavigationController?
        
        if indexPath.row == 0 {
            let homeController = MainTabBarController()
            navController = UINavigationController(rootViewController: homeController)
        } else if indexPath.row == 5 {
            
            let profileController = ProfileController()
            profileController.profileControllerStatus = .mine
            navController = UINavigationController(rootViewController: profileController)
        } else if indexPath.row == 8 {
            
            self.handleLogOff()
            return
        } else {
            
            let randomController = UIViewController()
            randomController.view.backgroundColor = .white
            randomController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: randomController)
        }
        
        guard let embedController = navController else { return }
        
        sideMenuController?.embed(centerViewController: embedController)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: SIDE_MENU_WIDTH, height: 170))
        containerView.backgroundColor = .clear
        
        
        containerView.addSubview(profileImageView)
        
        let usernamelabel = UILabel(frame: CGRect(x: 0, y: 115, width: 190, height: 20))
        usernamelabel.font = UIFont.systemFont(ofSize: 20)
        usernamelabel.textColor = .white
        usernamelabel.textAlignment = .center
        usernamelabel.text = "John Nik"
        containerView.addSubview(usernamelabel)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4 || indexPath.row == 7 {
            return 20
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
}

//MARK: fetch user profile

//MARK: handle logout
extension SideController {
    @objc fileprivate func handleLogOff() {
        self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to Log out?", firstActionTitle: "No", secondActionTitle: "Yes") { (action) in
            
            UserDefaults.standard.setIsLoggedIn(value: false)
            
            let homeController = MainTabBarController()
            let navController = UINavigationController(rootViewController: homeController)
            self.sideMenuController?.embed(centerViewController: navController)
        }
    }
}

//MARK: setup Views
extension SideController {
    
    fileprivate func setupViews() {
        setupBackground()
        setupTableView()
    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
//        view.addSubview(backgroundImageView)
//        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    
    private func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
