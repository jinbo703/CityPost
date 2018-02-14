//
//  HomePostImageCell.swift
//  Wenyeji
//
//  Created by PAC on 2/14/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SDWebImage

class HomePostImageCell: BaseCollectionViewCell {
    var postCell: PostCell?
    
    
    var postImage: String? {
        didSet {
            guard let image = postImage else { return }
            
            guard let urlStr = (ServerUrls.postImageBaseUrl + image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlStr) else {
                    return
            }
            
            postImageView.sd_addActivityIndicator()
            postImageView.sd_setImage(with: url, completed: nil)
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
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            postCell?.performZoomingForStartingImageView(startingImageView: imageView)
        }
        
        
    }
    
}
