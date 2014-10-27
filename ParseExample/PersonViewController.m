//
//  ViewController.m
//  ParseExample
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "PersonViewController.h"
#import <Parse/Parse.h>

@interface PersonViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *people;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddPersonButtonTapped:(UIBarButtonItem *)sender {
    PFObject *person = [PFObject objectWithClassName:@"Person"];

    person[@"name"] = @"Johnny Appleseed";
    person[@"age"] = @22;   // == [NSNumber numberWithInt:22];
    person[@"occupation"] = @"Appleseeder";

    [person saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
        }else{
            [self refreshDisplay];
        }
    }];

}

-(void)refreshDisplay{
    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
            self.people = [NSArray array];
        }else {
            self.people = objects;
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.people.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    PFObject *person = [self.people objectAtIndex:indexPath.row];
    cell.textLabel.text = person[@"name"];

    return cell;
}

@end
