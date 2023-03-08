//
//  DiffListViewController.swift
//  Samra
//
//  Created by Serena on 07/03/2023.
// 

import Cocoa
import class SwiftUI.NSHostingController
import AssetCatalogWrapper

class DiffListViewController: NSViewController {
    
    typealias DataSource = NSCollectionViewDiffableDataSource<RenditionDiff.Kind, Rendition>
    var dataSource: DataSource!
    
    let diffs: [RenditionDiff]
    var catalog: CUICatalog
    var fileURL: URL
    
    init(diffs: [RenditionDiff], catalog: CUICatalog, fileURL: URL) {
        self.diffs = diffs
        self.catalog = catalog
        self.fileURL = fileURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let collectionView = NSCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = RenditionListViewController.makeLayout(layout: .horizontal)
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, rendition in
            let cell = collectionView.makeItem(withIdentifier: RenditionCollectionViewItem.reuseIdentifier,
                                               for: indexPath) as! RenditionCollectionViewItem
            cell.configure(rendition: rendition)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            guard kind == NSCollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let header = collectionView.makeSupplementaryView(
                ofKind: kind,
                withIdentifier: RenditionTypeHeaderView.identifier,
                for: indexPath) as! RenditionTypeHeaderView
            let snapshot = dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            header.configure(typeLabelText: section.description, numberOfItems: snapshot.numberOfItems(inSection: section))
            return header
        }
        
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.isSelectable = true
        collectionView.register(RenditionCollectionViewItem.self,
                                forItemWithIdentifier: RenditionCollectionViewItem.reuseIdentifier)
        collectionView.register(RenditionTypeHeaderView.self,
                                forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
                                withIdentifier: RenditionTypeHeaderView.identifier)
        
        addSnapshot(diffs: diffs)
        let scrollView = NSScrollView()
        scrollView.verticalScroller = nil
        scrollView.documentView = collectionView
        scrollView.hasHorizontalScroller = false
        view = scrollView
        view.frame.size = CGSize(width: 724, height: 676)
    }
    
    func addSnapshot(diffs: [RenditionDiff]) {
        var snapshot = NSDiffableDataSourceSnapshot<RenditionDiff.Kind, Rendition>()
        // i want to cuddle a femboyyyy 🥺
        let justSections = Set(diffs.map(\.kind)) // remove duplicates
        snapshot.appendSections(Array(justSections))
        for diff in diffs {
            snapshot.appendItems([diff.rend], toSection: diff.kind)
        }
        dataSource.apply(snapshot)
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        for item in view.window?.toolbar?.items ?? [] {
            if let search = item.view as? NSSearchField {
                search.becomeFirstResponder()
                break
            }
        }
    }
    
}

extension DiffListViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return [indexPaths.first!]
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let first = indexPaths.first,
              let item = dataSource.itemIdentifier(for: first) else {
            return
        }
        
        let view = RenditionInformationView(rendition: item, catalog: catalog, fileURL: fileURL, canEdit: false, canDelete: false, changeCallback: nil) { [unowned self] in
            // done callback
            guard let currentlyBeingPresented = presentedViewControllers?.first else { return }
            dismiss(currentlyBeingPresented)
        }
        let controller = NSHostingController(rootView: view)
        controller.view.frame.size = CGSize(width: 650, height: 500)
        presentAsSheet(controller)
    }
}
extension DiffListViewController: NSSearchFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let searchText = (obj.object as? NSSearchField)?.stringValue else { return }
        if searchText.isEmpty {
            addSnapshot(diffs: diffs)
            return
        }
        
        let new = diffs.filter { diff in
            return diff.rend.name.localizedCaseInsensitiveContains(searchText)
        }
        addSnapshot(diffs: new)
    }
}
