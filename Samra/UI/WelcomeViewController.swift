//
//  WelcomeViewController.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import AssetCatalogWrapper

class WelcomeViewController: NSViewController {
    
    // override so that it doesn't try to load a fucking nib
    override func loadView() {
        view = NSView()
        view.frame.size = CGSize(width: 570, height: 460)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appIcon = NSImageView(image: NSApplication.shared.applicationIconImage)
        let welcomeTextLabel = NSTextField(labelWithString: "Welcome to Samra")
        welcomeTextLabel.font = .systemFont(ofSize: 30)
        
        let subtitleLabel = NSTextField(labelWithString: "Created by Serena")
        subtitleLabel.textColor = .secondaryLabelColor
        
        let stackView = NSStackView(views: [appIcon, welcomeTextLabel, subtitleLabel])
        stackView.orientation = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0.3
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
        
        let openFolderOption = WelcomeScreenOption(
            primaryText: "Open Assets File",
            secondaryText: "Browse and Edit Assets Files on your Mac",
            image: NSImage(systemName: "folder")) { [unowned self] in
                URLHandler.shared.presentArchiveChooserPanel(insertToRecentItems: true, senderView: view)
            }
        
        openFolderOption.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openFolderOption)
        
        NSLayoutConstraint.activate([
            openFolderOption.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            openFolderOption.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        let closeWindowButton = NSButton()
        closeWindowButton.image = NSImage(systemName: "xmark")
        closeWindowButton.action = #selector(closeWindowButtonClicked)
        closeWindowButton.target = self
        
        closeWindowButton.showsBorderOnlyWhileMouseInside = true
        closeWindowButton.bezelStyle = .roundRect
        closeWindowButton.bezelColor = .gray
        //closeWindowButton.isHidden = true
        closeWindowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeWindowButton)
        
        NSLayoutConstraint.activate([
            closeWindowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeWindowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        let showThisWindowButton = NSButton(title: "Show this window when Samra launches",
                                            target: self,
                                            action: #selector(showThisWindowOnLaunchButtonClicked(sender:)))
        showThisWindowButton.setButtonType(.switch)
        showThisWindowButton.state = Preferences.showWelcomeVCOnLaunch ? .on : .off
        showThisWindowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showThisWindowButton)
        
        NSLayoutConstraint.activate([
            showThisWindowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            showThisWindowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Register for when cursor is on Window
        // if it's not, hide the closeWindowButton and the showThisWindowButton
        // otherwise show it
        NSEvent.addLocalMonitorForEvents(matching: [.mouseEntered, .mouseExited]) { event in
            let newAlphaValue: CGFloat = (event.type == .mouseExited) ? 0 : 1
            
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                context.allowsImplicitAnimation = true
                
                closeWindowButton.animator().alphaValue = newAlphaValue
                showThisWindowButton.animator().alphaValue = newAlphaValue
            }
            
            return event
        }
    }
    
    @objc
    func closeWindowButtonClicked() {
        view.window?.close()
    }
    
    @objc
    func showThisWindowOnLaunchButtonClicked(sender: NSButton) {
        var newValue = Preferences.showWelcomeVCOnLaunch
        newValue.toggle()
        Preferences.showWelcomeVCOnLaunch = newValue
    }
    
    deinit {
        print("Magna Carta.. Holy Grail.")
        print("deinit called for WelcomeViewController")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let window = view.window else { return }
        window.backgroundColor = .standardWindowBackgroundColor
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }
}
