//
//  ViewController.m
//  testunityads
//
//  Created by Hailin Rao on 2016/12/6.
//  Copyright © 2016年 Hailin Rao. All rights reserved.
//

#import "MyUnityAdsDelegate.h"
#import "CCLuaBridge.h"
#import "CCLuaEngine.h"
#import "UMMobClick/MobClick.h"
#import "TyrantdbGameTracker.h"

static NSString *const kVungleTestPlacementID01 = @"DEFAULT38143";

static int _dict;

@interface MyUnityAdsDelegate ()

@end

@implementation MyUnityAdsDelegate

//===========TapDB==============
- (void)initTapDB {
    NSString * appId = @"mjg870r06sdvzvg4";
    [TyrantdbGameTracker onStart:appId channel:nil version:nil];
    NSLog(@"initTapDB success!");
}


//===========UM SDK==============
- (void)initUMAds {
    UMConfigInstance.appKey = @"599e832e2ae85b19b1001a82";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_GAME; // 仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];
    NSLog(@"initUMSdk success!");
}

- (void)umentOnEvent:(NSDictionary *)dict {
    NSString * eventId;
    NSString * rid;
    for(NSString * key in [dict allKeys]) {
        NSLog(@"UM event ------%@ : %@", key, [[dict objectForKey:key] description]);
        if ([key  isEqual: @"eventId"]) {
            eventId = [[dict objectForKey:key] description];
        }
        if ([key  isEqual: @"id"]) {
            rid = [[dict objectForKey:key] description];
        }
    }
    
    [MobClick event:eventId label:rid];
    
}

- (void)umentOnEventEx:(NSDictionary *)dict{
    NSString * eventId = [[dict objectForKey:@"eventId"] description];
    NSLog(@"UM event ------eventId : %@", eventId);
    [MobClick event:eventId];
}

//===========Vungle Sdk===========
- (void)initVungleAds {
    NSError* error = nil;
    NSString * appID = @"599ab10db574f31f6900852f";
    NSArray* placementIDsArray = [NSArray arrayWithObjects:kVungleTestPlacementID01, nil];
    vungleSdk = [VungleSDK sharedSDK];
//    [vungleSdk setLoggingEnabled:YES];
    [vungleSdk startWithAppId:appID];
}

- (void)showVungleViedo:(NSDictionary *)dict {
    
    _dict =(int)[[dict objectForKey:@"callback"] intValue];
    
    for(NSString * key in [dict allKeys]) {
        NSLog(@"aaa11111111111------%@ : %@", key, [[dict objectForKey:key] description]);
    }
    
    [vungleSdk setDelegate:self];
    [vungleSdk setLoggingEnabled:false];
    if ([vungleSdk isAdPlayable]) {
        NSError * error;
        UIViewController * s = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        NSDictionary * options = @{VunglePlayAdOptionKeyIncentivized:@true};
        [vungleSdk playAd:s withOptions:options error:&error];
    }
}

//- (void)vungleSDKDidInitialize {
//    NSLog(@"aaaAn vungleSDKDidInitialize");
//}

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable {
    if (isAdPlayable) {
        NSLog(@"aaaAn ad is available for playback");
    } else {
        NSLog(@"aaaNo ads currently available for playback");
    }
}

- (void)vungleSDKwillShowAd {
    NSLog(@"aaaAn ad is about to be played!");
    //Use this delegate method to pause animations, sound, etc.
}

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet {
    NSLog(@"ViewInfo Dictionary:");
    // viewInfo dictioanry contains completedView, playTime and didDownload information
    // willPresentProductSheet always returns NO
    for(NSString * key in [viewInfo allKeys]) {
        NSLog(@"aaa%@ : %@", key, [[viewInfo objectForKey:key] description]);
    }
    NSNumber * isCompleted = [viewInfo objectForKey:@"completedView"];
    int value = [isCompleted intValue];
    if (value == 1) {
        
        [self didAfterCompleted:_dict];
    }
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet {
    NSLog(@"aaaThe user has downloaded an advertised application and is now returning to the main app");
    //This method can be used to resume animations, sound, etc. if a user was presented a product sheet earlier
}

//五星好评
- (void)favourableComment{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1243387739"]];
}

//好评弹框
- (void)favourableCommentAlert:(NSDictionary *)dict{
    int value =(int)[[dict objectForKey:@"callback"] intValue];
    
    NSLog(@"lua call favourableCommentAlert succeed");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1243387739"]];
    
    [self commentCompleted:value result:@"Comment"];
    
    
//    UIViewController * s = [[UIViewController alloc] init];//[[[UIApplication sharedApplication] keyWindow] rootViewController];
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"帮个忙吧！" message:@"给个好评吧！" preferredStyle:UIAlertControllerStyleAlert];
//    alert.popoverPresentationController.barButtonItem = s.navigationItem.leftBarButtonItem;
//    UIAlertAction * ac = [UIAlertAction actionWithTitle:@"好说好说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1243387739"]];
//        
//        [self commentCompleted:value result:@"Comment"];
//    }];
//    //[ac setValue:[UIColor greenColor] forKey:@"_titleTextColor"];
//    [alert addAction:ac];
//    [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    UIAlertAction * ac3 = [UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        //[self commentCompleted:value result:@"Refuse"];
//    }];
//    [alert addAction:ac3];
//    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.3)
//        [ac3 setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
//    
//    //[[[UIApplication shareApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
//    
//    [[[UIApplication sharedApplication] keyWindow].rootViewController addChildViewController:s];
//    
//    [s presentViewController:alert animated:YES completion:nil];
}


- (void)commentCompleted:(int)handlerID result:(NSString*)result {
    NSLog(@"lua call ocFounction commentCompleted succeed");

    cocos2d::LuaBridge::pushLuaFunctionById(handlerID); //压入需要调用的方法id
    cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();  //获取lua栈
    //转换char*
    stack->pushString([result UTF8String]);  //将需要传递给lua层的参数通过栈传递
    stack->executeFunction(1);  //共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
    cocos2d::LuaBridge::releaseLuaFunctionById(handlerID); //最后记得释放
}


/*adsWhereRevive = 0,
adsSuccess,1
adsRemoveAds,2
adsDailyAds,3
adsOverAddTime,4
adsStartChooseProp,5
adsShop,6
adsBuyLife 7*/

- (void)didAfterCompleted:(int)handlerID{
    NSLog(@"lua call ocFounction succeed");
    //这里获取lua层的数据后  对数据进行操作（例如调用支付宝接口等） 将返回的数据再通过下面的方法回传给lua层
    
//    int handlerID = (int)[[dict objectForKey:@"callBack"] intValue];  //lua传输过来的回调lua的方法名inergerValue    这里可以将该id缓存在oc层的一个全局变量中  在合适的位置再回调lua层
    cocos2d::LuaBridge::pushLuaFunctionById(handlerID); //压入需要调用的方法id
    cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();  //获取lua栈
    stack->pushString("success");  //将需要传递给lua层的参数通过栈传递
    stack->executeFunction(1);  //共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
    cocos2d::LuaBridge::releaseLuaFunctionById(handlerID); //最后记得释放
}

@end
