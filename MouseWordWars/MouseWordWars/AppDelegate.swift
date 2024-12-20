//
//  AppDelegate.swift
//  MouseWordWars
//
//  Created by Christmas Clash: Mouse Word Wars on 2024/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.isEnabled = true
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = UIViewController.christmasAppsFlyerDevKey()
        appsFlyer.appleAppID = "6739698085"
        appsFlyer.waitForATTUserAuthorization(timeoutInterval: 51)
        appsFlyer.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate :AppsFlyerLibDelegate{
    
    /// AppsFlyerLibDelegate
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("success appsflyer")
    }
    
    func onConversionDataFail(_ error: Error) {
        print("error appsflyer")
    }
}
