//
//  StartupViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 07/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Cocoa
import Alamofire

final class StartupViewController: NSViewController {
    @IBOutlet private weak var messageLabel: NSTextField!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var retryButton: NSButton!
    
    private var apiKey: String?
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Retrieve API key from user defaults
        // API key exists -> verify it
        // API not exist -> open EnterApiKeyWindowController
        if let apiKey = SLUserDefaultsService.getApiKey() {
            self.apiKey = apiKey
            checkApiKeyAndProceed()
        } else {
            openEnterApiKeyWindowController()
            self.view.window?.performClose(nil)
        }
    }
    
    @IBAction private func retryButtonClicked(_ sender: Any) {
        checkApiKeyAndProceed()
    }
    
    private func checkApiKeyAndProceed() {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(nil)
        messageLabel.stringValue = "Connecting to server..."
        retryButton.isHidden = true
        
        SLApiService.fetchUserInfo(apiKey: apiKey!) { [weak self] result in
            guard let self = self else { return }
            
            self.progressIndicator.isHidden = true
            self.progressIndicator.stopAnimation(nil)
            
            switch result {
            case .success(let userInfo):
                self.showHomeWindowController(with: userInfo)
                self.view.window?.performClose(nil)
                
            case .failure(let error):
                self.messageLabel.stringValue = "Error occured: \(error.description)"
                self.retryButton.isHidden = false
                
                switch error {
                case .invalidApiKey:
                    self.openEnterApiKeyWindowController()
                    self.view.window?.performClose(nil)
                    
                default: return
                }
            }
        }
    }
}
