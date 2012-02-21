//
//  IngredientsListTableViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "IngredientsListTableViewController.h"


@implementation IngredientsListTableViewController

@synthesize group, data, addButton;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Add item button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
	
	// Turn off selection of cells
	[self.tableView setAllowsSelection:NO];
	
	// Set the title
	if ([self.group isEqualToString:@"proteins"]) {
		[self.navigationItem setTitle:@"Proteins"];
	}
	else if ([self.group isEqualToString:@"flavors"]) {
		[self.navigationItem setTitle:@"Flavors"];
	}
	else if ([self.group isEqualToString:@"fats"]) {
		[self.navigationItem setTitle:@"Fats"];
	}
	else {
		[self.navigationItem setTitle:@"Carbohydrates"];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	
	// Figure out which group we are viewing and load the appropriate list
	self.data = [self buildList:self.group];
	
	// Register for notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(addIngredient:) 
												 name:@"ingredientAdded" 
											   object:nil];
}

- (NSMutableArray *)buildList:(NSString *)forGroup {
	// Figure out which group we are viewing and load the appropriate list
	SpinnerViewController *vc = [[SpinnerViewController alloc] init];
	if ([forGroup isEqualToString:@"proteins"])
		return [vc buildList:@"protein"];
	else if ([forGroup isEqualToString:@"carbs"])
		return [vc buildList:@"carb"];
	else if ([forGroup isEqualToString:@"fats"])
		return [vc buildList:@"fat"];
	else
		return [vc buildList:@"flavor"];
	
	[vc release];	
}

- (void)addItem:(NSNotification *)notification {
	// Show the add item vc
	AddIngredientViewController *vc = [[AddIngredientViewController alloc] initWithNibName:@"AddIngredientViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)deleteFromList:(NSIndexPath *)indexPath {
	// Find the file to write to
	NSString *filePath;
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	if ([self.group isEqualToString:@"proteins"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"protein.txt"];
	}
	else if ([self.group isEqualToString:@"flavors"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"flavor.txt"];
	}
	else if ([self.group isEqualToString:@"fats"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"fat.txt"];
	}
	else {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"carb.txt"];
	}
	
	// Get the text of the row that was seleced
	NSString *selectedText = [[[self.tableView cellForRowAtIndexPath:indexPath] textLabel] text];
	
	// Loop through the data list to figure out which item we're interested in
	int index;
	for (int i = 0; [self.data count]; i++) {
		if ([selectedText isEqualToString:[[self.data objectAtIndex:i] name]]) {
			index = i;
			break;
		}
	}
	
	// Delete the index of interest from the array
	[self.data removeObjectAtIndex:index];
	
	// Build up string array to output
	NSMutableArray *stringList = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < [self.data count]; i++) {
		[stringList addObject:[NSString stringWithFormat:@"%@,%@,%@", [[self.data objectAtIndex:i] name], [[self.data objectAtIndex:i] rating], [[self.data objectAtIndex:i] group]]];
	}
	
	NSString *outputList = [stringList componentsJoinedByString:@"\n"];
	
	// Output to the new file
	NSError *error;
	[outputList writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (void)addIngredient:(NSNotification *)notification {
	// Get user dict
	NSDictionary *dict = [notification userInfo];
	
	// Figure out which file we need to add to
	NSString *filePath, *listName;
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	if ([self.group isEqualToString:@"proteins"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"protein.txt"];
		listName = @"protein";
	}
	else if ([self.group isEqualToString:@"flavors"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"flavor.txt"];
		listName = @"flavor";
	}
	else if ([self.group isEqualToString:@"fats"]) {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"fat.txt"];
		listName = @"fat";
	}
	else {
		filePath = [documentsDirectory stringByAppendingPathComponent:@"carb.txt"];
		listName = @"carbs";
	}
	
	// Get file handle
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	
	// move to the end of the file
	[fileHandle seekToEndOfFile];
	
	// convert the string to an NSData object - add with default value of 1
	NSString *name = [NSString stringWithFormat:@"\n%@,1,%@",
					  [dict valueForKey:@"value"],listName];
	NSData *textData = [name dataUsingEncoding:NSUTF8StringEncoding];
	
	// write the data to the end of the file
	[fileHandle writeData:textData];
	
	// clean up
	[fileHandle closeFile];

	// Rebuild the list and reload
	self.data = [self buildList:self.group];
	[self.tableView reloadData];
	
	// Pop off the add view controller
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] name];
    
    return cell;
}

// If we've only got one entry in the list, don't allow a user to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.data count] == 1)
		return NO;
	else
		return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete from the text file and reload the data
		[self deleteFromList:indexPath];
		self.data = [self buildList:self.group];
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[group release];
	[data release];
	[addButton release];
    [super dealloc];
}


@end

