//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "YelpFilters.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

//- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//    NSDictionary *parameters = @{@"term": term,
//                                 @"location" : @"Castro",
//                                 @"cll" : @"37.759813,-122.441502",
//                                 @"limit": [NSNumber numberWithInt:20],
//
//                                 //    @"offset" :
//                                 };
//
//    return [self GET:@"search" parameters:parameters success:success failure:failure];
//}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term andFilters:(YelpFilters *)filters success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  
    //NSLog(@"%@", filters);
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *init_parameters = @{@"term": term,
                                 @"location" : @"Castro",
                                 @"cll" : @"37.759813,-122.441502",
                                 @"limit": [NSNumber numberWithInt:20],
                                 
                                 //    @"offset" :
                                 };

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:init_parameters];
    
    if (filters != nil) {
        // Add filter parameters
        for (NSDictionary *filter_dict in filters.filters) {
            NSString *name = filter_dict[@"name"];

            // MOST POPULAR
            if ([name  isEqual: @"Most Popular"]) {
                // Iterate most popular items adding to filters -- there's only one but
                // just for completeness...
                for (NSDictionary *mp_dict in [filter_dict objectForKey:@"options"]) {
                    NSString *mp_name = mp_dict[@"name"];
                    if ([mp_name isEqual:@"Offering a Deal"]) {
                        NSNumber *deal = [mp_dict objectForKey:@"selected"];
                        NSLog(@"Offering Deal: %s", [deal boolValue] ? "YES" : "NO");
                        [parameters setObject:deal forKey:@"deals_filter"];
                    }
                }
                
            // DISTANCE
            } else if ([name  isEqual: @"Distance"]) {
                NSNumber *distance = [[[filter_dict objectForKey:@"options"] objectAtIndex:
                                       [[filter_dict objectForKey:@"selected" ] intValue]] objectForKey:@"value"];
                
                NSLog(@"Distance: %@", distance);
                [parameters setObject:distance forKey:@"radius_filter"];

            // SORT BY
            } else if ([name  isEqual: @"Sort by"]) {
                NSNumber *sortby = [[[filter_dict objectForKey:@"options"] objectAtIndex:
                                       [[filter_dict objectForKey:@"selected" ] intValue]] objectForKey:@"value"];
                NSLog(@"Sort by (0=best,1=distance,2=rating): %@", sortby);
                [parameters setObject:sortby forKey:@"sort"];

            // CATEGORIES
            } else if ([name  isEqual: @"Categories"]) {
                NSMutableArray *selected_cats = [[NSMutableArray alloc] init];
                for (NSDictionary *cat_dict in [filter_dict objectForKey:@"options"]) {
                    if ([cat_dict[@"selected"] boolValue]) {
                        [selected_cats addObject:cat_dict[@"value"]];
                    }
                }
                NSString *categories = [selected_cats componentsJoinedByString:@","];
                NSLog(@"Categories: %@", categories);
                [parameters setObject:categories forKey:@"category_filter"];
            } else {
                NSLog(@"Unexpected filter value '%@'", name);
            }
            
//            NSLog(@"%@",[[[filter_dict objectForKey:@"options"] objectAtIndex:
//                          [[filter_dict objectForKey:@"selected" ] intValue]] objectForKey:@"value"]);
//            NSLog(@"%@", filter_dict[@"options"]);
//            NSLog(@"%@", filter_dict[@"selected"]);
        }
        
    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
