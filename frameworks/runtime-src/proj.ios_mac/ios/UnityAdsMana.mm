//
//  ViewController.m
//  testunityads
//
//  Created by Hailin Rao on 2016/12/6.
//  Copyright © 2016年 Hailin Rao. All rights reserved.
//

#include "MyUnityAdsDelegate.h"
#import "UnityAdsMana.h"
#import "CCLuaBridge.h"
#import "CCLuaEngine.h"

MyUnityAdsDelegate * ads;
@implementation UnityAdsMana


+ (void)initVungleSdk:(NSDictionary *)dict {
    
    ads = [MyUnityAdsDelegate alloc];
    [ads init];
    [ads initVungleAds];
    NSLog(@"initVungleSdk success!");
}

+ (IBAction)showVungleAds:(NSDictionary *)dict {
    
        NSLog(@"ViewInfo Dictionary:oooooooooooo");
    [ads showVungleViedo:dict];
    
}

@end
