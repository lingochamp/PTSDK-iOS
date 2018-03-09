//
//  PTTokenProviding.h
//  PTSDK
//
//  Created by Chun on 02/02/2018.
//  Copyright © 2018 LLS iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This protocol defined that fetching pt token
 */
@protocol PTTokenProviding <NSObject>


/**
 fetch token method

 @param completionHandler if get token failed, please set error to the block param. Make that completionHandle must be called at main thread.
 */
- (void)fetchTokenWithCompletionHandler:(nonnull void (^)(NSString * _Nullable token, NSError * _Nullable error))completionHandler;


/**
 tell the provider that need to set cache token to invalid

 @param token token that PTSDK hold.
 */
- (void)invalidToken:(nonnull NSString *)token;

@end
