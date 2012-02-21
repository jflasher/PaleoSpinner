//
//  Ingredient.m
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Ingredient.h"


@implementation Ingredient

@synthesize name, rating, group;


- (void)dealloc {
	[name release];
	[rating release];
	[group release];
    [super dealloc];
}

@end
