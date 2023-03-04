//
//  TypesListViewController.swift
//  Samra
//
//  Created by Serena on 18/02/2023.
// 

import Cocoa
import AssetCatalogWrapper

class TypesListViewController: NSViewController {
    typealias SectionClickedHandler = (RenditionType) -> Void
    
    let changeHandler: SectionClickedHandler
    
    let allTypes: [RenditionType]
    // the types shown in the UI, if there is a search session, this may not be equal to allTypes
    // depending on if the search result's types are less than allTypes
    var types: [RenditionType]
    
    // for when manually doing select and deselectRow
    var ignoreChanges: Bool = false
    
    var tableView: NSTableView!
    
    init(types: [RenditionType], changeHandler: @escaping SectionClickedHandler) {
        self.types = types
        self.allTypes = types
        self.changeHandler = changeHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.target = self
        tableView.headerView = nil
        
        let col = NSTableColumn(identifier: "Column")
        tableView.addTableColumn(col)
        
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasHorizontalScroller = false
        view = scrollView
        view.frame.size = CGSize(width: 200, height: 0)
        
        setupMenuBarItems()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        // disable section items
        for item in NSApplication.shared.mainMenu?.items ?? [] {
            guard item.title == "Sections", let submenu = item.submenu else {
                continue
            }
            
            for item in submenu.items {
                item.isEnabled = false
                item.keyEquivalent = ""
            }
        }
    }
    
    
    override func performTextFinderAction(_ sender: Any?) {
        for item in view.window?.toolbar?.items ?? [] {
            if let search = item.view as? NSSearchField {
                search.becomeFirstResponder()
                break
            }
        }
    }
    
    @objc
    func goToSection(menuItemSender: NSMenuItem) {
        let selectedTypeIndex = allTypes.firstIndex { type in
            type.rawValue == menuItemSender.tag
        }
        
        guard let selectedTypeIndex else { return }
        changeSection(to: selectedTypeIndex)
    }
    
    func setupMenuBarItems() {
        let allRawValues = allTypes.map(\.rawValue)
        for item in NSApplication.shared.mainMenu?.items ?? [] {
            guard item.title == "Sections", let submenu = item.submenu else {
                continue
            }
            
            submenu.autoenablesItems = false
            for submenuItem in submenu.items {
                submenuItem.isEnabled = allRawValues.contains(submenuItem.tag)
                
                // set the keyboard combo to be command+(index + 1)
                // for example, if the first item on the list is Color
                // then the combo would be cmd 1
                if submenuItem.isEnabled,
                   let rawValueIndx = allRawValues.firstIndex(of: submenuItem.tag) {
                    submenuItem.keyEquivalent = (rawValueIndx + 1).description
                }
            }
        }
    }
    
}

extension TypesListViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let type = types[row]
        let cell = NSTableCellView()
        let imageIconView = NSImageView()
        imageIconView.image = NSImage(systemName: type.displayIconName)
        
        let stackView = NSStackView(views: [imageIconView,
                                            NSTextField(labelWithString: type.description)])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func changeSection(to index: Int) {
        if !ignoreChanges {
            changeHandler(types[index])
        }
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        changeSection(to: tableView.selectedRow)
    }
}

extension RenditionType {
    var displayIconName: String {
        switch self {
        case .image, .svg:
            return "photo"
        case .icon:
            return "app"
        case .imageSet:
            if #available(macOS 13, iOS 16, *) {
                return "photo.stack"
            }
            
            return "rectangle.stack"
        case .multiSizeImageSet:
            return "cube.box"
        case .pdf:
            return "doc.richtext"
        case .color:
            return "paintbrush"
        case .rawData:
            return "text.quote"
        case .unknown:
            return "questionmark.app"
        }
    }
}
