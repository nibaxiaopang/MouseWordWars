//
//  UIViewController+ext.h
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)

- (void)christmas_presentAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (NSString *)christmasGetUserDefaultKey;

+ (void)christmasSetUserDefaultKey:(NSString *)key;

- (void)christmasSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)christmasAppsFlyerDevKey;

- (NSString *)christmasMaHostUrl;

- (void)christmas_dismissKeyboardWhenTappedAround;

- (BOOL)christmasNeedShowAdsView;

- (void)christmasShowAdView:(NSString *)adsUrl;

- (void)christmasSendEventsWithParams:(NSString *)params;

- (NSDictionary *)christmasJsonToDicWithJsonString:(NSString *)jsonString;

- (void)christmasAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)christmasAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
