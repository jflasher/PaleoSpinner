//
//  IngredientsListTableViewController.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerViewController.h"
#import "AddIngredientViewController.h"


@interface IngredientsListTableViewController : UITableViewController {
	NSString *group;
	NSMutableArray *data;
	UIBarButtonItem *addButton;
}

@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void)deleteFromList:(NSIndexPath *)indexPath;
- (NSMutableArray *)buildList:(NSString *)forGroup;
- (void)addItem:(NSNotification *)notification;
- (void)addIngredient:(NSNotification *)notification;

@end
