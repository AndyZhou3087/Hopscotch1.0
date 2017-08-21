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
}

- (void)initVungleAds;
- (void)showVungleViedo:(NSDictionary *)dict;

@end

