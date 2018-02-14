//
//  PostsController.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostsController: UIViewController {
    
    let cellId = "cellId"
    
    var currentPage: Int = 1
    
    var posts = [GetPost]()
    
    var startingFrame: CGRect?
    
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    lazy var shottingButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.shottingIcon.rawValue)
        button.tintColor = .white
        button.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.layer.cornerRadius = 50 / 2
        button.layer.masksToBounds = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleShotting), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
//        cv.emptyDataSetSource = self
//        cv.emptyDataSetDelegate = self
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
//        testFectchPosts()
        fetchPosts()
    }
    func setupViews() {
        
        setupNavBar()
        setupCollectionView()
        setupShottingButton()
    }
    
    func handleMore(post: GetPost) {
        
    }
    
    func fetchPosts() {
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        let timestamp = Date().timeIntervalSince1970 as Double
        
        let getPostsRequest = GetPostsRequest(userId: userId, page: String(currentPage), timestamp: timestamp)
        
        if currentPage == 1 {
            self.posts.removeAll()
        }
        
        guard let url = GlobalFunction.getUrlFromString(ServerUrls.getPosts) else { return }
        
        APIService.sharedInstance.getPosts(getPostsRequest: getPostsRequest, url: url) { (response: GetPostsResponse) in
            if let error = response.error {
                print("new fetch profile error: ", error)
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
                return
            }
            
            if response.status == Status.success.rawValue {
                if let posts = response.posts {
                    
                    self.posts += posts
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                
                self.showErrorMessage(message: AlertMessages.somethingWentWrong.rawValue)
            }
        }
    }
    
    
}

extension PostsController {
    
    func testFectchPosts() {
        
        let post1 = GetPost(userId: "1", userName: "Caesar703", userImage: "", countryName: "United States", townName: "New York", postId: "12", category: nil, subject: "Happy Luner year", message: "All messages posted on this platform must follow the rules and guidelines. Do Not post any sexual or inappropriate or political messages. Be respectful of your neighbors.All messages posted on this platform must follow the rules and guidelines. Do Not post any sexual or inappropriate or political messages. Be respectful of your neighbors.", postImages: "1518535323.png", scope: nil, nearbyTowns: nil, timestamp: "342323", eventDate: nil, eventTime: nil, eventLocation: nil, commentcount: "3", likecount: "5", mylike: "1")
        let post4 = GetPost(userId: "1", userName: "Caesar703", userImage: "1518535323.png", countryName: "United States", townName: "New York", postId: "12", category: nil, subject: "Happy Luner year", message: "All messages posted on this platform must follow the rules and guidelines. ", postImages: "", scope: nil, nearbyTowns: nil, timestamp: "324342", eventDate: nil, eventTime: nil, eventLocation: nil, commentcount: "3", likecount: "5", mylike: "1")
        let post2 = GetPost(userId: "1", userName: "John Nik", userImage: "", countryName: "United States", townName: "New York", postId: "12", category: nil, subject: "Happy Luner year", message: "All messages posted on this platform must follow the rules and guidelines. Do Not post any sexual or inappropriate or political messages.", postImages: "1518535323.png,1518535323.png,1518535323.png,1518535323.png", scope: nil, nearbyTowns: nil, timestamp: "234243", eventDate: nil, eventTime: nil, eventLocation: nil, commentcount: "3", likecount: "5", mylike: "0")
        
        let post3 = GetPost(userId: "1", userName: "Caesar703", userImage: "1518535323.png", countryName: "United States", townName: "New York", postId: "12", category: nil, subject: "Happy Luner year", message: "All messages posted on this platform must follow the rules and guidelines. ", postImages: "1518535323.png", scope: nil, nearbyTowns: nil, timestamp: "324342", eventDate: nil, eventTime: nil, eventLocation: nil, commentcount: "3", likecount: "5", mylike: "1")
        
        self.posts.append(post1)
        self.posts.append(post2)
        self.posts.append(post4)
        self.posts.append(post3)
        
        self.collectionView.reloadData()
        
    }
    
    
    
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
}



extension PostsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        cell.postsController = self
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight = POST_CELL_HEIGHT
        let post = posts[indexPath.item]
        if let message = post.message {
            
            let height = GlobalFunction.estimateFrameForText(text: message, width: POST_TEXTVIEW_WIDTH, font: 17).height + 10
            cellHeight += height
        }
        
        if let images = post.postImages, images.count > 0 {
            cellHeight += POST_IMAGE_ITEM_SIZE_WIDTH
        }
        
        return CGSize(width: view.frame.width, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PostsController {
    
    @objc fileprivate func handleShotting() {
        
        
        self.showActionSheetWith(nil, message: "Choose A Category", galleryTitle: "Post", galleryAction: { (action) in
            let createPostMainController = CreatePostMainController()
            createPostMainController.category = .post
            createPostMainController.postAction = .add
            createPostMainController.postsController = self
            let navController = UINavigationController(rootViewController: createPostMainController)
            self.present(navController, animated: true, completion: nil)
        }, cameraTitle: "Event", cameraAction: { (action) in
            
        }, completion: nil)
        
        
    }
}

//MARK: - handle postImage
extension PostsController {
    
    
    
    //my custom zooming logic
    
    func performZoomingForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        let imageSize = startingImageView.image?.size
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //math?
                //h2 / w2 = h1 / w1
                // h2 = h1 / w1 * w2
                self.blackBackgroundView?.alpha = 1
                let height = (imageSize?.height)! / (imageSize?.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                
                //                zoomOutImageView.removeFromSuperview()
                
            })
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
        }
    }
}

extension PostsController {
    
    
    
    fileprivate func setupNavBar() {
        view.backgroundColor = .white
        navigationItem.title = "Post"
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        let refreshView = KRPullLoadView()
//        refreshView.delegate = self
//        collectionView.addPullLoadableView(refreshView)
    }
    
    fileprivate func setupShottingButton() {
        
        view.addSubview(shottingButton)
        
        _ = shottingButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 30, width: 50, height: 50)
    }
}
