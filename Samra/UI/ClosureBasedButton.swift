//
//  ClosureBasedButton.swift
//  Samra
//
//  Created by Serena on 05/03/2024.
//  

import Cocoa

class ClosureBasedButton: NSButton {
    var closureAction: (() -> Void)?
    
    @objc
    func performClosureAction() {
        closureAction?()
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.closureAction = action
        self.action = #selector(performClosureAction)
        self.target = self
    }
}
