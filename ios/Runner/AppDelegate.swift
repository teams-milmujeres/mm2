import Flutter
import UIKit
import UserNotifications
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Inicializar Firebase
    FirebaseApp.configure()

    // Notificaciones
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}