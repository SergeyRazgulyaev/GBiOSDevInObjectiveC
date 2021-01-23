//
//  NewsTextViewController.m
//  NewsObjCRSN
//
//  Created by Sergey Razgulyaev on 21.01.2021.
//

#import "NewsTextViewController.h"

@interface NewsTextViewController ()
@property (nonatomic, strong) NSString *newsText;
@property (nonatomic, strong) UITextView *newsTextView;
@end

@implementation NewsTextViewController
- (instancetype) initWithNewsText: (NSString *) newsText {
    self = [super init];
    if (self) {
        self.newsText = newsText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
    [self configureNewsTextView];
}

//MARK: - ViewController configuration Method
- (void) configureViewController {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:180.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.title = @"News text";
}

- (void) configureNewsTextView {
    self.newsTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, 93, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 93)];
    self.newsTextView.backgroundColor = [UIColor whiteColor];
    self.newsTextView.textColor = [UIColor blackColor];
    self.newsTextView.text = self.newsText;
    self.newsTextView.textAlignment = NSTextAlignmentCenter;
    self.newsTextView.font = [UIFont systemFontOfSize:25 weight:UIFontWeightRegular];
    [self.newsTextView setEditable:NO];
    [self.view addSubview:self.newsTextView];
}

@end
