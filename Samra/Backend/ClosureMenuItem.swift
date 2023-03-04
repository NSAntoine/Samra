//
//  ClosureMenuItem.swift
//  Samra
//
//  Created by Serena on 02/03/2023.
// 

import Cocoa

class ClosureMenuItem: NSMenuItem {
    var closure: (() -> Void)
    
    @objc
    func performClosure() {
        closure()
    }
    
    init(title: String, closure: @escaping (() -> Void)) {
        self.closure = closure
        super.init(title: title, action: #selector(performClosure), keyEquivalent: "")
        self.target = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
