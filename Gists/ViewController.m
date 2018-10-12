//
//  ViewController.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Github.h"
#import "Gist.h"
#import "File.h"
#import "FileContentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CameraViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, GithubDelegate, CameraDelegate>
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.github = appDelegate.github;
    self.github.delegate = self;
}

- (UIViewController *)viewControllerForShowingGithubInterfaces
{
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCamera"]){
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;
        CameraViewController *viewController = (CameraViewController *) navigationController.topViewController;
        viewController.delegate = self;
    }
}

- (void)cameraFoundURL:(NSURL *)URL
{
    // Long body: https://gist.github.com/simonmaddox/bc7c4f08399eed514e4821c4b52bd792
    // Lots of comments: https://gist.github.com/asweigart/6912168
    // Multiple files: https://gist.github.com/mattboldt/7621795

    __weak typeof(self) weakSelf = self;
    [self.github fetchGistWithURL:URL completion:^(Gist * _Nonnull gist, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.currentGist = gist;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.title = gist.title;
            [strongSelf.navigationController setToolbarHidden:NO animated:YES];
            [strongSelf.tableView reloadData];
        }];
    }];
}

- (IBAction)replyPressed:(id)sender
{
    // TODO: In a complete application, we could present some custom UI for taking user input. For now, we'll just show an alert with a text field.
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Post Comment", @"Post Comment alert title") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Post Comment", @"Post Comment alert continue button title") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.github postComment:[[alert.textFields firstObject] text] toGist:strongSelf.currentGist completion:^(NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.tableView reloadData];
            }];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Post Comment alert cancel button title") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView


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
        return NSLocalizedString(@"Files", @"Files section title");
    } else if (section == 1){
        return NSLocalizedString(@"Comments", @"Comments section title");
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
