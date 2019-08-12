//
//  AppDelegate.swift
//  AliceX
//
//  Created by lmcmz on 7/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

private var navi: UINavigationController?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions
        _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        IQKeyboardManager.shared.enable = true

        WalletManager.loadFromCache()
        PriceHelper.shared.fetchFromCache()
//        GasPriceHelper.shared.getGasPrice()

//        func sourceURL(bridge _: RCTBridge?) -> URL? {
//            #if DEBUG
//                return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
//            #else
//                return CodePush.bundleURL()
//            #endif
//        }
//
//        bridge = RCTBridge(bundleURL: sourceURL(bridge: bridge), moduleProvider: nil, launchOptions: nil)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear

        var vc = UIViewController()

        if WalletManager.hasWallet() {
            vc = QRCodeReaderViewController()
//            vc = RNModule.makeViewController(module: .alice)
        } else {
            vc = LandingViewController()
        }

        let rootVC = BaseNavigationController(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        navi = rootVC

        HKFloatManager.addFloatVcs([NSStringFromClass(BrowserViewController.self),
                                    NSStringFromClass(BrowserWrapperViewController.self)])

        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        HideHelper.shared.start()
    }

    func applicationDidEnterBackground(_: UIApplication) {}

    func applicationWillEnterForeground(_: UIApplication) {}

    func applicationDidBecomeActive(_: UIApplication) {
        HideHelper.shared.stop()
    }

    func applicationWillTerminate(_: UIApplication) {}

//    class func rnBridge() -> RCTBridge {
//        return bridge!
//    }
}
