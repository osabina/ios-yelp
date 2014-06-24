//
//  FilterViewController.h
//  Yelp
//
//  Created by Osvaldo Sabina on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end
