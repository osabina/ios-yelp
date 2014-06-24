//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

#import "MainViewController.h"
#import "YelpClient.h"

#import "FilterViewController.h"
#import "YelpCell.h"

NSString * const kYelpConsumerKey = @"mbCYBWrsj76OXlzToGAMpw";
NSString * const kYelpConsumerSecret = @"UPnEFT3TCwHsDCF1MmcYOwQcE5Y";
NSString * const kYelpToken = @"3ua_uCQNU_97n2Z6NVNYm3p8uwract_A";
NSString * const kYelpTokenSecret = @"zgeQURodtyrv7YzcKplgT5X-Yaw";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;

@property (strong, nonatomic) NSArray *businesses;

-(void)loadData;
-(void)pushFilterButton;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"YelpCell" bundle:nil] forCellReuseIdentifier:@"YelpCell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // static, for now
    self.tableView.rowHeight = 110;
    
    UISearchBar *searchBar = [[UISearchBar alloc]
                              initWithFrame:CGRectMake(0, 0, 200, 30)];

    // stub
    id barButtonAppearance = [UIBarButtonItem appearance];
    NSMutableDictionary *barButtonTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [barButtonTextAttributes setObject:[UIFont fontWithName:@"HelveticaNeue" size:14.0f] forKey:NSFontAttributeName];
    [barButtonTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName ];
    
    [barButtonAppearance setTitleTextAttributes:barButtonTextAttributes
                                       forState:UIControlStateNormal];
    [barButtonAppearance setTitleTextAttributes:barButtonTextAttributes
                                       forState:UIControlStateHighlighted];
    
    
//    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [filterButton addTarget:self
//               action:@selector(pushFilterButton)
//     forControlEvents:UIControlEventTouchUpInside];
//    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
//    filterButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
//    [view addSubview:button];
    
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]
                            initWithTitle:@"Filter" style: UIBarButtonItemStyleBordered
                            target:self
                            action:@selector(pushFilterButton)];
    
    
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = filterButton;
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.businesses.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell for row at index path: %d", indexPath.row);
    YelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpCell"];
   //NSLog(@"BU: %@", self.businesses);

    NSDictionary *business = self.businesses[indexPath.row];
    NSLog(@"business: %@", business);
    
    // Name
    cell.placeLabel.text = [NSString stringWithFormat:@"%d. %@", (int) indexPath.row + 1,
                            business[@"name"]];
    [cell.placeLabel sizeToFit];

    // Review Count
    cell.reviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews",
                              business[@"review_count"]];

    // Address
    NSDictionary *location = [[NSDictionary alloc]
                              initWithDictionary: business[@"location"]];

    // NSLog(@"%@", location);
    NSArray *displayAddress = [[NSArray alloc]
                               initWithObjects: location[@"display_address"][0],
                                location[@"display_address"][1], nil];

    NSString *address = [displayAddress componentsJoinedByString:@", "];
    //NSLog(@"%@", address);
    cell.addressLabel.text = address;

    // Cuisine
    NSMutableArray *cuisineArray = [[NSMutableArray alloc] init];
    for (id categoryArray in business[@"categories"]) {
        [cuisineArray addObject:categoryArray[0]];
    }
    NSString *cuisine = [cuisineArray componentsJoinedByString:@", "];
    cell.cuisineLabel.text = cuisine;
    
    // Ratings Image
    [cell.starsImage setImageWithURL:[NSURL URLWithString:business[@"rating_img_url"]]];
    
    // Place image
    [cell.placeImage.layer setMasksToBounds:YES];
    [cell.placeImage.layer setCornerRadius:10.0f];
    [cell.placeImage setAlpha:0.0f];
    [cell.placeImage setImageWithURL:[NSURL URLWithString:business[@"image_url"]]];
    [UIImageView animateWithDuration:2.0 animations:^{
         cell.placeImage.alpha = 1.0;
    }];

    // Distance (stub)
    cell.distanceLabel.text = @"1.7 mi";
    
    // Cost (stub)
    cell.costLabel.text = @"$$$";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Here we would push the detail view controller
    // DetailsViewController *dvc = [[DetailsViewController alloc] init];
    // dvc.movie = self.movies[indexPath.row];
    //
    // [self.navigationController pushViewController:dvc animated:YES];
}

// This is I think how we would make the cell height variable
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}


- (void)loadData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
  //      NSLog(@"response: %@", response);
        self.businesses = response[@"businesses"];
        [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)pushFilterButton {
    FilterViewController *fvc = [[FilterViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}



@end
