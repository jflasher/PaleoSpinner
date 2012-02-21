//
//  AddIngredientViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AddIngredientViewController.h"


@implementation AddIngredientViewController

@synthesize textField;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set title
	[self.navigationItem setTitle:@"Add Ingredient"];
	
	// Enable text box 
	[self.textField setSelected:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// Build up a user dict to pass back to list
	NSDictionary *dict = [NSDictionary dictionaryWithObject:self.textField.text forKey:@"value"];
	
	// Send out a message
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ingredientAdded" object:self userInfo:dict];
	
	return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textField release];
    [super dealloc];
}


@end
