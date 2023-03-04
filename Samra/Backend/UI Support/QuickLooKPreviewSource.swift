//
//  QuickLooKPreviewSource.swift
//  Samra
//
//  Created by Serena on 03/03/2023.
// 

import Cocoa
import QuickLookUI

class QuickLookPreviewSource: NSObject, QLPreviewPanelDataSource {
    let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return fileURL as QLPreviewItem
    }
}
