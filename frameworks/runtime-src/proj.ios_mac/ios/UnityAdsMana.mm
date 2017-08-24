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
    [ads initUMAds];
    NSLog(@"initVungleSdk success!");
}

+ (IBAction)showVungleAds:(NSDictionary *)dict {
    
        NSLog(@"ViewInfo Dictionary:oooooooooooo");
    [ads showVungleViedo:dict];
    
}

+ (IBAction)umentOnEvent:(NSDictionary*)dict{
    NSLog(@"umentOnEvent:111111111");
    [ads umentOnEvent:dict];
}

+ (IBAction)umentOnEventEx:(NSDictionary*)dict{
    NSLog(@"umentOnEventEXXXXXXX:222222");
    [ads umentOnEventEx:dict];
}

@end
