//
//  WelcomeScreenOption.swift
//  Samra
//
//  Created by Serena on 21/02/2023.
// 

import Cocoa

/// Represents an option on the main menu screen,
/// similar to that of Xcode's.
class WelcomeScreenOption: NSView {
    var actionClosure: () -> Void
    
    init(primaryText: String, secondaryText: String, image: NSImage?, action: @escaping () -> Void) {
        self.actionClosure = action
        
        super.init(frame: .zero)
        let finalImage: NSImage?
        if #available(macOS 11, *) {
            finalImage = image?
                .withSymbolConfiguration(.init(pointSize: 30, weight: .regular))
        } else {
            finalImage = image
        }
        
        let finalImageView = NSImageView()
        finalImageView.image = finalImage
        finalImageView.contentTintColor = .controlAccentColor
        
        let primaryTextLabel = NSTextField(labelWithString: primaryText)
        let secondaryTextLabel = NSTextField(labelWithString: secondaryText)
        secondaryTextLabel.textColor = .secondaryLabelColor
        
        if #available(macOS 11, *) {
            primaryTextLabel.font = .preferredFont(forTextStyle: .headline)
            secondaryTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        } else {
            primaryTextLabel.font = .boldSystemFont(ofSize: 13)
            secondaryTextLabel.font = .systemFont(ofSize: 11)
        }
        
        let textLabelsStackView = NSStackView(views: [primaryTextLabel, secondaryTextLabel])
        textLabelsStackView.alignment = .left
        textLabelsStackView.spacing = 0.4
        textLabelsStackView.orientation = .vertical
        
        let completeStackView = NSStackView(views: [finalImageView, textLabelsStackView])
        completeStackView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(performAction)))
        completeStackView.orientation = .horizontal
        completeStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completeStackView)
        completeStackView.constraintCompletely(to: self)
    }
    
    @objc func performAction() {
        actionClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
