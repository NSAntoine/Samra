//
//  AssetCatalogDetailsView.swift
//  Samra
//
//  Created by Serena on 27/02/2023.
// 

import SwiftUI
import AssetCatalogWrapper

/// Shows information about a given asset catalog.
struct AssetCatalogDetailsView: View {
    var assetStorage: CUICommonAssetStorage
    var doneCallback: () -> Void
    
    var body: some View {
        mainView
            .frame(width: 630, height: 450)
    }
    
    @ViewBuilder
    var mainView: some View {
        List(DetailItemSection.from(assetStorage: assetStorage), id: \.self) { section in
            Section(header: Text(section.sectionHeader)) {
                ForEach(section.items, id: \.self) { item in
                    HStack {
                        Text(item.primaryText)
                            .foregroundColor(Color(NSColor.secondaryLabelColor))
                        Spacer()
                        Text(item.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .contextMenu {
                        Button("Copy") {
                            NSPasteboard.general.declareTypes([.string], owner: nil)
                            NSPasteboard.general.setString(item.secondaryText, forType: .string)
                        }
                    }
                }
            }
        }
        
        Spacer()
        Divider()
        Button("Done", action: doneCallback)
            .frame(height: 35, alignment: .center)
    }
}
