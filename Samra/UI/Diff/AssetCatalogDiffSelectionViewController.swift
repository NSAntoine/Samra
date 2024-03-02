//
//  AssetCatalogDiffSelectionViewController.swift
//  Samra
//
//  Created by Serena on 06/03/2023.
// 

import Cocoa
import AssetCatalogWrapper

/// A View Controller to select 2 files to diff them.
class AssetCatalogDiffSelectionViewController: NSViewController {
    override func loadView() {
        view = NSView()
        view.frame.size = CGSize(width: 577, height: 208)
    }
    
    typealias DataSource = NSCollectionViewDiffableDataSource<RenditionDiff.Kind, Rendition>
    var dataSource: DataSource!
    
    var leftCatalogInput: AssetCatalogInput?
    var rightCatalogInput: AssetCatalogInput?
    
    var leftCatalogPathLabel: NSTextField!
    var rightCatalogPathLabel: NSTextField!
    
    var leftCatalogPreview: DiffFilePreviewView!
    var rightCatalogPreview: DiffFilePreviewView!
    
    var diffCatalogsButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = NSButton(title: "Left...",
                                  target: self, action: #selector(leftOrRightButtonClicked(sender:)))
        leftButton.tag = DiffSide.left.rawValue
        
        let rightButton = NSButton(title: "Right...",
                                   target: self, action: #selector(leftOrRightButtonClicked(sender:)))
        rightButton.tag = DiffSide.right.rawValue
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        leftCatalogPathLabel = NSTextField(labelWithString: "")
        rightCatalogPathLabel = NSTextField(labelWithString: "")
        
        leftCatalogPathLabel.translatesAutoresizingMaskIntoConstraints = false
        rightCatalogPathLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(leftCatalogPathLabel)
        view.addSubview(rightCatalogPathLabel)
        
        diffCatalogsButton = NSButton(title: "Start Diff", target: self, action: #selector(diffButtonPressed))
        diffCatalogsButton.translatesAutoresizingMaskIntoConstraints = false
        diffCatalogsButton.isEnabled = false
        
        view.addSubview(diffCatalogsButton)
        
        let previewBackgroundColor = NSColor(red: 0.22, green: 0.21, blue: 0.21, alpha: 1.00)
		leftCatalogPreview = makePreview(color: previewBackgroundColor, side: .left)
        leftCatalogPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftCatalogPreview)
        
        let leftCatalogPreviewLabel = NSTextField(labelWithString: "Left")
        leftCatalogPreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        leftCatalogPreviewLabel.alignment = .center
        view.addSubview(leftCatalogPreviewLabel)
        
		rightCatalogPreview = makePreview(color: previewBackgroundColor, side: .right)
        rightCatalogPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightCatalogPreview)
        
        let rightCatalogPreviewLabel = NSTextField(labelWithString: "Right")
        rightCatalogPreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        rightCatalogPreviewLabel.alignment = .center
        view.addSubview(rightCatalogPreviewLabel)
        
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftButton.widthAnchor.constraint(equalToConstant: 80),
            
            rightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25),
            rightButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rightButton.widthAnchor.constraint(equalToConstant: 80),
            
            rightCatalogPreview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            rightCatalogPreview.widthAnchor.constraint(equalToConstant: 55),
            rightCatalogPreview.topAnchor.constraint(equalTo: leftButton.topAnchor),
            rightCatalogPreview.bottomAnchor.constraint(equalTo: rightButton.bottomAnchor),
            
            rightCatalogPreviewLabel.topAnchor.constraint(equalTo: rightCatalogPreview.topAnchor, constant: -20),
            rightCatalogPreviewLabel.leadingAnchor.constraint(equalTo: rightCatalogPreview.leadingAnchor),
            rightCatalogPreviewLabel.trailingAnchor.constraint(equalTo: rightCatalogPreview.trailingAnchor),
            
            leftCatalogPreview.trailingAnchor.constraint(equalTo: rightCatalogPreviewLabel.leadingAnchor, constant: -20),
            leftCatalogPreview.widthAnchor.constraint(equalToConstant: 55),
            leftCatalogPreview.topAnchor.constraint(equalTo: leftButton.topAnchor),
            leftCatalogPreview.bottomAnchor.constraint(equalTo: rightButton.bottomAnchor),
            
            leftCatalogPathLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            leftCatalogPathLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
            leftCatalogPathLabel.trailingAnchor.constraint(equalTo: leftCatalogPreview.leadingAnchor, constant: -20),
            
            leftCatalogPreviewLabel.topAnchor.constraint(equalTo: leftCatalogPreview.topAnchor, constant: -20),
            leftCatalogPreviewLabel.leadingAnchor.constraint(equalTo: leftCatalogPreview.leadingAnchor),
            leftCatalogPreviewLabel.trailingAnchor.constraint(equalTo: leftCatalogPreview.trailingAnchor),
            
            rightCatalogPathLabel.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor),
            rightCatalogPathLabel.leadingAnchor.constraint(equalTo: rightButton.trailingAnchor, constant: 10),
            rightCatalogPathLabel.trailingAnchor.constraint(equalTo: leftCatalogPreview.leadingAnchor, constant: -20),
            
            diffCatalogsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26.4),
            diffCatalogsButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
        ])
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.title = "Diff Catalogs"
        view.window?.styleMask.remove(.resizable)
    }
    
	func makePreview(color: NSColor, side: DiffSide) -> DiffFilePreviewView {
        let preview = DiffFilePreviewView(side: side)
		preview.delegate = self
		return preview
    }
    
    @objc
    func diffButtonPressed() {
        guard let left = leftCatalogInput, let right = rightCatalogInput else { return }
        let rightCollection = right.collection.flatMap(\.renditions)
        let leftCollection = left.collection.flatMap(\.renditions)
        
        let diff = leftCollection.difference(from: rightCollection) { rend1, rend2 in
            return rend1.namedLookup.name == rend2.namedLookup.name
        }
        
        var finalDiffs: [RenditionDiff] = []
        for meow in diff {
            switch meow {
            case .insert(_, let element, _):
                finalDiffs.append(RenditionDiff(rend: element, kind: .added))
            case .remove(_, let element, _):
                finalDiffs.append(RenditionDiff(rend: element, kind: .removed))
            }
        }
        
        WindowController(kind: .diffShow(finalDiffs, left.catalog, left.fileURL)).showWindow(nil)
    }
    
    @objc
    func leftOrRightButtonClicked(sender: NSButton) {
        URLHandler.shared.presentArchiveChooserPanel(senderView: nil) { [unowned self] url in
            validateAndProcessURL(url, forSide: DiffSide(rawValue: sender.tag)!)
        }
    }
    
    func validateAndProcessURL(_ url: URL, forSide side: DiffSide) {
        // if it's an .app, point to it's .car file
        let urlToChoose = url.pathExtension == "app" ? url.appendingPathComponent("Contents/Resources/Assets.car") : url
        guard FileManager.default.fileExists(atPath: urlToChoose.path) else {
            NSAlert(title: "Asset Catalog file \(urlToChoose.path) doesn't exist").runModal()
            return
        }
        
        do {
            switch side {
            case .left:
                leftCatalogInput = try AssetCatalogInput(fileURL: urlToChoose)
                leftCatalogPathLabel.stringValue = urlToChoose.path
				leftCatalogPreview.imageView.image = NSWorkspace.shared.icon(forFile: url.path)
            case .right:
                rightCatalogInput = try AssetCatalogInput(fileURL: urlToChoose)
                rightCatalogPathLabel.stringValue = urlToChoose.path
				rightCatalogPreview.imageView.image = NSWorkspace.shared.icon(forFile: url.path)
            }
   
            diffCatalogsButton.isEnabled = rightCatalogInput != nil && leftCatalogInput != nil
        } catch {
            NSAlert(title: "Unable to open Asset Catalog file \(urlToChoose.path)")
                .runModal()
        }
    }
    
    func setImageViewForPreview(url: URL, side: DiffSide) {
		switch side {
		case .left:
			leftCatalogPreview.imageView.image = NSWorkspace.shared.icon(forFile: url.path)
		case .right:
			rightCatalogPreview.imageView.image = NSWorkspace.shared.icon(forFile: url.path)
		}
    }
}

extension AssetCatalogDiffSelectionViewController: DiffFilePreviewDelegate {
	func diffFilePreview(_ view: DiffFilePreviewView, didGetURLDragged urlRecieved: URL) {
		validateAndProcessURL(urlRecieved, forSide: view.side)
	}
}
