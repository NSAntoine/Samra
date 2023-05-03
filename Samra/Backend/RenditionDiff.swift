//
//  DiffKind.swift
//  Samra
//
//  Created by Serena on 07/03/2023.
// 

import AssetCatalogWrapper

struct RenditionDiff {
    let rend: Rendition
    let kind: Kind
    
    enum Kind: CustomStringConvertible {
        case added
        case removed
        
        var description: String {
            switch self {
            case .added:
                return "Added"
            case .removed:
                return "Removed"
            }
        }
    }
}

enum DiffSide: Int {
	case left = 1
	case right = 2
}
