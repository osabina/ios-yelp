//
//  FilterViewController.m
//  Yelp
//
//  Created by Osvaldo Sabina on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "YelpFilters.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FilterViewController ()

@property (strong,nonatomic) YelpFilters *yf;

-(void)pushSearchButton;
-(void)pushCancelButton;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.yf = [YelpFilters getOrInitFilters];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *searchButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(pushSearchButton)];
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(pushCancelButton)];

    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = searchButton;

    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    // NSLog(@"section: %d, row %d", indexPath.section, indexPath.row);
    NSDictionary *filter = self.yf.filters[indexPath.section];
    NSDictionary *row = filter[@"options"][indexPath.row];
    
    UIImageView *dropDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropDown"]];
    UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckMark"]];

    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];


    // This feels pretty hacky hardcoding the UI elements, but...oh well
    
    // Most Popular section - all switches (well only one implemented)
    if ([filter[@"name"] isEqualToString: @"Most Popular"]) {
            cell.textLabel.text = row[@"name"];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = switchView;
            [switchView setTintColor:UIColorFromRGB(0xc8c8c8)];
            [switchView setOnTintColor:UIColorFromRGB(0xb23512)];
            [switchView setTag:indexPath.row];
            [switchView setOn:[row[@"selected"] boolValue] animated:NO];
            [switchView addTarget:self action:@selector(handleMostPopularSwitch:) forControlEvents:UIControlEventValueChanged];

    // The "single select" expandable sections
    } else if ([filter[@"name"] isEqualToString: @"Distance"] ||
               [filter[@"name"] isEqualToString: @"Sort by"]) {
        int selected = [filter[@"selected"] intValue];
        cell.textLabel.text = row[@"name"];
        if ([filter[@"expanded"] boolValue] == NO) {
            cell.accessoryView = dropDown;
            cell.textLabel.text = filter[@"options"][selected][@"name"];
        } else if (selected == indexPath.row) {
            cell.accessoryView = checkMark;
       }

     // The "multi select" expandable sections
    } else if ([filter[@"name"] isEqualToString:@"Categories"]) {
        if (indexPath.row == ([filter[@"collapsed_size"] intValue] - 1)  && [filter[@"expanded"] boolValue] == NO) {
            // We are in collapsed state, and in last row
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = UIColorFromRGB(0xc8c8c8);
            cell.textLabel.text = @"See All";
        } else {
            // Otherwise, just another cell.
            cell.textLabel.text = row[@"name"];
            if ([self.yf isSelectedRow:indexPath.row withSection:indexPath.section]) {
                cell.accessoryView = checkMark;
            }
        }
    } else {
      cell.textLabel.text = @"Unknown section detected....oops";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    //NSLog(@"did select: section %d, row %d", section, row);
    
    NSDictionary *filter = self.yf.filters[section];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex: section];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Most Popular is a noop
    
    // Distance and Sort by handled identically
    if ([filter[@"name"] isEqualToString:@"Distance"] ||
        [filter[@"name"] isEqualToString:@"Sort by"] ) {
        if ([self.yf sectionExpanded:section]) {
            self.yf.filters[section][@"selected"] = [NSNumber numberWithInt:row];
        }
        [self.yf toggleSectionExpanded:section];
        //NSLog(@"toggleExpand");
    // Categories/Cuisine are a multi-select
    } else if ([filter[@"name"] isEqualToString:@"Categories"]) {
        //NSLog(@"row = %d, collapsed_size = %d", row, [filter[@"collapsed_size"] intValue]);
        if (! [self.yf sectionExpanded:section] && row == ([filter[@"collapsed_size"] intValue] - 1 ) ) {
            NSLog(@"toggleExpand");
            [self.yf toggleSectionExpanded:section];
        } else {
            [self.yf toggleSelectionRow:row withSection:section];
        }
        
    }
    
    [self.filterTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@", self.yf.filters[section]);
    if ([self.yf sectionExpanded: section]) {
        return [self.yf.filters[section][@"options"] count];
    } else {
        return [[self.yf.filters[section] valueForKeyPath: @"collapsed_size"] intValue];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.yf.filters count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.yf.filters[section][@"name"];
}



-(void)pushSearchButton {
    [self.delegate addFilters:self didFinishEnteringFilters:self.yf];
}

-(void)pushCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleMostPopularSwitch:(id)sender {

    //hacky, needs refactoring...
    NSLog(@"handle most popular, tag: %d", ((UISwitch *)sender).tag);
    
    NSDictionary *filter = self.yf.filters[0];
    NSMutableDictionary *option = filter[@"options"][(int)((UISwitch *)sender).tag];
    if ([option[@"selected"] boolValue] == YES) {
        [option setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    else {
        [option setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
    }
    NSLog(@"option: %@", option);
}
@end
