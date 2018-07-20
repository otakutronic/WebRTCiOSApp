//
//  AppDelegate.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import RealmSwift
import UserNotifications
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate, UITabBarControllerDelegate{
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var loginSuccess = false
    var firshRun = true
    var providerDelegate: ProviderDelegate!
    let callManager = CallManager()
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().barTintColor = COLOR_MAIN
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().backgroundColor = COLOR_MAIN
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    ///Register for VoIP notifications
    func registerVoIP() {
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        providerDelegate = ProviderDelegate(callManager: callManager)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - application: <#application description#>
    ///   - launchOptions: <#launchOptions description#>
    /// - Returns: <#return value description#>
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // register for voIP notifications
        registerVoIP()
        
        FirebaseApp.configure()
        migrateDataIfNeeded()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        // [END set_messaging_delegate]
        
        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)

        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        guard let token:String = Messaging.messaging().fcmToken else {
            /* Handle nil case */ return true }
        
        setFirebaseRegistration(token: token)
        
        // [END register_for_notifications]
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        guard let handle = url.startCallHandle else {
//            print("Could not determine start call handle from URL: \(url)")
//            return false
//        }
//
//        callManager.startCall(handle: handle)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        guard let handle = userActivity.startCallHandle else {
//            print("Could not determine start call handle from user activity: \(userActivity)")
//            return false
//        }
//
//        guard let video = userActivity.video else {
//            print("Could not determine video from user activity: \(userActivity)")
//            return false
//        }
//
//        callManager.startCall(handle: handle, video: video)
        return true
    }
    
    /// Store active users push credentials for the server.
    ///
    /// - Parameters:
    ///   - registry: <#registry description#>
    ///   - credentials: <#credentials description#>
    ///   - type: <#type description#>
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {

        let token = credentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        print("voIP registration token: \(token)")
        LibraryAPI.shared.appData.voipToken = token
    }
    
    /// pushRegistry
    ///
    /// - Parameters:
    ///   - registry: <#registry description#>
    ///   - payload: <#payload description#>
    ///   - type: <#type description#>
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        
        print("didReceiveIncomingPushWithPayload: \(payload.dictionaryPayload)")
        
        guard type == .voIP else { return }
        
        print("didReceiveIncomingPushWithPayload: \(payload.dictionaryPayload)")
       
        // test
        let uuid = UUID()
        let contact = Contact(uuid: "1", name: "", number: "", state: "call", profilePicture: "")
        displayIncomingCall(uuid: uuid, handle: "handle", hasVideo: true, contact: contact)
        
//        if let rootViewController = window?.rootViewController as? UINavigationController {
//            if let viewController = rootViewController.viewControllers.first as? HomeViewController {
//
//                let contact = Contact(uuid: "1", name: "", number: "", state: "call", profilePicture: "")
//                viewController.showCallPopup(contact: contact, sessionID: "1")
//            }
//        }
        
        //let uuidString = payload.dictionaryPayload["aps"] as? String
        
        //print("uuidString:\(uuidString)")
        
        //print(uuidString)

        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
            let handle = payload.dictionaryPayload["handle"] as? String,
            let hasVideo = payload.dictionaryPayload["hasVideo"] as? Bool,
            let uuid = UUID(uuidString: uuidString)
        {
            displayIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, contact: contact)
        }
    }

    /// Display the incoming call to the user
    ///
    /// - Parameters:
    ///   - uuid: <#uuid description#>
    ///   - handle: <#handle description#>
    ///   - hasVideo: <#hasVideo description#>
    ///   - contact: <#contact description#>
    ///   - completion: <#completion description#>
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, contact: Contact, completion: ((Error?) -> Void)? = nil) {
        print("displayIncomingCall ")
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, contact: contact, completion: completion)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is YourViewController {
//            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "YourVCStoryboardIdentifier") {
//                tabBarController.present(newVC, animated: true)
//                return false
//            }
//        }
        
        //if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "YourVCStoryboardIdentifier") {
            //tabBarController.present(newVC, animated: true)
            //return false
        //}
        
        //return true
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            if topController == nil || viewController == topController {
                return false
            }
            
            let fromView = topController.view
            let toView = viewController.view
            
            print("transition")
            
            //let storyboard = UIStoryboard(name: "CallPopup", bundle: nil)
            //let vc = storyboard.instantiateViewController(withIdentifier: "CallPopupViewID")
            //self.popupViewController = vc.childViewControllers.first as! CallPopupViewController
            //self.popupViewController.contact = contact
            //self.popupViewController.sessionID = sessionID
            //tabBarController.present(topController, animated: true, completion: nil)
            //setviewcontrollers
            UIView.transition(from: fromView!, to: toView!, duration: 5.3, options: [.transitionCurlDown], completion: {
                _ in
                print("complete")
                tabBarController.tabBar.isHidden = false
                // Your code here
            })            //let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "CameraView") as! UIViewController
            //tabBarController.present(UINavigationController.init(rootViewController: newVC), animated: true, completion: {
                //
            //})
            
            
            
            return false
            
            //tabBarController.present(viewController, animated: true)
            //self.performSegue(withIdentifier: "PatternLockViewController", sender: nil)
            //UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)

        }

        return true
        
       
        //return true
    }
    
    /// applicationStateString
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    /// requestNotificationAuthorization
    ///
    /// - Parameter application: <#application description#>
    func requestNotificationAuthorization(application: UIApplication) {
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    /// getNotificationSettings
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// setFirebaseRegistration
    ///
    /// - Parameter token: <#token description#>
    func setFirebaseRegistration(token: String) {
        print("Firebase registration token: \(token)")
        LibraryAPI.shared.appData.fmcToken = token
    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //showPopup(videoEnabled: true)
        print("Message 1 ID")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message 1 ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
//    func showPopup(videoEnabled: Bool) {
//        //        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
//        //        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
//        //            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: "handle", hasVideo: videoEnabled) { _ in
//        //                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
//        //            }
//        //        }
//
//        //let sessionID = JSON(responseData)[0].stringValue
//        //let contact = Contact(uuid: "13", name: "andy", number: "12", state: "call", profilePicture: "")
//        //showPopup2(contact: contact, sessionID: sessionID, videoEnabled: videoEnabled)
//    }
    
//    func showPopup2(contact: Contact, sessionID: String, videoEnabled: Bool) {
//        //        let storyboard = UIStoryboard(name: "CallPopup", bundle: nil)
//        //        let vc = storyboard.instantiateViewController(withIdentifier: "CallPopupViewID")
//        //        let popupViewController = vc.childViewControllers.first as! CallPopupViewController
//        //        popupViewController.contact = contact
//        //        popupViewController.sessionID = sessionID
//        //        present(vc, animated: true, completion: nil)
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //showPopup(videoEnabled: true)
        print("Message 2 ID")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message 2 ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Realm
    
    func migrateDataIfNeeded() {
        print("Realm path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    migration.enumerateObjects(ofType: Contact.className(), { (oldObject, newObject) in
                        let oldUpdateDate = oldObject!["updateTime"] as! String
                        
                        if let date = dateFormatter.date(from: String(describing:oldUpdateDate)) {
                            newObject!["updateTime"] = date
                        }
                    })
                    //hopeless.
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    
                }
                
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mji.tapia.tapiamobile" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "tapiamobile", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("tapiamobile.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "tapiamobile", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        //showPopup(videoEnabled: true)
        print("Received data message 3")
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message 3 receieved from inside app with ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //showPopup(videoEnabled: true)
        print("Received data message 4")
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message 4 receieved from outside app with ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //showPopup(videoEnabled: true)
        print("Received data message 2")
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
        setFirebaseRegistration(token: fcmToken)
    }
    //    // iOS9, called when presenting notification in foreground
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
    //        if UIApplication.shared.applicationState == .active {
    //            //TODO: Handle foreground notification
    //        } else {
    //            //TODO: Handle background notification
    //        }
    //    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message 3")
        //showPopup(videoEnabled: true)
        // Convert to pretty-print JSON, just to show the message for testing
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else {
                return
        }
        print("Received direct channel message:\n\(prettyPrinted)")
        
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Received data message 1")
        //showPopup(videoEnabled: true)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        setFirebaseRegistration(token: fcmToken)
    }
}
