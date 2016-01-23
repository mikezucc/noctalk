//
//  ViewController.m
//  NocTalk
//
//  Created by Michael Zuccarino on 1/19/16.
//  Copyright © 2016 MemeTownUSA. All rights reserved.
//

#import "ViewController.h"
#import "RegisterFieldCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *registerTableView;

@property (strong, nonatomic) NSMutableArray *registerFieldsDataArray;
@property (strong, nonatomic) NSMutableDictionary *registerFieldInformation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.registerTableView registerNib:[UINib nibWithNibName:@"RegisterCell" bundle:nil] forCellReuseIdentifier:@"fieldCell"];
    [self.registerTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"doneCell"];
    
    self.registerFieldsDataArray = [NSMutableArray new];
    self.registerFieldInformation = [NSMutableDictionary new];
    
    self.registerFieldsDataArray = [[NSMutableArray alloc] initWithArray:@[
                                                                          @{
                                                                              @"section":@"Wave 1",@"fields":@[@{@"field":@"username",@"value":@""},@{@"field":@"areacode",@"value":@""}]
                                                                              },
                                                                          @{
                                                                              @"section":@"Wave 2",@"fields":@[@{@"field":@"tidbit",@"value":@""},@{@"field":@"gender",@"value":@""},@{@"field":@"age",@"value":@""},@{@"field":@"college",@"value":@""}]
                                                                              },
                                                                          @{
                                                                              @"section":@"Wave 3",@"fields":@[@{@"field":@"prezi",@"value":@""},@{@"field":@"prezi",@"value":@""}]
                                                                              },
                                                                          @{
                                                                              @"section":@"Wave 4",@"fields":@[@{@"field":@"twitter",@"value":@""},@{@"field":@"fb",@"value":@""},@{@"field":@"instag",@"value":@""},@{@"field":@"snapc",@"value":@""}]
                                                                              },
                                                                          @{
                                                                              @"section":@"Done",@"fields":@[@{@"field":@"twitter",@"value":@""}]
                                                                              }
                                                                          ]];
                                             
    /*
     <input type="text" class="button" id="nochandle" placeholder="meme_lorde" value="meme_lorde">
     <input type="text" class="button" id="areacode" placeholder="408" value="408">
     <p>Wave 2: Doctor's Details</p>
     <input type="text" class="button" id="tidbit" placeholder="I like to think in my room alone while listening to alternative rock because my stupid parents." value="I like to think in my room alone while listening to alternative rock because my stupid parents.">
     <input type="text" class="button" id="gender" placeholder="Male" value="Male">
     <input type="text" class="button" id="age" placeholder="21" value="21">
     <input type="text" class="button" id="college" placeholder="Uni of College USA" value="Uni of College USA">
     <p>Wave 3: Random trivia</p>
     <input type="text" class="button" id="prezi" placeholder="Trump" value="Trump">
     <P>Final Wave: Social handles</p>
     <input type="text" class="button" id="twitter" placeholder="@mikezuccarino" value="@mikezuccarino">
     <input type="text" class="button" id="fb" placeholder="https://www.facebook.com/zuccarino" value="https://www.facebook.com/zuccarino">
     <input type="text" class="button" id="instag" placeholder="@hempaw2" value="@hempaw2">
     <input type="text" class="button" id="snapc" placeholder="bootysnatcher22" value="bootysnatcher22">*/
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.registerFieldsDataArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.registerFieldsDataArray objectAtIndex:section] objectForKey:@"section"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.registerFieldsDataArray objectAtIndex:section] objectForKey:@"fields"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.registerFieldsDataArray objectAtIndex:indexPath.section] objectForKey:@"section"] isEqualToString:@"Done"])
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doneCell"];
        }
        cell.detailTextLabel.text = @"Done";
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.5 green:0.7 blue:0.9 alpha:1.0];
        return cell;
    }
    else
    {
        RegisterFieldCell *cell = (RegisterFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"fieldCell" forIndexPath:indexPath];
        
        if (!cell.inputField.delegate)
        {
            cell.inputField.delegate = self;
        }
        
        cell.section = indexPath.section;
        cell.row = indexPath.row;
        
        cell.inputField.placeholder = [[[[self.registerFieldsDataArray objectAtIndex:indexPath.section] objectForKey:@"fields"] objectAtIndex:indexPath.row] objectForKey:@"field"];
        
        return cell;
    }
    
    UITableViewCell *cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[RegisterFieldCell class]])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
