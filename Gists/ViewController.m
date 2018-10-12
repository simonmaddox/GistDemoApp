//
//  ViewController.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Github.h"
#import "Gist.h"
#import "File.h"
#import "FileContentTableViewCell.h"
#import "CommentTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Github *github;
@property (nonatomic, strong) Gist *currentGist;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FileContentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FileContentTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommentTableViewCell class])];
    
    self.navigationController.toolbarHidden = YES;
    self.github = [[Github alloc] init];
}

- (IBAction)showCameraPressed:(id)sender
{
    // Long body: https://gist.github.com/simonmaddox/bc7c4f08399eed514e4821c4b52bd792
    // Lots of comments: https://gist.github.com/asweigart/6912168

    [self cameraScannedURL:[NSURL URLWithString:@"https://gist.github.com/asweigart/6912168/"]];
}

- (void)cameraScannedURL:(NSURL *)URL
{
    __weak typeof(self) weakSelf = self;
    [self.github fetchGistWithURL:URL completion:^(Gist * _Nonnull gist, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentGist = gist;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController setToolbarHidden:NO animated:YES];
            [strongSelf.tableView reloadData];
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentGist){
        // File, Comments
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return [self.currentGist.files count];
    } else if (section == 1) {
        return [self.currentGist.comments count];
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Files";
    } else if (section == 1){
        return @"Comments";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        FileContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FileContentTableViewCell class]) forIndexPath:indexPath];
            cell.file = self.currentGist.files[indexPath.row];
            return cell;
    } else if (indexPath.section == 1){
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentTableViewCell class]) forIndexPath:indexPath];
        cell.comment = self.currentGist.comments[indexPath.row];
        return cell;
    }
    return nil;
}

@end
