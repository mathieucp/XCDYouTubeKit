//
//  XCDYouTubeSignature.h
//  XCDYouTubeKit
//
//  Created by thongvm on 11/8/18.
//  Copyright © 2018 Cédric Luthi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SignatureRequst) (NSString* signature, NSArray <NSString*> *patterns);

NS_ASSUME_NONNULL_BEGIN

@interface XCDYouTubeSignature : NSObject
+(instancetype)shared;
-(void)makeRequest:(SignatureRequst)complete;
@end

NS_ASSUME_NONNULL_END
