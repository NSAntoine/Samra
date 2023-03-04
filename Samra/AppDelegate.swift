//
//  AppDelegate.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import AssetCatalogWrapper

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static func main() {
        let instance = AppDelegate()
        NSApplication.shared.delegate = instance
        NSApplication.shared.run()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {}
    
    @objc
    func openMenuItemClicked() {
        URLHandler.shared.presentArchiveChooserPanel(insertToRecentItems: true, senderView: nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSLog("I crash through glass ceilings, I break through closed doors.")
        
        if Preferences.showWelcomeVCOnLaunch {
            WindowController(kind: .welcome).showWindow(self)
        }
        
        let items = RenditionType.allCases.map { type in
            let item = NSMenuItem(title: type.description, action: #selector(TypesListViewController.goToSection(menuItemSender:)))
            item.tag = type.rawValue
            item.isEnabled = false
            return item
        }
        
        NSApplication.shared.mainMenu = NSMenu(items: [
            NSMenuItem(submenuTitle: "App", items: [
                NSMenuItem(title: "About Samra",
                           action: #selector(openAboutPanel),
                           keyEquivalent: ""),
                NSMenuItem.separator(),
                NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h", keyEquivalentModifierMask: [.command, .option]),
                NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:))),
                NSMenuItem.separator(),
                NSMenuItem(title: "Quit Samra", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"),
            ]),
            NSMenuItem(submenuTitle: "File", items: [
                NSMenuItem(title: "Open...", action: #selector(openMenuItemClicked), keyEquivalent: "o"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
            ]),
            
            NSMenuItem(submenuTitle: "Edit", items: [
                NSMenuItem(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z"),
                NSMenuItem(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
                NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
                NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
                NSMenuItem(title: "Paste and Match Style", action: #selector(NSText.paste(_:)), keyEquivalent: "V", keyEquivalentModifierMask: [.command, .option]),
                NSMenuItem(title: "Delete", action: #selector(NSText.delete(_:))),
                NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"),
                NSMenuItem.separator(),
                NSMenuItem(
                    submenuTitle: "Find",
                    items: [
                        NSMenuItem(title: "Find…", action: #selector(NSResponder.performTextFinderAction(_:)), keyEquivalent: "f", tag: NSTextFinder.Action.showFindInterface.rawValue),
                        NSMenuItem(title: "Find and Replace…", action: #selector(NSResponder.performTextFinderAction(_:)), keyEquivalent: "f", keyEquivalentModifierMask: [.command, .option], tag: NSTextFinder.Action.replaceAndFind.rawValue),
                        NSMenuItem(title: "Find Next", action: #selector(NSResponder.performTextFinderAction(_:)), keyEquivalent: "g", tag: NSTextFinder.Action.nextMatch.rawValue),
                        NSMenuItem(title: "Find Previous", action: #selector(NSResponder.performTextFinderAction(_:)), keyEquivalent: "G", tag: NSTextFinder.Action.previousMatch.rawValue),
                        NSMenuItem(title: "Use Selection for Find", action: #selector(NSResponder.performTextFinderAction(_:)), keyEquivalent: "e", tag: NSTextFinder.Action.setSearchString.rawValue),
                        NSMenuItem(title: "Jump to Selection", action: #selector(NSResponder.centerSelectionInVisibleArea(_:)), keyEquivalent: "j"),
                    ]),
                NSMenuItem(
                    submenuTitle: "Spelling and Grammar",
                    items: [
                        NSMenuItem(title: "Show Spelling and Grammar", action: #selector(NSTextCheckingController.showGuessPanel(_:)), keyEquivalent: ":"),
                        NSMenuItem(title: "Check Document Now", action: #selector(NSTextCheckingController.checkSpelling(_:)), keyEquivalent: ";"),
                        NSMenuItem(title: "Check Spelling While Typing", action: #selector(NSTextView.toggleContinuousSpellChecking(_:))),
                        NSMenuItem(title: "Correct Spelling Automatically", action: #selector(NSTextView.toggleAutomaticSpellingCorrection(_:))),
                    ]),
                NSMenuItem(
                    submenuTitle: "Substitutions",
                    items: [
                        NSMenuItem(title: "Show Substitutions", action: #selector(NSTextCheckingController.orderFrontSubstitutionsPanel(_:))),
                        NSMenuItem.separator(),
                        NSMenuItem(title: "Smart Copy/Paste", action: #selector(NSTextView.toggleSmartInsertDelete(_:))),
                        NSMenuItem(title: "Smart Quotes", action: #selector(NSTextView.toggleAutomaticQuoteSubstitution(_:))),
                        NSMenuItem(title: "Smart Dashes", action: #selector(NSTextView.toggleAutomaticDashSubstitution(_:))),
                        NSMenuItem(title: "Smart Links", action: #selector(NSTextView.toggleAutomaticLinkDetection(_:))),
                        NSMenuItem(title: "Data Detectors", action: #selector(NSTextView.toggleAutomaticDataDetection(_:))),
                        NSMenuItem(title: "Text Replacement", action: #selector(NSTextView.toggleAutomaticTextReplacement(_:))),
                    ]),
                NSMenuItem(
                    submenuTitle: "Transformations",
                    items: [
                        NSMenuItem(title: "Make Upper Case", action: #selector(NSResponder.uppercaseWord(_:))),
                        NSMenuItem(title: "Make Lower Case", action: #selector(NSResponder.lowercaseWord(_:))),
                        NSMenuItem(title: "Capitalize", action: #selector(NSResponder.capitalizeWord(_:))),
                    ]),
                NSMenuItem(
                    submenuTitle: "Speech",
                    items: [
                        NSMenuItem(title: "Start Speaking", action: #selector(NSSpeechSynthesizer.startSpeaking(_:))),
                        NSMenuItem(title: "Stop Speaking", action: #selector(NSTextView.stopSpeaking(_:))),
                    ]),
            ]),
            NSMenuItem(submenuTitle: "Sections", items: items),
            NSMenuItem(submenuTitle: "Help", items: [
                NSMenuItem(title: "Help", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "?")
            ]),
        ])
    }
    
    func makeOpenMenuItem() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(withTitle: "Title", action: nil, keyEquivalent: "O")
        return menu
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        guard !flag else {
            return true
        }
        
        if Preferences.showWelcomeVCOnLaunch {
            WindowController(kind: .welcome).showWindow(self)
        } else {
            URLHandler.shared.presentArchiveChooserPanel(insertToRecentItems: true, senderView: nil)
        }
        
        return false
    }
    
    @objc
    func openAboutPanel() {
        WindowController(kind: .aboutPanel).showWindow(self)
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let items = Preferences.recentlyOpenedFilePaths
        guard !items.isEmpty else {
            return nil
        }
        
        let parentMenu = NSMenu()
        let submenu = NSMenu()
        let submenuItem = NSMenuItem()
        submenuItem.title = "Recents"
        submenuItem.submenu = submenu
        
        for (index, item) in items.enumerated() {
            let menuItem = NSMenuItem(title: URL(fileURLWithPath: item).lastPathComponent,
                                      action: #selector(openItemFromDockMenu(sender:)),
                                      keyEquivalent: "")
            menuItem.tag = index
            submenu.addItem(menuItem)
        }
        
        parentMenu.addItem(submenuItem)
        return parentMenu
    }
    
    @objc
    func openItemFromDockMenu(sender: NSMenuItem) {
        let item = Preferences.recentlyOpenedFilePaths[sender.tag]
        URLHandler.shared.handleURLChosen(urlChosen: URL(fileURLWithPath: item),
                                          senderView: nil, insertToRecentItems: true)
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            URLHandler.shared.handleURLChosen(urlChosen: url,
                                              senderView: nil,
                                              insertToRecentItems: true,
                                              openWelcomeScreenUponError: true)
        }
    }
}

