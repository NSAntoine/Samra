//
//  RenditionTypeHeaderView.swift
//  Samra
//
//  Created by Serena on 19/02/2023.
// 

import Cocoa
import AssetCatalogWrapper

class RenditionTypeHeaderView: NSView, NSCollectionViewElement {
    
    static let identifier = NSUserInterfaceItemIdentifier("RenditionTypeHeaderView")
    
    var typeLabel: NSTextField!
    var amountOfItemsLabel: NSTextField!
    
    func configure(typeLabelText: String, numberOfItems: Int) {
        typeLabel = NSTextField(labelWithString: typeLabelText)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(typeLabel)
        
        amountOfItemsLabel = NSTextField(labelWithString: "\(numberOfItems) Items")
        amountOfItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(amountOfItemsLabel)
        
        if #available(macOS 11, *) {
            typeLabel.font = .preferredFont(forTextStyle: .largeTitle)
            amountOfItemsLabel.font = .preferredFont(forTextStyle: .caption1)
        } else {
            amountOfItemsLabel.font = .systemFont(ofSize: 10)
            typeLabel.font = .systemFont(ofSize: 26)
        }
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: topAnchor),
            
            amountOfItemsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountOfItemsLabel.centerXAnchor.constraint(equalTo: typeLabel.centerXAnchor, constant: -30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        typeLabel.removeFromSuperview()
        typeLabel = nil
        
        amountOfItemsLabel.removeFromSuperview()
        amountOfItemsLabel = nil
    }
}
