//
//  SpinnerViewController.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"
#import "ResultsViewController.h"
#import "YuckTableViewController.h"


@interface SpinnerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *picker;
	NSMutableArray *proteinList;
	NSMutableArray *carbList;
	NSMutableArray *fatList;
	NSMutableArray *flavorList;
	
	UIButton *proteinLockButton;
	UIButton *carbLockButton;
	UIButton *fatLockButton;
	UIButton *flavorLockButton;
}

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *proteinList;
@property (nonatomic, retain) NSMutableArray *carbList;
@property (nonatomic, retain) NSMutableArray *fatList;
@property (nonatomic, retain) NSMutableArray *flavorList;
@property (nonatomic, retain) IBOutlet UIButton *proteinLockButton;
@property (nonatomic, retain) IBOutlet UIButton *carbLockButton;
@property (nonatomic, retain) IBOutlet UIButton *fatLockButton;
@property (nonatomic, retain) IBOutlet UIButton *flavorLockButton;

- (void)buildIngredientsLists;
- (NSMutableArray *)buildList:(NSString *)listName;
- (IBAction)pickResult;
- (void)shakeDetected:(NSNotification *)notification;
- (Ingredient *)randomlyPickIngredient:(NSMutableArray *)list;
- (IBAction)selectLock:(id)sender;

@end
