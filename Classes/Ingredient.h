//
//  Ingredient.h
//  PaleoSpinner
//
//  Created by Joseph Flasher on 10/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ingredient : NSObject {
	NSString *name;
	NSString *rating;
	NSString *group;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *group;

@end
