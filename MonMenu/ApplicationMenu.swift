//
// ApplicationMenu.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation

import SwiftUI

class ApplicationMenu: NSObject{
    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let menuView = ContentView()
        let topView = NSHostingController(rootView: menuView)
        topView.view.frame.size = CGSize(width: 320, height: 350)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view
        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())
        return menu
    }
}
