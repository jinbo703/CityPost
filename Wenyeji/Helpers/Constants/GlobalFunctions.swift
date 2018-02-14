//
//  GlobalFunctions.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class GlobalFunction {
    
    static func estimateFrameForText(text: String, width: CGFloat, font: CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)], context: nil)
        
    }
    
    static func getTimeAgoFromTimeString(_ string: String) -> String? {
        
        guard let timestamp = Double(string) else { return nil }
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let timeAgoString = date.timeAgoDisplay()
        
        return timeAgoString
    }
    
    static func getUrlFromString(_ string: String) -> URL? {
        guard let urlStr = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return nil
        }
        return url
    }
    
    static func getBase64StringFromImage(_ image: UIImage) -> String? {
//        guard let imageString = UIImageJPEGRepresentation(image, 1.0)?.base64EncodedString(options: .lineLength64Characters) else { return nil }

        guard let imageString = UIImagePNGRepresentation(image)?.base64EncodedString(options: .lineLength64Characters) else { return nil }
        
        return imageString
    }
    
    static func getImageFromBase64String(_ string: String) -> UIImage? {
        guard let decodedData = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else { return nil }
        
        let image = UIImage(data: decodedData)
        
        return image
    }
    
    static func getAttributedString(firstString: String, firstAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.black], secondString: String, secondeAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.gray]) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: firstString, attributes: firstAttribute)
        attributedString.append(NSAttributedString(string: secondString, attributes: secondeAttribute))
        let paragraphStrye = NSMutableParagraphStyle()
        paragraphStrye.alignment = .left
        
        let length = attributedString.string.count
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
        
        return attributedString
    }
    
    static func getAttributedCenterString(firstString: String, firstAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.black], secondString: String, secondeAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.gray]) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: firstString, attributes: firstAttribute)
        attributedString.append(NSAttributedString(string: secondString, attributes: secondeAttribute))
        let paragraphStrye = NSMutableParagraphStyle()
        paragraphStrye.alignment = .center
        
        let length = attributedString.string.count
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
        
        return attributedString
    }
    
    static func isDarkMode() -> Bool {
        return UserDefaults.standard.getDarkMode()
    }
    
    static func getRandomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
        
    }
    
    static func findBestViewController(vc: UIViewController) -> UIViewController {
        
        if (vc.presentedViewController != nil) {
            return findBestViewController(vc: vc.presentedViewController!)
        } else if vc.isKind(of: UISplitViewController.self) {
            
            let svc = UISplitViewController()
            if svc.viewControllers.count > 0 {
                return findBestViewController(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
            
        } else if vc.isKind(of: UINavigationController.self) {
            let nvc = UINavigationController()
            if nvc.viewControllers.count > 0 {
                return findBestViewController(vc: nvc.topViewController!)
            } else {
                return vc
            }
            
        } else if vc.isKind(of: UITabBarController.self) {
            let tvc = UITabBarController()
            if (tvc.viewControllers?.count)! > 0 {
                return findBestViewController(vc: tvc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
        
        
    }
    
    static func currentViewController() -> UIViewController? {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            let returnController = GlobalFunction.findBestViewController(vc: viewController)
            return returnController
        } else {
            return nil
        }
        
    }
}


