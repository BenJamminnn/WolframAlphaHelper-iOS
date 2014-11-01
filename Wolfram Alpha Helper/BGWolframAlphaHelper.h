//
//  BGWolframAlphaHelper.h
//  Wolfram Alpha Helper
//
//  Created by Mac Admin on 10/31/14.
//  Copyright (c) 2014 BG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQueryURL @"http://api.wolframalpha.com/v2/query?"
#define kAppID @"YOUR_APP_ID"
#warning set your own app id here.


@interface BGWolframAlphaHelper : NSObject <NSXMLParserDelegate>

- (NSArray *)imagesFromHelper;

- (instancetype)initWithData:(NSData *)data;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

@end
