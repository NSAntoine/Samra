//
//  DiffFilePreviewView.swift
//  Samra
//
//  Created by Serena on 03/05/2023.
//

import Cocoa

class DiffFilePreviewView: NSView {
	let side: DiffSide
	let imageView = NSImageView()
	
	weak var delegate: DiffFilePreviewDelegate?
	
	init(side: DiffSide) {
		self.side = side
		super.init(frame: .zero)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// setup the view
	func commonInit() {
		let previewBackgroundColor = NSColor(red: 0.22, green: 0.21, blue: 0.21, alpha: 1.00)
		
		let previewLayer = CALayer()
		previewLayer.backgroundColor = previewBackgroundColor.cgColor
		previewLayer.borderColor = NSColor.lightGray.cgColor
		previewLayer.borderWidth = 1.34
		previewLayer.cornerRadius = 8
		layer = previewLayer
		wantsLayer = true
		
		registerForDraggedTypes([.fileURL])
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.heightAnchor.constraint(equalTo: heightAnchor),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		return .generic
	}
	
	override func draggingEnded(_ sender: NSDraggingInfo) {
		sender.enumerateDraggingItems(for: nil, classes: [NSURL.self]) { [unowned self] item, t, ptr in
			let asURL = item.item as! URL
			delegate?.diffFilePreview(self, didGetURLDragged: asURL)
		}
	}
}

protocol DiffFilePreviewDelegate: AnyObject {
	func diffFilePreview(_ view: DiffFilePreviewView, didGetURLDragged: URL)
}
