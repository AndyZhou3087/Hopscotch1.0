//
//  ViewController.h
//  testunityads
//
//  Created by Hailin Rao on 2016/12/6.
//  Copyright © 2016年 Hailin Rao. All rights reserved.
//

//NSDictionary * _dict;

@interface UnityAdsMana : NSObject
{
    
}

+ (void)initVungleSdk:(NSDictionary*)dict;
+ (IBAction)showVungleAds:(NSDictionary*)dict;
+ (IBAction)umentOnEvent:(NSDictionary*)dict;
+ (IBAction)umentOnEventEx:(NSDictionary*)dict;
+ (IBAction)favourableComment:(NSDictionary*)dict;
+ (IBAction)favourableCommentAlert:(NSDictionary*)dict;

@end

