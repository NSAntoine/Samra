//
//  AssetCatalogDocument.swift
//  Samra
//
//  Created by Serena on 02/03/2023.
// 

import Cocoa
import AssetCatalogWrapper

// this NSDocument subclass is from https://github.com/insidegui/AssetCatalogTinkerer
// (because this app is my first attempt at AppKit and I didn't really know how to do NSDocument)..
// but adjusted for Samra
class AssetCatalogDocument: NSDocument {
    override func read(from url: URL, ofType typeName: String) throws {
        let windowController = WindowController(kind: .assetCatalog(try AssetCatalogInput(fileURL: url)))
        addWindowController(windowController)
        windowController.showWindow(nil)
    }
}
