//
//  Extensions.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import AssetCatalogWrapper
import UniformTypeIdentifiers

@available(macOS 11, *)
extension UTType {
    static var carFile: UTType = UTType(filenameExtension: "car")!
}

extension NSUserInterfaceItemIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension NSToolbarItem.Identifier {
    static let searchBar = NSToolbarItem.Identifier("SearchBar")
}

extension NSMenu {
    convenience init(title: String? = nil, items: [NSMenuItem]?) {
        defer {
            items.flatMap {
                self.items = $0
            }
        }
        guard let title = title else {
            self.init()
            return
        }
        self.init(title: title)
    }
}

extension NSMenuItem {
    convenience init(submenuTitle: String, items: [NSMenuItem]?) {
        self.init(title: submenuTitle, action: nil, keyEquivalent: "")
        submenu = NSMenu(title: submenuTitle, items: items)
    }
    
    convenience init(title: String, action: Selector? = nil, keyEquivalent: String = "", keyEquivalentModifierMask: NSEvent.ModifierFlags? = nil, tag: Int? = nil) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)
        keyEquivalentModifierMask.flatMap {
            self.keyEquivalentModifierMask = $0
        }
        tag.flatMap {
            self.tag = $0
        }
    }
}

extension CGImage {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

extension NSView {
    func setHiddenWithAnimations(hidden: Bool) {
        NSAnimationContext.runAnimationGroup { animationContext in
            animationContext.duration = hidden ? 0.1 : 0.1
            animator().alphaValue = 0
        } completionHandler: {
            self.isHidden = hidden
            self.alphaValue = 1
        }
    }
}

extension NSAlert {
    convenience init(title: String, message: String? = nil) {
        self.init()
        self.messageText = title
        self.informativeText = message ?? self.informativeText
    }
}

extension NSWindow {
    /// Makes the title bar of the NSWindow transparent and removes the window's ability to be resized
    func makeTitleBarTransparentAndUnresizable() {
        styleMask.remove(.resizable)
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
    }
}

extension NSColor {
    static func _makeStandardWindowBg(appearance: NSAppearance) -> NSColor {
        switch appearance.name {
        case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight: // light
            return .white
        case .darkAqua, .accessibilityHighContrastVibrantDark, .accessibilityHighContrastDarkAqua, .vibrantDark: // dark
            return NSColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1)
        default:
            fatalError()
        }
    }
    
    static var standardWindowBackgroundColor: NSColor {
        return NSColor(name: nil, dynamicProvider: _makeStandardWindowBg(appearance:))
    }
}

extension NSImage {
    convenience init?(systemName: String) {
        if #available(macOS 11, *) {
            self.init(systemSymbolName: systemName, accessibilityDescription: nil)
        } else {
            return nil
        }
    }
}
