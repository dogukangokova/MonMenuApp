//
//  AppDelegate.swift
//  MonMenu
//


import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    
    
    
    
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    let observer = ActivityObserver()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.image = NSImage(systemSymbolName: "bolt.horizontal.fill", accessibilityDescription: "")
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
        
        
        observer.updatedStatisticsHandler = { observer in
            //Swift.print(observer.statistics)
            //print("CPU "+String(round(observer.cpuDescription) / 100))
           // CpuUpdateModel().setCpuPercent(percent: Int(observer.cpuDescription) )
            //CpuUpdateModel.init()
        }
        
        //observer.start(interval: 3.0)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        observer.stop()
    }
    
    /*
    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }*/


}

