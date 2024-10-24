//
//  AboutViewController.swift
//  Samra
//
//  Created by Serena on 28/02/2023.
// 

import Cocoa

class AboutViewController: NSViewController {
    override func loadView() {
        view = NSView()
        view.frame.size = CGSize(width: 530.0, height:219.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = NSImageView(image: NSApplication.shared.applicationIconImage)
        
        let titleLabel = NSTextField(labelWithString: "Samra")
        titleLabel.font = .systemFont(ofSize: 38)
        
        let version = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        let versionLabel = NSTextField(labelWithString: "Version \(version)")
        versionLabel.textColor = .secondaryLabelColor
        
        let explanation = "An open source macOS Application to browse and edit Asset Catalog files, created by Antoine"
        let explanationLabel = NSTextField(wrappingLabelWithString: explanation)
        
        explanationLabel.textColor = NSColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
        if #available(macOS 11, *) {
            explanationLabel.font = .preferredFont(forTextStyle: .footnote)
        } else {
            explanationLabel.font = .systemFont(ofSize: 10)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(versionLabel)
        view.addSubview(explanationLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: 32),
            
            versionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            versionLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            explanationLabel.leadingAnchor.constraint(equalTo: versionLabel.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            explanationLabel.centerYAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20)
        ])
        
        let twitterButton = NSButton(title: "Twitter",
                                     target: self, action: #selector(openTwitter))
        let sourceCodeButton = NSButton(title: "Source Code",
                                        target: self, action: #selector(openSourceCode))
        
        twitterButton.bezelStyle = .rounded
        sourceCodeButton.bezelStyle = .rounded
        
        let buttonsStackView = NSStackView(views: [twitterButton, sourceCodeButton])
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26.4),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            
//            twitterButton.widthAnchor.constraint(equalToConstant: 154),
//            sourceCodeButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc
    func openSourceCode() {
        NSWorkspace.shared.open(URL(string: "https://github.com/NSAntoine/Samra")!)
    }
    
    @objc
    func openTwitter() {
        NSWorkspace.shared.open(URL(string: "https://twitter.com/NSAntoine")!)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let window = view.window else { return }
        window.backgroundColor = .standardWindowBackgroundColor
        window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        window.standardWindowButton(.zoomButton)?.isEnabled = false
    }
}
