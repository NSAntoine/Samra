//
//  MenuableCollectionView.swift
//  Samra
//
//  Created by Serena on 02/03/2023.
// 

import Cocoa

class CollectionViewWithMenu: NSCollectionView {
    weak var menuProvider: MenuProvider?
    
    override func menu(for event: NSEvent) -> NSMenu? {
        guard event.type == .rightMouseDown,
              let indexPath = indexPathForItem(
                at: convert(event.locationInWindow, from: nil)
              ) else {
            return nil
        }
        
        return menuProvider?.collectionView(self, menuForItemAt: indexPath)
    }
}

protocol MenuProvider: AnyObject {
    func collectionView(_ collectionView: NSCollectionView, menuForItemAt: IndexPath) -> NSMenu?
}
