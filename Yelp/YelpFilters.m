//
//  YelpFilters.m
//  Yelp
//
//  Created by Osvaldo Sabina on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpFilters.h"

@implementation YelpFilters

static YelpFilters *sharedFilter = nil;

- (BOOL)sectionExpanded:(NSInteger) section {
    return [self.filters[section][@"expanded"] boolValue];
}

- (BOOL)toggleSectionExpanded:(NSInteger) section {
    self.filters[section][@"expanded"] =
    ([self.filters[section][@"expanded"] boolValue] == YES) ?
                                       [NSNumber numberWithBool:NO] :
                                       [NSNumber numberWithBool:YES];
    return [self.filters[section][@"expanded"] boolValue];
}

- (BOOL)toggleSelectionRow:(NSInteger)row withSection:(NSInteger)section {
    self.filters[section][@"options"][row][@"selected"]  =
    ([self.filters[section][@"options"][row][@"selected"] boolValue] == YES) ?
    [NSNumber numberWithBool:NO] :
    [NSNumber numberWithBool:YES];
    return [self.filters[section][@"options"][row][@"selected"] boolValue];
}

- (BOOL)isSelectedRow:(NSInteger) row withSection:(NSInteger)section  {
    return [self.filters[section][@"options"][row][@"selected"] boolValue];
}

+ (YelpFilters *)getOrInitFilters {
    if (sharedFilter == nil) {
        sharedFilter = [[super allocWithZone:NULL] init];
    }
    return sharedFilter;
}

- (id)init {
    // initial filter state
    self = [super init];
    self.filters = @[
                     @{
                         @"name": @"Most Popular",
                         @"options":
                             @[
                                 [@{@"name": @"Offering a Deal", @"selected": [NSNumber numberWithBool:NO]} mutableCopy]
                                 ],
                         @"expanded": [NSNumber numberWithBool:NO],
                         @"collapsed_size" : [NSNumber numberWithInt:1],
                    },
                     [@{
                        @"name": @"Distance",
                        @"options":
                            @[
                                @{@"name": @"Auto",      @"value": [NSNumber numberWithFloat:50000]},
                                @{@"name": @"0.3 miles", @"value": [NSNumber numberWithFloat:482]},
                                @{@"name": @"1 mile",    @"value": [NSNumber numberWithFloat:1609]},
                                @{@"name": @"5 miles",   @"value": [NSNumber numberWithFloat:8046]},
                                @{@"name": @"20 miles",  @"value": [NSNumber numberWithFloat:32186]}
                                ],
                        @"expanded": [NSNumber numberWithBool:NO],
                        @"collapsed_size" : [NSNumber numberWithInt:1],
                        @"selected": [NSNumber numberWithInt:0]
                        } mutableCopy],
                     [@{
                        @"name": @"Sort by",
                        @"options":
                            @[
                                @{@"name": @"Best Match",    @"value": [NSNumber numberWithInt:0]},
                                @{@"name": @"Distance",      @"value": [NSNumber numberWithInt:1]},
                                @{@"name": @"Rating",        @"value": [NSNumber numberWithInt:2]}
                                ],
                        @"expanded": [NSNumber numberWithBool:NO],
                        @"collapsed_size" : [NSNumber numberWithInt:1],
                        @"selected": [NSNumber numberWithInt:0]
                        } mutableCopy],
                     [@{
                         @"name": @"Categories",
                         @"options":
                             @[
                                 [@{@"name": @"American (New)",           @"value": @"newamerican",       @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"American (Traditional)",   @"value": @"tradamerican",      @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Argentine",                @"value": @"argentine",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Asian Fusion",             @"value": @"asianfusion",       @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Australian",               @"value": @"australian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Austrian",                 @"value": @"austrian",          @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Beer Garden",              @"value": @"beergarden",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Belgian",                  @"value": @"belgian",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Brazilian",                @"value": @"brazilian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Breakfast & Brunch",       @"value": @"breakfast_brunch",  @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Buffets",                  @"value": @"buffets",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Burgers",                  @"value": @"burgers",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Burmese",                  @"value": @"burmese",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Cafes",                    @"value": @"cafes",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Cajun/Creole",             @"value": @"cajun",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Canadian",                 @"value": @"newcanadian",       @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Chinese",                  @"value": @"chinese",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Cantonese",                @"value": @"cantonese",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Dim Sum",                  @"value": @"dimsum",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Cuban",                    @"value": @"cuban",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Diners",                   @"value": @"diners",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Dumplings",                @"value": @"dumplings",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Ethiopian",                @"value": @"ethiopian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Fast Food",                @"value": @"hotdogs",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"French",                   @"value": @"french",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"German",                   @"value": @"german",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Greek",                    @"value": @"greek",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Indian",                   @"value": @"indpak",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Indonesian",               @"value": @"indonesian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Irish",                    @"value": @"irish",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Italian",                  @"value": @"italian",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Japanese",                 @"value": @"japanese",          @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Jewish",                   @"value": @"jewish",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Korean",                   @"value": @"korean",            @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Venezuelan",               @"value": @"venezuelan",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Malaysian",                @"value": @"malaysian",         @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Pizza",                    @"value": @"pizza",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Russian",                  @"value": @"russian",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Salad",                    @"value": @"salad",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Scandinavian",             @"value": @"scandinavian",      @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Seafood",                  @"value": @"seafood",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Turkish",                  @"value": @"turkish",           @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Vegan",                    @"value": @"vegan",             @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Vegetarian",               @"value": @"vegetarian",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy],
                                 [@{@"name": @"Vietnamese",               @"value": @"vietnamese",        @"selected": [NSNumber numberWithBool:NO]} mutableCopy]
                                 ],
                         @"expanded": [NSNumber numberWithBool:NO],
                         @"collapsed_size" : [NSNumber numberWithInt:5],
                         } mutableCopy]
                     ];
    return self;
}


@end
