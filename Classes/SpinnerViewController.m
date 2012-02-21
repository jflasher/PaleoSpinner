//
//  SpinnerViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SpinnerViewController.h"


@implementation SpinnerViewController

@synthesize picker, fatList, flavorList, carbList, proteinList;
@synthesize proteinLockButton, fatLockButton, carbLockButton, flavorLockButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	// Register for notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(shakeDetected:) 
												 name:@"shakeDetected" 
											   object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Make sure to hide the nav bar at top
	[self.navigationController setNavigationBarHidden:YES];
	
	// Build the ingredients lists
	[self buildIngredientsLists];
	
	// Reload the data so we catch any voting changes
	[self.picker reloadAllComponents];
}

- (void)buildIngredientsLists {
	self.proteinList = [self buildList:@"protein"];
	self.fatList = [self buildList:@"fat"];
	self.carbList = [self buildList:@"carb"];
	self.flavorList = [self buildList:@"flavor"];
}

- (NSMutableArray *)buildList:(NSString *)listName {
	NSError *error;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	// Get the path to the file
	NSString *filePath;
	if ([listName isEqualToString:@"protein"])
		filePath = [documentsDirectory stringByAppendingPathComponent:@"protein.txt"];
	else if ([listName isEqualToString:@"flavor"])
		filePath = [documentsDirectory stringByAppendingPathComponent:@"flavor.txt"];
	else if ([listName isEqualToString:@"fat"])
		filePath = [documentsDirectory stringByAppendingPathComponent:@"fat.txt"];
	else
		filePath = [documentsDirectory stringByAppendingPathComponent:@"carb.txt"];
	
	// Read in all the lines from the file
	NSArray *lines = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
	
	// We've got each individual line, now step through them and build up an object
	for (int i=0;i < [lines count]; i++) {
		NSString *line = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if (![line isEqualToString:@""]) {		
			// Build the object
			Ingredient *ingredient = [[[Ingredient alloc] init] autorelease];
			
			ingredient.name = [[[line componentsSeparatedByString:@","] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			ingredient.rating = [[[line componentsSeparatedByString:@","] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			ingredient.group = [[[line componentsSeparatedByString:@","] objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			// Add the object to the array
			[tmpArray addObject:ingredient];
		}
	}
	
	// Now sort the list by name
	NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:nameSortDescriptor];
	NSArray *sortedArray = [tmpArray sortedArrayUsingDescriptors:sortDescriptors];
	
	// Return the sorted areay
	return [NSMutableArray arrayWithArray:sortedArray];
}

- (void)shakeDetected:(NSNotification *)notification {
	// Only do something with the shake if the spinner view is top level
	if ([self.navigationController topViewController] == self)
		[self pickResult];
}

// Get the results and display them
- (IBAction)pickResult {
	// Get the protein result
	Ingredient *protein;
	if ([proteinLockButton isSelected]) {
		// Get the selected index from the picker wheel
		NSInteger pickerIndex = [self.picker selectedRowInComponent:0];
		protein = [proteinList objectAtIndex:pickerIndex];
	}
	else
		protein = [self randomlyPickIngredient:proteinList];
	
	// Get the fat result
	Ingredient *fat;
	if ([fatLockButton isSelected]) {
		// Get the selected index from the picker wheel
		NSInteger pickerIndex = [self.picker selectedRowInComponent:1];
		fat = [fatList objectAtIndex:pickerIndex];
	}
	else
		fat = [self randomlyPickIngredient:fatList];	
	
	// Get the carb result
	Ingredient *carb;
	if ([carbLockButton isSelected]) {
		// Get the selected index from the picker wheel
		NSInteger pickerIndex = [self.picker selectedRowInComponent:2];
		carb = [carbList objectAtIndex:pickerIndex];
	}
	else
		carb = [self randomlyPickIngredient:carbList];	
	
	// Get the flavor result
	Ingredient *flavor;
	if ([flavorLockButton isSelected]) {
		// Get the selected index from the picker wheel
		NSInteger pickerIndex = [self.picker selectedRowInComponent:3];
		flavor = [flavorList objectAtIndex:pickerIndex];
	}
	else
		flavor = [self randomlyPickIngredient:flavorList];	
	
	
	// Build the ingredients array
	NSMutableArray *ingArr = [NSMutableArray arrayWithObjects:protein, fat, carb, flavor, nil];
	
	// Build the name string and check this against the Yuck list, if it matches something in there, run this loop again!
	NSString *name = [NSString stringWithFormat:@"%@ with %@, %@ and %@", 
					  [[ingArr objectAtIndex:0] name], 
					  [[ingArr objectAtIndex:1] name], 
					  [[ingArr objectAtIndex:2] name], 
					  [[ingArr objectAtIndex:3] name]];
	YuckTableViewController *yuckVC = [[[YuckTableViewController alloc] init] autorelease];
	NSMutableArray *yuckList = [yuckVC buildList];
	
	int matches = 0;
	for (int i = 0; i < [yuckList count]; i++) {
		if ([name isEqualToString:[yuckList objectAtIndex:i]])
			matches++;
	}
	
	if (matches >= 1) {
		// If for some reason the user has all options locked and our only option is 
		// something on the yuck list, pop up a snarky message.
		if ([carbLockButton isSelected] && [fatLockButton isSelected] && [proteinLockButton isSelected] && [flavorLockButton isSelected]) {
			// Pop up a message
			NSString *msg = @"You've locked in a combo that you previously added to your yuck list. You may want to evaluate your life decisions.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg 
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		else {
			[self pickResult];
		}
	}
	else {
		// Init the results view
		ResultsViewController *vc = [[[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil] autorelease];
		vc.ingredientsArray = ingArr;
		[self.navigationController pushViewController:vc animated:YES];	
	}
}

- (Ingredient *)randomlyPickIngredient:(NSMutableArray *)list {
	// Get array of values
	NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < [list count]; i++) {
		[valueArray addObject:[[list objectAtIndex:i] rating]];
	}
	
	// Get total of all ratings
	NSInteger totalRatings = 0;
	for (int i = 0; i < [valueArray count]; i++) {
		totalRatings = totalRatings + [[valueArray objectAtIndex:i] integerValue];
	}
	
	// Build up array of indexes
	NSMutableArray *indexArray = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%i", ([[valueArray objectAtIndex:0] integerValue] - 1)]];
	for (int i = 1; i < [list count]; i++) {
		[indexArray addObject:[NSString stringWithFormat:@"%i",([[indexArray objectAtIndex:i-1] integerValue] + [[valueArray objectAtIndex:i] integerValue])]];
	}
	
	// Pick a random value between 0 and totalRatings
	// In the special case of 1 element, we need to make sure to pick that one
	NSInteger ranNum;
	if ([valueArray count] == 1)
		return [list objectAtIndex:0];
	else {
		ranNum = arc4random() % (totalRatings - 1);
	
		// Find which index this belongs to
		for (int i = [indexArray count] - 1; i >= 0; i--) {
			if (ranNum >= [[indexArray objectAtIndex:i] integerValue]) {
				return [list objectAtIndex:i+1];
			}
		}
		// If we got to this point and ingredient is undefined, use the first value in list
		return [list objectAtIndex:0];
	}
}

- (IBAction)selectLock:(id)sender {
	if ([sender isSelected])
		[sender setSelected:NO];
	else
		[sender setSelected:YES];
}

// Picker view methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	// Protein, Fat, Carb, Flavor
	return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0)
		return [proteinList count];
	else if (component == 1)
		return [fatList count];
	else if (component == 2)
		return [carbList count];
	else
		return [flavorList count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	// Set font
	UIFont *labelfont = [UIFont systemFontOfSize:15];
	
	// Get text
	NSString *text;
	if (component == 0) 
		text = [[proteinList objectAtIndex:row] name];
	else if (component == 1)
		text = [[fatList objectAtIndex:row] name];
	else if (component == 2)
		text = [[carbList objectAtIndex:row] name];
	else 
		text = [[flavorList objectAtIndex:row] name];
	
	// Make the label
	// Set up the frame for the label
	CGRect frame;
	frame.size = [text sizeWithFont:labelfont];
	CGSize size = CGSizeMake (108, 10);
	frame.size.width = size.width;
	// center it vertically
	//frame.origin.y = (self.frame.size.height / 2) - (frame.size.height / 2) - 0.5;
	// align it to the right side of the wheel, with a margin.
	// use a smaller margin for the rightmost wheel.
	//frame.origin.x = rightsideofwheel - frame.size.width -
	//(component == self.numberOfComponents - 1 ? 5 : 7);
	
	// set up the label
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.text = text;
	label.font = labelfont;
	label.backgroundColor = [UIColor clearColor];
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0,1);
	
	//[label setAdjustsFontSizeToFitWidth:YES];
	//[label setAutoresizesSubviews:YES];
	[label setLineBreakMode:UILineBreakModeMiddleTruncation];
	[label setTextAlignment:UITextAlignmentCenter];	
	// return
	return label;
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
	[picker release];
	[flavorList release];
	[carbList release];
	[fatList release];
	[proteinList release];
	[carbLockButton release];
	[proteinLockButton release];
	[fatLockButton release];
	[flavorLockButton release];
    [super dealloc];
}


@end
