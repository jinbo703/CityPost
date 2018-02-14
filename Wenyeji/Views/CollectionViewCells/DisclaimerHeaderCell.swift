//
//  DisclaimerHeaderCell.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit

class DisclaimerHeaderCell: BaseCollectionViewCell {
    
    let disclaimerText = "All messages posted on this platform must follow the rules and guidelines. Do Not post any sexual or inappropriate or political messages. Be respectful of your neighbors."
    
    lazy var disclaimerTextview: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        let attributedString = GlobalFunction.getAttributedCenterString(firstString: "Disclaimers\n", firstAttribute: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.black], secondString: disclaimerText, secondeAttribute: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray])
        textView.attributedText = attributedString
        
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(disclaimerTextview)
        disclaimerTextview.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
