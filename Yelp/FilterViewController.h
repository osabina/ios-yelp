//
//  FilterViewController.h
//  Yelp
//
//  Created by Osvaldo Sabina on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpFilters.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>
- (void)addFilters:(FilterViewController *)controller didFinishEnteringFilters:(YelpFilters *)filters;
@end

@interface FilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@property (nonatomic,weak) id <FilterViewControllerDelegate> delegate;

@end
