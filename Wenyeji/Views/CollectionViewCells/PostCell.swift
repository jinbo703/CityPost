//
//  Post.swift
//  Wenyeji
//
//  Created by PAC on 2/13/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import ReadMoreTextView

let POST_CELL_HEIGHT: CGFloat = 5 + 40 + 5 + 50 + 5 + 10 + 25 + 10 

class PostCell: BaseCollectionViewCell {
    
    let cellId = "cellId"
    
    var postsController: PostsController?
    var myPostsController: MyPostsController?
    
    var postImages = [String]()
    
    var post: GetPost? {
        
        didSet {
            
            guard let post = post else { return }
            
            self.setupPost(post)
        }
    }
    
    var messageViewHeightConstraint: NSLayoutConstraint?
    var collectionViewConstraint: NSLayoutConstraint?
    
    lazy var userImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.makeLetterAvatar(withUsername: "John Nik")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = ""
        label.textColor = .black
        return label
    }()
    
    let locationLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    lazy var moreButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.moreOther.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        return button
        
    }()
    
    let subjectLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let messageTextView: ReadMoreTextView = {
        let textView = ReadMoreTextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = ""
        textView.textColor = .black
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        
//        let readMoreTextAttributes: [NSAttributedStringKey: Any] = [
//            NSAttributedStringKey.foregroundColor: StyleGuideManager.mainLightBlueBackgroundColor,
//            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)
//        ]
//        let readLessTextAttributes = [
//            NSAttributedStringKey.foregroundColor: UIColor.red,
//            NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 16)
//        ]
//
//        textView.attributedReadMoreText = NSAttributedString(string: "... Read more", attributes: readMoreTextAttributes)
//        textView.attributedReadLessText = NSAttributedString(string: " Read less", attributes: readLessTextAttributes)
//        textView.maximumNumberOfLines = 3
//        textView.shouldTrim = true
        return textView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var likeButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.unlike.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        return button
        
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comments: 0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .darkGray
        return button
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "Likes: 0"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
        
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .darkGray
        return lineView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupSubjectView()
        setupMoreButton()
        setupProfileView()
        setupMessageView()
        setupCollectionView()
        setupCommentLikeView()
        setupLineView()
        
    }
    
    @objc func handleMore() {
        
        guard let post = self.post else { return }
        
        if let myPostsController = myPostsController {
            myPostsController.handleMore(post: post)
        }
        
        
    }
}

extension PostCell {
    fileprivate func setupPost(_ post: GetPost) {
        guard let username = post.userName else { return }
        if let image = post.userImage, image.count > 0, let url = GlobalFunction.getUrlFromString(ServerUrls.profileImageBaseUrl + image) {
            self.userImageView.sd_addActivityIndicator()
            self.userImageView.sd_setImage(with: url, completed: nil)
        } else {
            self.userImageView.image = UIImage.makeLetterAvatar(withUsername: username)
        }
        
        self.usernameLabel.text = username
        if let country = post.countryName, let town = post.townName {
            self.locationLabel.text = town + ", " + country
        }
        
        if let timestampString = post.timestamp, let timestamp = GlobalFunction.getTimeAgoFromTimeString(timestampString) {
            self.timeLabel.text = timestamp
        }
        
        if let subject = post.subject {
            self.subjectLabel.text = subject
        }
        
        if let message = post.message {
            self.messageTextView.text = message
            
            let height = GlobalFunction.estimateFrameForText(text: message, width: POST_TEXTVIEW_WIDTH, font: 17).height + 10
            messageViewHeightConstraint?.constant = height
        } else {
            messageViewHeightConstraint?.constant = 0
        }
        
        if let images = post.postImages, images.count > 0 {
            let imagesArray = images.components(separatedBy: ",")
            self.postImages.removeAll()
            self.postImages = imagesArray
            self.collectionViewConstraint?.constant = POST_IMAGE_ITEM_SIZE_WIDTH
            self.collectionView.reloadData()
        } else {
            self.collectionViewConstraint?.constant = 0
        }
        
        if let commentCount = post.commentcount {
            self.commentButton.titleLabel?.text = "Comments: " + commentCount
        }
        
        if let likeCount = post.likecount {
            self.likeLabel.text = "Likes: " + likeCount
        }
        
        if let like = post.mylike, like == "1" {
            let image = UIImage(named: AssetName.like.rawValue)?.withRenderingMode(.alwaysTemplate)
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.tintColor = StyleGuideManager.mainLightBlueBackgroundColor
        } else {
            let image = UIImage(named: AssetName.unlike.rawValue)?.withRenderingMode(.alwaysTemplate)
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.tintColor = .darkGray
        }
    }
}

extension PostCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostImageCell
        cell.backgroundColor = .red
        cell.postCell = self
        let image = postImages[indexPath.item]
        cell.postImage = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: POST_IMAGE_ITEM_SIZE_WIDTH, height: POST_IMAGE_ITEM_SIZE_WIDTH)
    }
    
}

extension PostCell {
    func performZoomingForStartingImageView(startingImageView: UIImageView) {
        
        postsController?.performZoomingForStartingImageView(startingImageView: startingImageView)
    }
}

extension PostCell {
    
    fileprivate func setupLineView() {
        
        addSubview(lineView)
        lineView.anchor(top: nil, left: subjectLabel.leftAnchor, bottom: bottomAnchor, right: subjectLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    fileprivate func setupCommentLikeView() {
        
        addSubview(likeButton)
        likeButton.anchor(top: collectionView.bottomAnchor, left: nil, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        let stackView = UIStackView(arrangedSubviews: [commentButton, likeLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, left: userImageView.leftAnchor, bottom: nil, right: likeButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        stackView.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(HomePostImageCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.anchor(top: messageTextView.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: POST_IMAGE_ITEM_SIZE_WIDTH)
        collectionViewConstraint = collectionView.heightAnchor.constraint(equalToConstant: POST_IMAGE_ITEM_SIZE_WIDTH)
        collectionViewConstraint?.isActive = true
    }
    
    fileprivate func setupMessageView() {
        
        addSubview(messageTextView)
        messageTextView.anchor(top: userImageView.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 8, paddingLeft: -5, paddingBottom: 0, paddingRight: -5, width: 0, height: 0)
        
        messageViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 30)
        messageViewHeightConstraint?.isActive = true
    }
    
    fileprivate func setupSubjectView() {
        addSubview(subjectLabel)
        subjectLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 05, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 40)
    }
    
    fileprivate func setupMoreButton() {
        addSubview(moreButton)
        moreButton.anchor(top: nil, left: nil, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        moreButton.centerYAnchor.constraint(equalTo: subjectLabel.centerYAnchor).isActive = true
    }
    
    fileprivate func setupProfileView() {
        
        addSubview(userImageView)
        userImageView.anchor(top: subjectLabel.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: nil, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 18)
        timeLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: timeLabel.leftAnchor, paddingTop: 2, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        addSubview(locationLabel)
        locationLabel.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: userImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
    }
    
}
