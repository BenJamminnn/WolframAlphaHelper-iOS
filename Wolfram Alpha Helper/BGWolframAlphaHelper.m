//
//  BGWolframAlphaHelper.m
//  Wolfram Alpha Helper
//
//  Created by Mac Admin on 10/31/14.
//  Copyright (c) 2014 BG. All rights reserved.
//

#import "BGWolframAlphaHelper.h"
@import UIKit;

@interface BGWolframAlphaHelper()
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic, readwrite) NSMutableArray *images;
@end

@implementation BGWolframAlphaHelper

- (instancetype)initWithData:(NSData *)data {
    if(self = [super init]) {
        self.parser = [[NSXMLParser alloc]initWithData:data];
        self.parser.delegate = self;
        [self.parser parse];
        
    }
    return self;
}

#pragma mark - convieniece

- (UIImage *)imageFromURLString:(NSString *)url {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

- (NSMutableArray *)images {
    if(!_images) {
        _images = [NSMutableArray new];
    }
    return _images;
}

- (void)performActionWithElement:(NSString *)element attributes:(NSDictionary *)attributes {
    //All different types of data. As an example, we will take all images from WA
    
    if([element isEqualToString:@"plaintext"]) {
        NSLog(@"%@" , attributes);
    } else if([element isEqualToString:@"img"]) {
        NSString *imageURLString = [attributes valueForKey:@"src"];
        UIImage *image = [self imageFromURLString:imageURLString];
        [self.images addObject:image];
    } else if([element isEqualToString:@"source"]) {
        
    } else if([element isEqualToString:@"pod"]) {
        
    }
}

#pragma mark - XML Parser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //here is where parsing begins, we will initialize some data structure to hold all the necessary data
    NSLog(@"Parsing begins");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //here is where parsing ends, we'll send the info back to the caller
    NSLog(@"Parsing Ends");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //an error occurred, lets raise an exception if this happens
    NSLog(@"%@" , [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
    NSLog(@"element Name: %@" , elementName);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"Element Name: %@" , elementName);
    [self performActionWithElement:elementName attributes:attributeDict];
}

#pragma mark - making requests

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    //init a session config object
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //init a session object
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //create a data task object to perform the downloading
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            //if an error occurred, log it
            NSLog(@"%@" , [error localizedDescription]);
        } else {
            //no error occurred, check the HTTP status code
            NSInteger httpStatusCode = [(NSHTTPURLResponse *)response statusCode];
            //if its other than 200, log it
            if(httpStatusCode != 200) {
                NSLog(@"Http status code: %li" , (long)httpStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
        
    }];
    //makes the task start working for us
    [task resume];
}


@end
