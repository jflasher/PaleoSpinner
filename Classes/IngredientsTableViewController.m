//
//  IngredientsTableViewController.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "IngredientsTableViewController.h"


@implementation IngredientsTableViewController

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *namesArray = [NSArray arrayWithObjects:@"Proteins", @"Fats", @"Carbohydrates", @"Flavors", nil];
	cell.textLabel.text = [namesArray objectAtIndex:indexPath.row];
	
	// Make all the rows selectable
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	IngredientsListTableViewController *detailViewController = [[IngredientsListTableViewController alloc] initWithNibName:@"IngredientsListTableViewController" bundle:nil];
	// Assign the group
	if (indexPath.row == 0)
		detailViewController.group = @"proteins";
	else if (indexPath.row == 1)
		detailViewController.group = @"fats";
	else if (indexPath.row == 2)
		detailViewController.group = @"carbs";
	else
		detailViewController.group = @"flavors";

    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
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
    [super dealloc];
}


@end

