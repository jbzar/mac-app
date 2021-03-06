//
//  Alias.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 25/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation
import Cocoa

final class Alias: Equatable {
    typealias Identifier = Int
    
    let id: Identifier
    let email: String
    let creationDate: String
    let creationTimestamp: TimeInterval
    let blockCount: Int
    let replyCount: Int
    let forwardCount: Int
    let latestActivity: LatestActivity?
    private(set) var note: String?
    private(set) var enabled: Bool
    
    lazy var creationTimestampString: String = {
        let date = Date(timeIntervalSince1970: creationTimestamp)
        let preciseDateAndTime = preciseDateFormatter.string(from: date)
        let (value, unit) =  date.distanceFromNow()
        return "Created on \(preciseDateAndTime) (\(value) \(unit) ago)"
    }()
    
    lazy var copyAlertAttributedString: NSAttributedString = {
        let plainString = "Copied\n\(email)"
        let attributedString = NSMutableAttributedString(string: plainString)
        
        attributedString.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: plainString.count))
        
        attributedString.addTextAlignCenterAttribute()
        
        if let copiedRange = plainString.range(of: "Copied") {
            attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(copiedRange, in: plainString))
        }
        
        if let emailRange = plainString.range(of: email) {
            attributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 13, weight: .regular), range: NSRange(emailRange, in: plainString))
        }
        
        return attributedString
    }()
    
    lazy var latestActivityAttributedString: NSAttributedString = {
        let image: NSImage
        let text: String
        
        if let latestActivity = latestActivity {
            let (value, unit) =  Date.init(timeIntervalSince1970: latestActivity.timestamp).distanceFromNow()
            text = " \(latestActivity.contact.email) • \(value) \(unit) ago"
        
            switch latestActivity.action {
            case .block, .bounced: image = blockImage
            case .forward: image = forwardImage
            case .reply: image = replyImage
            }
        } else {
            let (value, unit) =  Date.init(timeIntervalSince1970: creationTimestamp).distanceFromNow()
            text = " Created \(value) \(unit) ago"
            image = clockImage
        }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        // Adjust image's y to center it with the text after
        imageAttachment.bounds = CGRect(x: 0, y: -4, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: text))
        
        return attributedString
    }()
    
    lazy var activitiesAttributedString: NSAttributedString = {
        var string = ""
        
        string += "\(forwardCount) "
        if forwardCount > 1 {
            string += "forwards, "
        } else {
            string += "forward, "
        }
        
        string += "\(replyCount) "
        if replyCount > 1 {
            string += "replies, "
        } else {
            string += "reply, "
        }
        
        string += "\(blockCount) "
        if blockCount > 1 {
            string += "blocks"
        } else {
            string += "block"
        }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = waveImage
        // Adjust image's y to center it with the text after
        imageAttachment.bounds = CGRect(x: 0, y: -4, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " \(string)"))
        
        return attributedString
    }()
    
    init(fromDictionary dictionary: [String : Any]) throws {
        let id = dictionary["id"] as? Int
        let email = dictionary["email"] as? String
        let creationDate = dictionary["creation_date"] as? String
        let creationTimestamp = dictionary["creation_timestamp"] as? TimeInterval
        let blockCount = dictionary["nb_block"] as? Int
        let forwardCount = dictionary["nb_forward"] as? Int
        let replyCount = dictionary["nb_reply"] as? Int
        let enabled = dictionary["enabled"] as? Bool
        let note = dictionary["note"] as? String
        let latestActivityDictionary = dictionary["latest_activity"] as? [String: Any]
        
        if let latestActivityDictionary = latestActivityDictionary {
            self.latestActivity = try LatestActivity(fromDictionary: latestActivityDictionary)
        } else {
            self.latestActivity = nil
        }
        
        if let id = id, let email = email, let creationDate = creationDate, let creationTimestamp = creationTimestamp, let blockCount = blockCount, let forwardCount = forwardCount, let replyCount = replyCount, let enabled = enabled {
            self.id = id
            self.email = email
            self.creationDate = creationDate
            self.creationTimestamp = creationTimestamp
            self.blockCount = blockCount
            self.forwardCount = forwardCount
            self.replyCount = replyCount
            self.enabled = enabled
            self.note = note
        } else {
            throw SLError.failToParseObject(objectName: "Alias")
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        self.enabled = enabled
    }
    
    func setNote(_ note: String?) {
        self.note = note
    }
    
    static func ==(lhs: Alias, rhs: Alias) -> Bool {
        return lhs.id == rhs.id
    }
}

