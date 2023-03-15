//
//  main.swift
//  extractutil
//
//  Created by Serena on 15/03/2023.
// 
// smol CommandLine tool to just extract an asset catalog :3

import Foundation
import AssetCatalogWrapper

guard CommandLine.arguments.count >= 3 else {
    fatalError("usage: \(CommandLine.arguments[0]) <catalog-url> <directory-to-extract-to>")
}

let catalogURL = URL(fileURLWithPath: CommandLine.arguments[1])
let destinationURL = URL(fileURLWithPath: CommandLine.arguments[2])

let rends: RenditionCollection

do {
    rends = try AssetCatalogWrapper.shared.renditions(forCarArchive: catalogURL).1
} catch {
    fatalError("Failed to fetch Catalog from URL \(catalogURL.path), error: \(error.localizedDescription)")
}

// try create the destination URL if it doesn't exist
if !FileManager.default.fileExists(atPath: destinationURL.path) {
    do {
        print("destination URL \(destinationURL.path) doesn't exist, will try to create")
        try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true)
    } catch {
        fatalError("Failed to create \(destinationURL.path), error: \(error.localizedDescription)")
    }
}

do {
    try AssetCatalogWrapper.shared.extract(collection: rends, to: destinationURL)
    print("Extracted catalog to \(destinationURL.path)")
} catch {
    fatalError("Failed to extract (some) items, error: \(error.localizedDescription)")
}
