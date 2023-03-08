//
//  AssetCatalogInput.swift
//  Samra
//
//  Created by Serena on 06/03/2023.
// 

import AssetCatalogWrapper

struct AssetCatalogInput {
    let fileURL: URL
    let catalog: CUICatalog
    let collection: RenditionCollection
    
    init(fileURL: URL, catalog: CUICatalog, collection: RenditionCollection) {
        self.fileURL = fileURL
        self.catalog = catalog
        self.collection = collection
    }
    
    init(fileURL: URL) throws {
        let (catalog, collection) = try AssetCatalogWrapper.shared.renditions(forCarArchive: fileURL)
        self.catalog = catalog
        self.collection = collection
        self.fileURL = fileURL
    }
}
