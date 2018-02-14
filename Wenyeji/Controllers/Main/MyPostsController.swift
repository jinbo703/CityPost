//
//  MyPostsController.swift
//  Wenyeji
//
//  Created by PAC on 2/14/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyPostsController: PostsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    override func handleMore(post: GetPost) {
        
        self.showActionSheetWith(nil, message: "", galleryTitle: "Edit Post", galleryAction: { (action) in
            
            
            guard let userId = UserDefaults.standard.getUserId() else { return }
            guard let postId = post.postId else { return }
            guard let subject = post.subject else { return }
            guard let message = post.message else { return }
//            guard let scope = post.scope else { return }
            
            var postImageStrings = [String]()
            if let images = post.postImages, images.count > 0 {
                let imagesArray = images.components(separatedBy: ",")
                postImageStrings = imagesArray
            }
            
            let editPost = Post(userId: userId, username: nil, countryName: nil, townName: nil, postId: postId, category: Category.post.rawValue, subject: subject, message: message, postImages: postImageStrings, scope: nil, nearbyTowns: nil, timestamp: nil, eventDate: nil, eventTime: nil, eventLocation: nil, commentCount: nil, likeCount: nil, like: nil)
            
            let createPostMainController = CreatePostMainController()
            createPostMainController.postAction = .edit
            createPostMainController.post = editPost
            let navController = UINavigationController(rootViewController: createPostMainController)
            self.present(navController, animated: true, completion: nil)
            
        }, cameraTitle: "Delete Post", cameraAction: { (action) in
            
        }, completion: nil)
        
    }
    
    override func fetchPosts() {
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        let timestamp = Date().timeIntervalSince1970 as Double
        
        let getPostsRequest = GetPostsRequest(userId: userId, page: String(currentPage), timestamp: timestamp)
        
        if currentPage == 1 {
            self.posts.removeAll()
        }
        
        guard let url = GlobalFunction.getUrlFromString(ServerUrls.getMyPosts) else { return }
        
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        cell.myPostsController = self
        cell.post = posts[indexPath.item]
        return cell
    }
}
