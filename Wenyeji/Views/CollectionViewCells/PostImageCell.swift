//
//  PostImageCell.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit

class PostImageCell: BaseCollectionViewCell {
    
    var index: Int?
    var createPostMainController: CreatePostMainController?
    var postCell: PostCell?
    
    var postImage: PostImage? {
        didSet {
            guard let postImage = postImage else { return }
            
            if let image = postImage.image {
                postImageView.image = image
            }
            
            if let imageUrlString = postImage.imageUrl {
                
                if let imageUrl = GlobalFunction.getUrlFromString(ServerUrls.postImageBaseUrl + imageUrlString) {
                    self.postImageView.sd_addActivityIndicator()
                    self.postImageView.sd_setImage(with: imageUrl, completed: nil)
                }
            }
            
        }
    }
    
    lazy var postImageView: UIImageView = {
        
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: AssetName.appIconImage.rawValue)
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(tapGesture:)))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.delete.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = StyleGuideManager.townsTableViewBackgroundColor
        button.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(deleteButton)
        deleteButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
    }
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            postCell?.performZoomingForStartingImageView(startingImageView: imageView)
        }
        
        
    }
    
    @objc fileprivate func handleDeleteButton() {
        
        guard let index = index else { return }
        createPostMainController?.handleDeletePictureAtIndex(index)
    }
}
