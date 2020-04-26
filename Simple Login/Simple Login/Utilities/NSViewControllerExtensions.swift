//
//  NSViewControllerExtensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 06/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa

extension NSViewController {
    func showHUD(attributedMessageString: NSAttributedString) {
        let storyboardName = NSStoryboard.Name(stringLiteral: "HUD")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "HUDWindowControllerID")
        if let hudWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
            if let hudViewController = hudWindowController.contentViewController as? HUDViewController {
                hudViewController.attributedMessageString = attributedMessageString
            }
            
            hudWindowController.window?.isOpaque = false
            hudWindowController.showWindow(self)
            
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1.35
                hudWindowController.window?.animator().alphaValue = 1.0
            }) {
                hudWindowController.window?.animator().alphaValue = 0.0
                hudWindowController.close()
            }
        }
    }
    
    func openEnterApiKeyWindowController() {
        let storyboardName = NSStoryboard.Name(stringLiteral: "EnterApiKey")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "EnterApiKeyWindowControllerID")
        
        if let enterApiKeyWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
            enterApiKeyWindowController.showWindow(nil)
        }
    }
    
    func showHomeWindowController(with userInfo: UserInfo) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(stringLiteral: "Home"), bundle: nil)
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "HomeWindowController")
        
        let homeWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController
        (homeWindowController?.contentViewController as? HomeViewController)?.userInfo = userInfo
        homeWindowController?.showWindow(nil)
    }
    
    func showErrorAlert(_ error: SLError) {
        let alert = NSAlert()
        alert.icon = NSImage(named: NSImage.Name(stringLiteral: "SimpleLogin"))
        alert.messageText = "Error occured"
        alert.informativeText = error.description
        alert.addButton(withTitle: "Close")
        alert.alertStyle = .warning
        alert.runModal()
    }
}

final class HUDViewController: NSViewController {
    @IBOutlet private weak var messageLabel: NSTextField!
    
    var attributedMessageString: NSAttributedString?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        messageLabel.attributedStringValue = attributedMessageString ?? NSAttributedString(string: "")
        view.window?.setContentSize(NSSize(width: messageLabel.intrinsicContentSize.width + 8*2, height: messageLabel.intrinsicContentSize.height + 8*2))
    }
}
