//
//  NewsViewController.m
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 21.01.2021.
//

#import "NewsViewController.h"
#import "NewsTextViewController.h"
#import "APIManager.h"
#import "News.h"
#import "Source.h"

#define reuseCellIdentifier @"CellIdentifier"

@interface NewsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *newsArray;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
    [self configureTableView];
    [[APIManager sharedInstance] allNewsWithCompletion:^(NSArray *allNews) {
        if (allNews.count > 0) {
            self.newsArray = allNews;
            [self.tableView reloadData];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ups!" message:@"There is no News" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

//MARK: - ViewController configuration Method
- (void) configureViewController {
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"News";
}

//MARK: - TableView
- (void) configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [(News *)[self.newsArray objectAtIndex:indexPath.row] title];
    
    Source *source = [(News *)[self.newsArray objectAtIndex:indexPath.row] source];
    NSString *nameOfSource = [(Source *)source valueForKey:@"name"];
    NSString *nameOfAuthor = [(News *)[self.newsArray objectAtIndex:indexPath.row] author];

    if ([nameOfAuthor isKindOfClass:[NSNull class]] || [nameOfAuthor isEqual: @""]) {
        cell.detailTextLabel.text = nameOfSource;
    } else {
        cell.detailTextLabel.text = [[nameOfSource stringByAppendingString:@", author: "] stringByAppendingString: nameOfAuthor];
    }

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *newsText = [(News *)[self.newsArray objectAtIndex:indexPath.row] content];
    if ([newsText isKindOfClass:[NSNull class]]) {
        NewsTextViewController *newsTextViewController = [[NewsTextViewController alloc] initWithNewsText: @"No News Content"];
        [self.navigationController showViewController:newsTextViewController sender:self];
    } else {
        NewsTextViewController *newsTextViewController = [[NewsTextViewController alloc] initWithNewsText: newsText];
        [self.navigationController showViewController:newsTextViewController sender:self];
    }
}

@end
