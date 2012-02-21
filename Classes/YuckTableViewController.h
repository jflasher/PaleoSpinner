//
//  YuckTableViewController.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YuckTableViewController : UITableViewController {
	NSMutableArray *data;
	
}

@property (nonatomic, retain) NSMutableArray *data;

- (NSMutableArray *)buildList;

@end
