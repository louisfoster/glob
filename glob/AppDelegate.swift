//
//  AppDelegate.swift
//  glob
//
//  Created by Louis Foster on 7/6/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: App Properties
    
    @IBOutlet
    private var saveAsMenuItem: NSMenuItem?
    
    // MARK: App life cycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Do something about our render view to prevent weird errors/crashes/etc
    }
    
    // MARK: Actions
    
    @IBAction
    private func saveAsMenuItemPressed(_ sender: Any) {
        
        NotificationCenter.default.post(name: .saveAsIntent, object: nil)
    }
}
