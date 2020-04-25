//
//  Alias.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 25/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation

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
//
//    lazy var countAttributedString: NSAttributedString = {
//        var plainString = ""
//        plainString += " \(forwardCount) "
//        plainString += forwardCount > 1 ? "forwards," : "forward,"
//
//        plainString += " \(blockCount) "
//        plainString += blockCount > 1 ? "blocks," : "block,"
//
//        plainString += " \(replyCount) "
//        plainString += replyCount > 1 ? "replies" : "reply"
//
//        let attributedString = NSMutableAttributedString(string: plainString)
//        attributedString.addAttributes([
//            .foregroundColor: SLColor.titleColor,
//            .font: UIFont.systemFont(ofSize: 12, weight: .medium)], range: NSRange(plainString.startIndex..., in: plainString))
//
//        let matchRanges = RegexHelpers.matchRanges(of: "[0-9]{1,}", inString: plainString)
//        matchRanges.forEach { (range) in
//            attributedString.addAttributes([
//            .foregroundColor: SLColor.textColor,
//            .font: UIFont.systemFont(ofSize: 13, weight: .medium)], range: range)
//        }
//
//        return attributedString
//    }()
    
    lazy var creationString: String = {
        let (value, unit) =  Date.init(timeIntervalSince1970: creationTimestamp).distanceFromNow()
        return "Created \(value) \(unit) ago"
    }()
    
    lazy var latestActivityString: String? = {
        guard let latestActivity = latestActivity else {
            return nil
        }
        
        let (value, unit) =  Date.init(timeIntervalSince1970: latestActivity.timestamp).distanceFromNow()
        return "\(latestActivity.contact.email) • \(value) \(unit) ago"
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

