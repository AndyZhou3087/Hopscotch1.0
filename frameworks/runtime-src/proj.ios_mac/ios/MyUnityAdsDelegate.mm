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

NSDictionary * _dict;
VungleSDK * vungleSdk;

@implementation MyUnityAdsDelegate


+ (IBAction)showVungleAds:(NSDictionary *)dict {
    _dict = dict;

    NSString * appID = @"584a218898d2beed0e00005f";
    vungleSdk = [VungleSDK sharedSDK];
    [vungleSdk startWithAppId:appID];
    [vungleSdk setDelegate:self];
    [vungleSdk setLoggingEnabled:false];
    if ([vungleSdk isAdPlayable]) {
        NSError * error;
        UIViewController * s = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        NSDictionary * options = @{VunglePlayAdOptionKeyOrientations:@true};
        [vungleSdk playAd:s withOptions:options error:&error];
    }
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


/*adsWhereRevive = 0,
adsSuccess,1
adsRemoveAds,2
adsDailyAds,3
adsOverAddTime,4
adsStartChooseProp,5
adsShop,6
adsBuyLife 7*/

- (void)didAfterCompleted:(NSDictionary *)dict{
    NSLog(@"lua call ocFounction succeed");
    //这里获取lua层的数据后  对数据进行操作（例如调用支付宝接口等） 将返回的数据再通过下面的方法回传给lua层
    
    int handlerID = (int)[[dict objectForKey:@"callBack"] integerValue];  //lua传输过来的回调lua的方法名inergerValue    这里可以将该id缓存在oc层的一个全局变量中  在合适的位置再回调lua层
    cocos2d::LuaBridge::pushLuaFunctionById(handlerID); //压入需要调用的方法id
    cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();  //获取lua栈
    stack->pushString("success");  //将需要传递给lua层的参数通过栈传递
    stack->executeFunction(1);  //共有1个参数 (“oc传递给lua的参数”)，这里传参数 1
    cocos2d::LuaBridge::releaseLuaFunctionById(handlerID); //最后记得释放
}

@end
