//
//  XCDYouTubeSignature.m
//  XCDYouTubeKit
//
//  Created by thongvm on 11/8/18.
//  Copyright © 2018 Cédric Luthi. All rights reserved.
//

#import "XCDYouTubeSignature.h"
@interface XCDYouTubeSignature ()
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSArray<NSString*> *patterns;
@end

@implementation XCDYouTubeSignature
//init
+(instancetype)shared {
	static XCDYouTubeSignature *_instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[XCDYouTubeSignature alloc] init];
	});
	return _instance;
}

// make request
-(void)makeRequest:(SignatureRequst)complete {
	if (self.signature && self.patterns) {
		complete(self.signature, self.patterns);
		return;
	}
	__weak typeof(self)wSelf = self;
	NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration  defaultSessionConfiguration];
	NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject];
	NSURL *url = [NSURL URLWithString:@"https://api.topapps.io/player/"];
	NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
													completionHandler:^(NSData *data,  NSURLResponse *response, NSError *error) {
														if(error == nil)
														{
															NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
															if (error) {
																NSLog(@"Parse json is invalid: %@",error.localizedDescription);
															}else {
																// check condition
																
																NSDictionary *signature = [json valueForKey:@"signature"]; //json[@"signature"];
																NSArray *obj = [json valueForKey:@"patterns"];//json[@"patterns"];
																
																obj = (obj == nil || ![obj isKindOfClass:[NSArray class]]) ? @[] : obj;
																
																// assign global variable
																wSelf.signature = [signature valueForKey:@"name"];
																
																NSMutableArray *patterns = [NSMutableArray array];
																for (NSDictionary *pattern in obj) {
																	NSString *string =  [pattern valueForKey:@"string"];
																	if (string != nil) {
																		[patterns addObject:string];
																	}
																}
																wSelf.patterns = patterns;
																complete(wSelf.signature, wSelf.patterns);
															}
														}else {
															complete(nil, nil);
														}
													}];
	[dataTask resume];

}


@end
