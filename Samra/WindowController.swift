//
//  WindowController.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import AssetCatalogWrapper

class WindowController: NSWindowController, NSWindowDelegate {
    
    enum Kind {
        /// The 'Welcome to Samra' screen
        case welcome
        
        /// The 'About Samra' Panel.
        case aboutPanel
        
        /// A View Controller to select 2 AssetCatalogs to diff between them
        case diffSelection
        
        /// A View Controller to show the diff between 2 asset catalogs
        case diffShow([RenditionDiff], CUICatalog, URL)
        
        /// Show a View Controller of a rendition collection
        case assetCatalog(AssetCatalogInput)
    }
    
    convenience init(kind: Kind) {
        let viewController: NSViewController
        
        switch kind {
        case .welcome:
            let splitViewController = CollapseNotifierSplitViewController()
            let welcomeViewController = WelcomeViewController()
            let list = PastFilesListViewController()
            splitViewController.addSplitViewItem(NSSplitViewItem(viewController: welcomeViewController))
            splitViewController.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: list))
            viewController = splitViewController
        case .assetCatalog(let input):
            let splitViewController = CollapseNotifierSplitViewController()
            let renditionVC = RenditionListViewController(catalog: input.catalog, collection: input.collection,
                                                          fileURL: input.fileURL)
            let typesSidebar = TypesListViewController(types: input.collection.map(\.type)) { type in
                if let index = renditionVC.dataSource.snapshot().indexOfSection(type) {
                    renditionVC.collectionView.scrollToItems(at: [IndexPath(item: 0, section: index)], scrollPosition: .top)
                }
            }
            
            splitViewController.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: typesSidebar))
            splitViewController.addSplitViewItem(NSSplitViewItem(viewController: renditionVC))
            viewController = splitViewController
        case .aboutPanel:
            viewController = AboutViewController()
        case .diffSelection:
            viewController = AssetCatalogDiffSelectionViewController()
        case .diffShow(let diffs, let catalog, let fileURL):
            viewController = DiffListViewController(diffs: diffs, catalog: catalog, fileURL: fileURL)
        }
        
        let window = NSWindow(contentViewController: viewController)
        window.styleMask.insert(.fullSizeContentView)
        self.init(window: window)
        
        switch kind {
        case .assetCatalog(let input):
            let toolbar = NSToolbar()
            toolbar.delegate = self
            window.toolbar = toolbar
            toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 0)
            toolbar.insertItem(withItemIdentifier: .searchBar, at: 1)
            toolbar.insertItem(withItemIdentifier: .init("infoButton"), at: 2)
            window.toolbar?.centeredItemIdentifier = .searchBar
            window.animationBehavior = .documentWindow
            window.delegate = self
            window.title = input.fileURL.lastPathComponent
            if #available(macOS 11, *) {
                window.subtitle = input.fileURL.deletingLastPathComponent().lastPathComponent
            }
        case .welcome:
            window.makeTitleBarTransparentAndUnresizable()
            window.animationBehavior = .utilityWindow
            window.title = "Samra"
        case .aboutPanel:
            window.makeTitleBarTransparentAndUnresizable()
            window.title = "Samra"
        case .diffSelection:
            window.title = "Diff"
        case .diffShow(_, _, _):
            let toolbar = NSToolbar()
            toolbar.delegate = self
            window.toolbar = toolbar
            window.title = "Diff"
            toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 0)
            toolbar.insertItem(withItemIdentifier: .searchBar, at: 1)
            window.animationBehavior = .documentWindow
            window.delegate = self
        }
    }
}

extension WindowController: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .searchBar:
            let rendVC: NSSearchFieldDelegate?
            
            if let splitVC = contentViewController as? NSSplitViewController {
                rendVC = splitVC.splitViewItems[1].viewController as? NSSearchFieldDelegate
            } else {
                rendVC = contentViewController as? NSSearchFieldDelegate
            }
            
            /*
            if #available(macOS 11, *) {
                let item = NSSearchToolbarItem(itemIdentifier: .searchBar)
                item.searchField.delegate = rendVC
                return item
            }
             */
            
            let item = NSToolbarItem(itemIdentifier: .searchBar)
            let searchField = NSSearchField()
            searchField.delegate = rendVC
            item.view = searchField
            return item
        case .init("infoButton"):
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            let button = NSButton()
            if #available(macOS 11, *) {
                button.image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: nil)?
                    .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 18, weight: .regular))
            } else {
                button.title = "Info"
            }
            button.action = #selector(RenditionListViewController.infoButtonClicked(sender:))
            button.target = (contentViewController as? NSSplitViewController)?.splitViewItems[1].viewController as? RenditionListViewController
            button.setButtonType(.momentaryPushIn)
            button.bezelStyle = .texturedRounded
            toolbarItem.view = button
            
//            toolbarItem.action = #selector(RenditionListViewController.infoPopoverItemClicked(sender:))
//            toolbarItem.target = (contentViewController as? NSSplitViewController)?.splitViewItems[1].viewController as? RenditionListViewController
//            toolbarItem.image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: nil)
//            toolbarItem.isEnabled = true
            return toolbarItem
        case .init("flexSpace"):
            #warning("Fix this (want flexible space between search bar and sidebar)")
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "flexSpace"))
            toolbarItem.minSize = NSSize(width: 1, height: 1)
            toolbarItem.maxSize = NSSize(width: 1000, height: 1)
            return toolbarItem
        default:
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
    
    func toolbar(_ toolbar: NSToolbar, itemIdentifier: NSToolbarItem.Identifier, canBeInsertedAt index: Int) -> Bool {
        return true
    }
}
