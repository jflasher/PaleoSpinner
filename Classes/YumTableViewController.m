//
//  YumTableViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "YumTableViewController.h"


@implementation YumTableViewController

@synthesize data;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Build the data list
	self.data = [self buildList];
	
	// Turn off selection of cells
	[self.tableView setAllowsSelection:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//Reload the data
	self.data = [self buildList];
	[self.tableView reloadData];
}

- (NSMutableArray *)buildList {
	NSError *error;
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	// Get the path to the file
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"yum.txt"];
	
	// Read in all the lines from the file
	NSArray *lines = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
	
	// We've got each individual line, now step through them and build up an object
	for (int i=0;i < [lines count]; i++) {
		NSString *line = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
						
		// Add the line to the array
		if (![line isEqualToString:@""])
			[tmpArray addObject:line];
	}
		
	return tmpArray;
}

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
 interfaceOrientation == UIInterfaceOrientationLandscapeRight);
 }

- (void)deleteFromList:(NSIndexPath *)indexPath {
	// We know what row we're looking at, so just delete that one from the text file
	NSMutableArray *inputList = [self buildList];
	[inputList removeObjectAtIndex:indexPath.row];
	NSString *outputList = [inputList componentsJoinedByString:@"\n"];
	
	// Save out the new list to disk
	NSError *error;
	NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"yum.txt"];
	[outputList writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Make sure text can fit in cell without clipping
		
	// Get size
	NSString *cellText = [self.data objectAtIndex:indexPath.row];
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:20.0];
	CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	// Add a buffer
	return labelSize.height + 20;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
	
	
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete from the text file and reload the data
		[self deleteFromList:indexPath];
		self.data = [self buildList];
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	[data release];
    [super dealloc];
}


@end

