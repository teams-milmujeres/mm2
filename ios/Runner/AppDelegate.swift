import Flutter
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Inicializar Firebase
    FirebaseApp.configure()
    
    // Configurar Firebase Messaging delegate
    Messaging.messaging().delegate = self

    // Solicitar autorización para notificaciones
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if granted {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
          print("✅ Push notifications authorized")
        }
      } else if let error = error {
        print("❌ Failed to request notification authorization: \(error)")
      }
    }
    
    // Configurar delegado para notificaciones
    UNUserNotificationCenter.current().delegate = self

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Manejar registro exitoso de APNs
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    print("✅ APNs registration successful")
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Manejar error en registro de APNs
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Failed to register for remote notifications: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  // Mostrar notificaciones cuando la app está en foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    print("📨 Notification received in foreground: \(userInfo)")
    
    // Mostrar en banner, con sonido y badge incluso en foreground
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }
  
  // Manejar cuando el usuario toca una notificación
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    print("👆 User tapped notification: \(userInfo)")
    completionHandler()
  }
}

// MARK: - Messaging Delegate
extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    print("✅ FCM Token: \(fcmToken ?? "No token available")")
    
    // Notificar al app de que hay un nuevo FCM token
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: NSNotification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}