//
//  NearbyTownCell.swift
//  Wenyeji
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit

class NearbyTownCell: BaseTableViewCell {
    
    var chooseCityController: ChooseCityController?
    var creatPostNextController: CreatePostNextController?
    
    var index: Int?
    
    var nearbyTown: Town? {
        
        didSet {
            guard let nearbyTown = nearbyTown else { return }
            
            
            townNameLabel.text = nearbyTown.townName
            
            if let members = nearbyTown.members {
                membersLabel.text = members + " Members"
            }
            
            
            guard let connected = nearbyTown.connected else { return }
            
            if connected == "1" {
                
                DispatchQueue.main.async {
                    self.connectCheckBox.setOn(true)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.connectCheckBox.setOn(false)
                }
                
            }
            
            
        }
    }
    
    let townNameLabel: UILabel = {
        
        let label = UILabel()
        return label
    }()
    
    let membersLabel: UILabel = {
        
        let label = UILabel()
        return label
    }()
    
    lazy var connectCheckBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderColor = StyleGuideManager.mainLightBlueBackgroundColor
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleCheckBox(isOn: isOn)
        }
        return box
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupCheckBox()
        setupLabels()
    }
}

extension NearbyTownCell {
    
    fileprivate func setupCheckBox() {
        
        addSubview(connectCheckBox)
        connectCheckBox.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 25, height: 25)
        connectCheckBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    fileprivate func setupLabels() {
        
        addSubview(townNameLabel)
        townNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: connectCheckBox.leftAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        addSubview(membersLabel)
        membersLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: connectCheckBox.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, width: 0, height: 20)
    }
}

extension NearbyTownCell {
    
    fileprivate func handleCheckBox(isOn : Bool) {
        guard let index = self.index else { return }
        chooseCityController?.handleConnectedNearbyTown(connected: isOn, index: index)
        creatPostNextController?.handleConnectedNearbyTown(connected: isOn, index: index)
    }
}
