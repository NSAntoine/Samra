//
//  PastFilesListViewController.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import QuickLookUI
import AssetCatalogWrapper

/// A View Controller showing the past files opened
class PastFilesListViewController: NSViewController {
    var paths: [String] = Preferences.recentlyOpenedFilePaths.reversed()
    var tableView: NSTableView!
    
    override func loadView() {
        tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.headerView = nil
        tableView.doubleAction = #selector(doubeClickedItem)
        
        let col = NSTableColumn(identifier: "Column")
        tableView.addTableColumn(col)
        
        let menu = NSMenu()
        menu.delegate = self
        menu.addItem(withTitle: "Show in Finder", action: #selector(showInFinder), keyEquivalent: "")
        menu.addItem(withTitle: "Remove", action: #selector(deleteItem), keyEquivalent: "")
        menu.autoenablesItems = false
        tableView.menu = menu
        
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasHorizontalScroller = false
        view = scrollView
        view.frame.size = CGSize(width: 250, height: 0)
    }
}

extension PastFilesListViewController {
    // Menu item actions
    @objc
    func deleteItem() {
        guard tableView.clickedRow >= 0 else { return }
        paths.remove(at: tableView.clickedRow)
        Preferences.recentlyOpenedFilePaths = paths.reversed()
        tableView.removeRows(at: [tableView.clickedRow], withAnimation: [.slideRight])
    }
    
    @objc
    func showInFinder() {
        guard tableView.clickedRow >= 0 else { return }
        
        let item = paths[tableView.clickedRow]
        NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: item)])
    }
}

extension PastFilesListViewController: NSMenuDelegate {
    func menuNeedsUpdate(_ menu: NSMenu) {
        // if no item is selected, then disable the menu items
        let keepItemsEnabled = tableView.clickedRow >= 0
        
        for item in menu.items {
            item.isEnabled = keepItemsEnabled
        }
    }
    
    override func keyDown(with event: NSEvent) {
        guard tableView.selectedRow != -1 else { return }
        super.keyDown(with: event)
        
        // space, show QuickLook
        if event.characters == " " {
            if let sharedPanel = QLPreviewPanel.shared() {
                let url = URL(fileURLWithPath: paths[tableView.selectedRow])
                let source = QuickLookPreviewSource(fileURL: url)
                sharedPanel.dataSource = source
                sharedPanel.makeKeyAndOrderFront(nil)
            }
        }
        
        // carriage return, open up the item
        if event.characters == "\r" {
            doubeClickedItem()
        }
    }
}

extension PastFilesListViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NSTableRowView()
        rowView.isEmphasized = false
        return rowView
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = URL(fileURLWithPath: paths[row])
        
        let cell = NSTableCellView()
        let imageView = NSImageView(image: NSWorkspace.shared.icon(forFile: item.path))
        
        let text = NSTextField(labelWithString: item.lastPathComponent)
        let subtitleText = NSTextField(labelWithString: item.deletingLastPathComponent().path)
        if #available(macOS 11, *) {
            subtitleText.font = .preferredFont(forTextStyle: .subheadline)
        } else {
            subtitleText.font = .systemFont(ofSize: 11)
        }
        
        subtitleText.lineBreakMode = .byTruncatingMiddle
        
        subtitleText.textColor = .secondaryLabelColor
        
        let titlesStackView = NSStackView(views: [text, subtitleText])
        titlesStackView.alignment = .left
        titlesStackView.distribution = .equalCentering
        titlesStackView.orientation = .vertical
        titlesStackView.spacing = 0
        
        let stackView = NSStackView(views: [imageView, titlesStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    @objc
    func doubeClickedItem() {
        guard tableView.selectedRow != -1 else { return }
        var copy = Preferences.recentlyOpenedFilePaths
        let item = paths[tableView.selectedRow]
        copy.removeAll { $0 == item } // remove if exists
        copy.append(item) // add item to amke it most recent
        Preferences.recentlyOpenedFilePaths = copy
        paths = Array(copy)
        URLHandler.shared.handleURLChosen(urlChosen: URL(fileURLWithPath: item), senderView: view)
    }
}
