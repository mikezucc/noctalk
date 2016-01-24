//
//  WhoisViewController.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/23/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "WhoisViewController.h"
#import "WhoisCell.h"

@interface WhoisViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *usersOnline;

@property (strong, nonatomic) UITapGestureRecognizer *titleTapGest;

@end

@implementation WhoisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usersOnline = [NSMutableArray new];
    
    [self.whoisTableView registerNib:[UINib nibWithNibName:@"WhoisCell" bundle:nil] forCellReuseIdentifier:@"whoisCell"];
    
    self.titleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTitle)];
    [self.titleTapGest setNumberOfTapsRequired:1.0];
    [self.titleTapGest setNumberOfTouchesRequired:1.0];
    [self.titleVisualView addGestureRecognizer:self.titleTapGest];
}

-(void)viewDidAppear:(BOOL)animated {
    for (int i=0; i < 4; i++)
    {
        User *aUs = [User withName:[NSString stringWithFormat:@"Meme Lorde %d",i] fullname:@"John" profileHash:@"" areacode:@""];
        [self.usersOnline addObject:aUs];
    }
    [self.whoisTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersOnline.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WhoisCell *cell = (WhoisCell *)[tableView dequeueReusableCellWithIdentifier:@"whoisCell" forIndexPath:indexPath];
    
    [cell.whoisImageView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:1.0]];
    cell.whoisNameLabel.text = ((User *)[self.usersOnline objectAtIndex:indexPath.row]).username;
    
    return cell;
}

#pragma mark - responsies

-(void)tappedTitle {
    NSLog(@"%s",__FUNCTION__);
}

@end
