//
//  CollapseNotifierSplitViewController.swift
//  Samra
//
//  Created by Serena on 22/02/2023.
// 

import Cocoa
import AppKitPrivates

/// A NSSPlitViewController subclass that notifies it's reciever
/// when a collapse status changes
class CollapseNotifierSplitViewController: NSSplitViewController {
    typealias Handler = (_ item: NSSplitViewItem, _ didCollapse: Bool, _ animated: Bool) -> Void
    
    var handler: Handler? = nil
    
    /// Whether or not the view controller should focus on the search bar
    /// when the cmd+f combo is clicked
    var shouldFocusOnSearchBar: Bool = false
    
    override func splitViewItem(_ item: NSSplitViewItem, didChangeCollapsed didCollapse: Bool, animated: Bool) {
        super.splitViewItem(item, didChangeCollapsed: didCollapse, animated: animated)
        handler?(item, didCollapse, animated)
    }
}
