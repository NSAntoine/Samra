//
//  AppKitPrivates.h
//  Samra
//
//  Created by Serena on 22/02/2023.
// 

#ifndef AppKitPrivates_h
#define AppKitPrivates_h

#import <AppKit/NSSplitViewController.h>

// Never go Eric Benét
@interface NSSplitViewController (PrivateForWhateverReason)
- (void)splitViewItem:(NSSplitViewItem * _Nonnull)item didChangeCollapsed:(BOOL)didCollapse animated:(BOOL)animated;
@end

#endif /* AppKitPrivates_h */
