//
//  CreatePostMainController.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import ImagePicker

class CreatePostMainController: UIViewController {
    
    var category: Category?
    let cellId = "cellId"
    let headerId = "headerId"
    
    var post: Post?
    
    var postsController: PostsController?
    var myPostsController: MyPostsController?
    
    var postAction: PostAction?
    
    var postImages = [PostImage]()
    
    let subjectLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Subject"
        return label
    }()
    
    lazy var subjectTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter A Subject"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    let messageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Message"
        return label
    }()
    
    let messageTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholderLabel.text = "Enter messages here"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        return textView
    }()
    
    lazy var addPictureButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.addPicture.rawValue)
        button.tintColor = .black
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleAddPicture), for: .touchUpInside)
        return button
    }()
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
//        cv.emptyDataSetSource = self
//        cv.emptyDataSetDelegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchPost()
    }
}

extension CreatePostMainController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        for image in images{
            guard let resizedImage = image.resized(toWidth: 400) else { return }
            
            guard let imageString = GlobalFunction.getBase64StringFromImage(resizedImage) else { return }
            
            let postImage = PostImage(image: resizedImage, imageString: imageString, imageUrl: nil)
            
            self.postImages.append(postImage)
        }
        
        
        
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CreatePostMainController {
    
    fileprivate func fetchPost() {
        
        guard let action = postAction, action == .edit else {
            return
        }
        
        guard let post = post else { return }
        guard let subject = post.subject else { return }
        guard let message = post.message else { return }
        
        self.subjectTextField.text = subject
        self.messageTextView.text = message
        self.messageTextView.placeholderLabel.text = nil
        
        if let postImages = self.post?.postImages, postImages.count > 0 {
            
            for postImageUrl in postImages {
                let postImage = PostImage(image: nil, imageString: nil, imageUrl: postImageUrl)
                
                self.postImages.append(postImage)
            }
            
            
            self.collectionView.reloadData()
            
        }
    }
    
}

extension CreatePostMainController {
    
    func handleDeletePictureAtIndex(_ index: Int) {
        
        self.postImages.remove(at: index)
        self.collectionView.reloadData()
    }
}

extension CreatePostMainController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return postImages.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostImageCell
        
        let postImage = postImages[indexPath.item]
        cell.postImage = postImage
        cell.createPostMainController = self
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 1 - 20 - 20) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 1 {
            let width = view.frame.width - 20 - 20
            return CGSize(width: width, height: 100)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DisclaimerHeaderCell
        
        return header
    }
    
}

extension CreatePostMainController {
    @objc fileprivate func handleAddPicture() {
        
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 10
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CreatePostMainController {
    
    @objc fileprivate func handleNext() {
        
        if !checkInvalid() {
            return 
        }
        
        guard let subject = subjectTextField.text else { return }
        guard let message = messageTextView.text else { return }
        guard let category = self.category?.rawValue else { return }
        
        var images = [String]()
        
        for i in 0..<self.postImages.count {
            
            let indexPath = IndexPath(item: i, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! PostImageCell
            
            guard let image = cell.postImageView.image else { return }
            
            guard let resizedImage = image.resized(toWidth: 400) else { return }
            
            guard let imageString = GlobalFunction.getBase64StringFromImage(resizedImage) else { return }
            images.append(imageString)
        }
        
        let post = Post(userId: nil, username: nil, countryName: nil, townName: nil, postId: self.post?.postId, category: category, subject: subject, message: message, postImages: images, scope: nil, nearbyTowns: nil, timestamp: nil, eventDate: nil, eventTime: nil, eventLocation: nil, commentCount: nil, likeCount: nil, like: nil)
        
        guard let action = self.postAction else { return }
        
        let createPostNextController = CreatePostNextController()
        createPostNextController.post = post
        createPostNextController.postAction = action
        createPostNextController.postsController = postsController
        navigationController?.pushViewController(createPostNextController, animated: true)
    }
    
    fileprivate func checkInvalid() -> Bool {
        
        if (subjectTextField.text?.isEmptyStr)! {
            self.showJHTAlerttOkayWithIcon(message: "Please enter a subject")
            return false
        }
        
        if (messageTextView.text?.isEmptyStr)! {
            self.showJHTAlerttOkayWithIcon(message: "Please enter a message")
            return false
        }
        return true
    }
}

extension CreatePostMainController {
    
    @objc fileprivate func handleCancel() {
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostMainController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = .white
        
        setupNavBar()
        
        setupSubject()
        setupMessage()
        setupButton()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(DisclaimerHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: addPictureButton.bottomAnchor, left: subjectLabel.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: subjectLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func  setupButton() {
        
        view.addSubview(addPictureButton)
        addPictureButton.anchor(top: messageTextView.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
    }
    
    private func setupMessage() {
        
        view.addSubview(messageLabel)
        messageLabel.anchor(top: subjectTextField.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(messageTextView)
        messageTextView.anchor(top: messageLabel.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    }
    
    private func setupSubject() {
        
        view.addSubview(subjectLabel)
        subjectLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
        
        view.addSubview(subjectTextField)
        subjectTextField.anchor(top: subjectLabel.bottomAnchor, left: subjectLabel.leftAnchor, bottom: nil, right: subjectLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Create Post"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem = nextButton
    }
}
