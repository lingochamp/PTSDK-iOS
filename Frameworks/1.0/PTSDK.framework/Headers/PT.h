//
//  PT.h
//  PTSDK
//
//  Created by Chun on 30/01/2018.
//  Copyright © 2018 LLS iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PTTokenProviding.h"

// MARK: - PT

typedef NS_ENUM(NSInteger, PTSDKErrorCode) {
  PTSDKInternalError = 101,
  PTSDKErrorMicroPhonePermissionDenied = 102,
  PTSDKErrorMissingPTTokenProviding = 103,
  PTSDKErrorTokenFetchFailed = 104
};

/**
 PTSDK complete block defined

 @param responseObject responseObject is returned by PTSDK. A full responseObject (it's a dictionary type) like below:
 ```
 {
   fluency = Poor;
   fluencyAsPercentage = 0;
   level = 4;
   levelDescription = "\U4e2d\U4f4e\U7ea7";
   levelName = 4;
   message = ok;
   nextActionName = "";
   nextActionUrl = "";
   pronunciation = Poor;
   pronunciationAsPercentage = 0;
   score = 97;
   summary = "";
 }
 ```
 @param error About this error's code, you can check `PTSDKErrorCode`
 */
typedef void (^PTCompletionHandler)(id _Nullable responseObject, NSError * _Nullable error);

@interface PT : NSObject

/**
 start PTSDK.
 When you need to start PTSDK, you should get user's microphone permission.
 If `recordPermission != AVAudioSessionRecordPermissionGranted`, start PTSDK will failed;
 BTW, remember to set `Privacy - Microphone Usage Description` on Info.plist.
 
 And when you used PTSKD, you also need to open `Project Capabilities - Background Modes - Audio`.

 @param userIdentifier user identifier, PTSDK use this identifier to determine the same user. Normally, you can pass current user Id.
 @param provider get token provider, ptSDK will retain this provider and use this provider for fetching token.
 @param navigationController PTSDK will use this navigationController for push.
 @param completionHandler PT Result completeHandleBlock, If user finishes pt, responseObject will returned. If no pt result get, error will returned. About this error's code, you can check `PTSDKErrorCode`.
 */
+ (void)startWithUserIdentifier:(nonnull NSString *)userIdentifier
                  tokenProvider:(nonnull id <PTTokenProviding>)provider
      fromNavigationController:(nonnull UINavigationController *)navigationController
             completionHandler:(nullable PTCompletionHandler)completionHandler;

/**
 Enable debug mode will print log to console & temp log file.
 
 @param enabled enable log file or not.
 */
+ (void)setDebugMode:(BOOL)enabled;

/**
 Export debug log file. You can provide log file to SDK developer for help.
 
 @param completion will call completion on background thread when error occoured or log file generated.
 */
+ (void)exportDebugLog:(void (^_Nonnull) (NSError *_Nullable error, NSURL *_Nullable logURL))completion;

/**
 Get current PTSDK version

 @return example: "[PTSDK] Version: 1.0"
 */
+ (nonnull NSString *)frameworkVersion;

@end
