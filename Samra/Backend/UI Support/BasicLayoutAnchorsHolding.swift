//
//  BasicLayoutAnchorsHolding.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

protocol BasicLayoutAnchorsHolding {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension BasicLayoutAnchorsHolding {
    /// Activate constraints to cover the target with the current item.
    func constraintCompletely<Target: BasicLayoutAnchorsHolding>(to target: Target) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: target.leadingAnchor),
            trailingAnchor.constraint(equalTo: target.trailingAnchor),
            topAnchor.constraint(equalTo: target.topAnchor),
            bottomAnchor.constraint(equalTo: target.bottomAnchor)
        ])
    }
    
    /// Activate constraints to center the target with the current item.
    func centerConstraints<Target: BasicLayoutAnchorsHolding>(to target: Target) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: target.centerXAnchor),
            centerYAnchor.constraint(equalTo: target.centerYAnchor)
        ])
    }
}

#if canImport(UIKit)
extension UIView: BasicLayoutAnchorsHolding {}
extension UILayoutGuide: BasicLayoutAnchorsHolding {}
#else
extension NSView: BasicLayoutAnchorsHolding {}
extension NSLayoutGuide: BasicLayoutAnchorsHolding {}
#endif
