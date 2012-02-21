//
//  AddIngredientViewController.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddIngredientViewController : UIViewController <UITextFieldDelegate> {
	UITextField *textField;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
