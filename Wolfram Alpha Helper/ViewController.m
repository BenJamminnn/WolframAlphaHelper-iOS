//
//  ViewController.m
//  Wolfram Alpha Helper
//
//  Created by Mac Admin on 10/31/14.
//  Copyright (c) 2014 BG. All rights reserved.
//

#import "ViewController.h"
#import "BGWolframAlphaHelper.h"

@interface ViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation ViewController


//Simple usage of the WA xml parsing. Grabbing the images from the WAHelper and displaying them.


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollView];
    
    //example of pi
    NSString *queryExample = @"pi";
    NSString *urlString = [NSString stringWithFormat:@"%@appid=%@&input=%@" , kQueryURL , kAppID , queryExample];
    [self makeRequestWithQuery:[NSURL URLWithString:urlString]];
}

- (void)makeRequestWithQuery:(NSURL *)query {
    [BGWolframAlphaHelper downloadDataFromURL:query withCompletionHandler:^(NSData *data) {
        if(data) {
            BGWolframAlphaHelper *helper = [[BGWolframAlphaHelper alloc]initWithData:data];
            [self displayImages:helper.images];
            
        } else {
            NSLog(@"data is nil");
        }
    }];
}

#pragma mark - convienience

- (void)displayImages:(NSArray *)images {
    CGFloat height = 20;
    for(UIImage *img in images) {
        CGRect rect = CGRectMake(self.view.frame.size.width/2, height ,100, 100);
        height += 100;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.image = [self imageWithImage:img scaledToSize:CGSizeMake(150, 30)];
        imageView.contentMode = UIViewContentModeCenter;
        
        [self.scrollView addSubview:imageView];
    }
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 560, 10000)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 70);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
}

//shout out to Brad Larson on SO
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
