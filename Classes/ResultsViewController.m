//
//  ResultsViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResultsViewController.h"


@implementation ResultsViewController

@synthesize label, ingredientsArray;

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
	
	// Build up the label string
	NSString *name = [NSString stringWithFormat:@"%@ with %@, %@ and %@", 
					  [[ingredientsArray objectAtIndex:0] name], 
					  [[ingredientsArray objectAtIndex:1] name], 
					  [[ingredientsArray objectAtIndex:2] name], 
					  [[ingredientsArray objectAtIndex:3] name]];
	
	[self.label setText:name];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Show the bar at top so we can get back
	[self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)yumButtonPressed {
	// Upvote each ingredient
	[self voteForIngredient:[ingredientsArray objectAtIndex:0]];
	[self voteForIngredient:[ingredientsArray objectAtIndex:1]];
	[self voteForIngredient:[ingredientsArray objectAtIndex:2]];
	[self voteForIngredient:[ingredientsArray objectAtIndex:3]];
	
	// Add to the list of yum recipes
	// get a handle to the file
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"yum.txt"];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	
	// move to the end of the file
	[fileHandle seekToEndOfFile];
	
	// convert the string to an NSData object
	NSString *name = [NSString stringWithFormat:@"\n%@ with %@, %@ and %@", 
					  [[ingredientsArray objectAtIndex:0] name], 
					  [[ingredientsArray objectAtIndex:1] name], 
					  [[ingredientsArray objectAtIndex:2] name], 
					  [[ingredientsArray objectAtIndex:3] name]];
	NSData *textData = [name dataUsingEncoding:NSUTF8StringEncoding];
	
	// write the data to the end of the file
	[fileHandle writeData:textData];
	
	// clean up
	[fileHandle closeFile];
	
	// Pop up a message
	NSString *msg = @"This combo has been added to your Yum! list and each ingredient is more likely to appear again.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)yuckButtonPressed {
	// Add to the list of yuck recipes
	// get a handle to the file
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"yuck.txt"];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	
	// move to the end of the file
	[fileHandle seekToEndOfFile];
	
	// convert the string to an NSData object
	NSString *name = [NSString stringWithFormat:@"\n%@ with %@, %@ and %@", 
					  [[ingredientsArray objectAtIndex:0] name], 
					  [[ingredientsArray objectAtIndex:1] name], 
					  [[ingredientsArray objectAtIndex:2] name], 
					  [[ingredientsArray objectAtIndex:3] name]];
	NSData *textData = [name dataUsingEncoding:NSUTF8StringEncoding];
	
	// write the data to the end of the file
	[fileHandle writeData:textData];
	
	// clean up
	[fileHandle closeFile];
	
	
	// Pop up a message
	NSString *msg = @"Don't fret! This combo will never appear again.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)voteForIngredient:(Ingredient *)ingredient {
	// Find the file
	NSString *filePath, *listName;
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	if ([ingredient.group isEqualToString:@"protein"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"protein.txt"];
		listName = @"protein";
	}
	else if ([ingredient.group isEqualToString:@"flavor"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"flavor.txt"];
		listName = @"flavor";
	}
	else if ([ingredient.group isEqualToString:@"fat"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"fat.txt"];
		listName = @"fat";
	}
	else {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"carb.txt"];
		listName = @"carb";
	}
	
	// Get the array of entries in the list
	SpinnerViewController *spinnerVC = [[[SpinnerViewController alloc] init] autorelease];
	NSMutableArray *inputList = [spinnerVC buildList:listName];
	
	// Find the ingredient in the list
	int index=99999;
	for (int i = 0; i < [inputList count]; i++) {
		if ([ingredient.name isEqualToString:[[inputList objectAtIndex:i] name]]) {
			index = i;
			break;
		}
	}
	
	// Make sure we got something
	if (index == 99999)
		return;
	
	// Update this entry, increment the rating
	Ingredient *ing = [inputList objectAtIndex:index];
	NSInteger curRating = [ing.rating integerValue];
	NSInteger newRating = curRating + 1;
	ing.rating = [NSString stringWithFormat:@"%i", newRating];
	[inputList replaceObjectAtIndex:index withObject:ing];
	
	// Build up string array to output
	NSMutableArray *stringList = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < [inputList count]; i++) {
		[stringList addObject:[NSString stringWithFormat:@"%@,%@,%@", [[inputList objectAtIndex:i] name], [[inputList objectAtIndex:i] rating], [[inputList objectAtIndex:i] group]]];
	}
	
	NSString *outputList = [stringList componentsJoinedByString:@"\n"];
	
	// Output to the new file
	NSError *error;
	[outputList writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
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
    [super dealloc];
	[ingredientsArray release];
	[label release];
}


@end
