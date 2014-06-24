//
//  YelpFilters.h
//  Yelp
//
//  Created by Osvaldo Sabina on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpFilters : NSObject

+ (YelpFilters *)getOrInitFilters;

- (BOOL)isSelectedRow:(NSInteger) row withSection:(NSInteger)section;
- (BOOL)sectionExpanded:(NSInteger) section;
- (BOOL)toggleSectionExpanded:(NSInteger) section;
- (BOOL)toggleSelectionRow:(NSInteger)row withSection:(NSInteger)section;

@property (strong,nonatomic) NSArray *filters;

@end
