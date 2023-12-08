import RxFlow
import RxSwift
import UIKit
import Moya

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var rootVC: BaseVC = LoginVC()
    
    let authProvider = MoyaProvider<AuthAPI>()
    var authData: LoginResponse!

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
//        Keychain.shared.delete(type: .refreshToken)

        DispatchQueue.global().async {
            do {
                let refreshToken = try Keychain.shared.load(type: .refreshToken)
                print("Refresh Token : \(refreshToken)")
                
                self.authProvider.request(.refresh(refreshToken: refreshToken)) { response in
                    switch response {
                    case .success(let result):
                        do {
                            self.authData = try result.map(LoginResponse.self)
                        } catch(let err) {
                            print(String(describing: err))
                        }
                        let statusCode = result.statusCode
                        
                        switch statusCode{
                        case 200..<300:
                            KeychainLocal.shared.saveAccessToken(self.authData.accessToken)
                            KeychainLocal.shared.saveRefreshToken(self.authData.refreshToken)
                            KeychainLocal.shared.saveAccessExp(self.authData.accessExp)
                            KeychainLocal.shared.saveRefreshExp(self.authData.refreshExp)
                            
                            self.rootVC = MainVC()
                        
                            DispatchQueue.main.async {
                                let navigationController = UINavigationController(rootViewController: self.rootVC)
                                self.window?.rootViewController = navigationController
                                self.window?.makeKeyAndVisible()
                            }
                            
                        case 400:
                            print("리프레시 토큰이 아님")
                        case 401:
                            print("토큰이 유효하지 않음")
                        case 404:
                            print("사용자를 찾을 수 없음")
                        default:
                            print(statusCode)
                        }
                        
                    case .failure(let err):
                        print(String(describing: err))
                    }
                }
                
            } catch {
                print("Error loading refresh token: \(error)")
                
                DispatchQueue.main.async {
                    let navigationController = UINavigationController(rootViewController: self.rootVC)
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

