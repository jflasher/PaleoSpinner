//
//  ResultsViewController.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"
#import "SpinnerViewController.h"


@interface ResultsViewController : UIViewController {
	NSMutableArray *ingredientsArray;
	UILabel *label;
}

@property (nonatomic, retain) NSMutableArray *ingredientsArray;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction)yumButtonPressed;
- (IBAction)yuckButtonPressed;
- (void)voteForIngredient:(Ingredient *)ingredient;

@end
