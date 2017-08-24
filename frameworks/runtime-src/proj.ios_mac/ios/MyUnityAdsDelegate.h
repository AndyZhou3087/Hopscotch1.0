//
//  ViewController.h
//  testunityads
//
//  Created by Hailin Rao on 2016/12/6.
//  Copyright © 2016年 Hailin Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VungleSDK/VungleSDK.h>
//@import GoogleMobileAds;

//NSDictionary * _dict;

@interface MyUnityAdsDelegate : NSObject <VungleSDKDelegate>
{
    VungleSDK * vungleSdk;
//    NSString * appKey;
//    NSString * ChannelId;
}

- (void)initUMAds;
- (void)initVungleAds;
- (void)showVungleViedo:(NSDictionary *)dict;
- (void)umentOnEvent:(NSDictionary *)dict;
- (void)umentOnEventEx:(NSDictionary *)dict;

@end

