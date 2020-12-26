//
//  ViewControllerAssembly.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class SplashViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { _ in
            let vc = StoryboardScene.Main.splashViewController.instantiate()
            return vc
        }
    }
}
extension SplashViewController {
    static func newInstance() -> SplashViewController {
        let vc =  Container.shareResolver.resolve(SplashViewController.self)!
        return vc
    }
}

final class LoginViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewController.self) { _ in
            let vc = StoryboardScene.Main.loginViewController.instantiate()
            return vc
        }
    }
}
extension LoginViewController {
    static func newInstance() -> LoginViewController {
        let vc =  Container.shareResolver.resolve(LoginViewController.self)!
        return vc
    }
}

final class MenuViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MenuViewController.self) { _ in
            let vc = StoryboardScene.Main.menuViewController.instantiate()
            return vc
        }
    }
}
extension MenuViewController {
    static func newInstance() -> MenuViewController {
        let vc =  Container.shareResolver.resolve(MenuViewController.self)!
        return vc
    }
}

final class TutorialViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TutorialViewController.self) { _ in
            let vc = StoryboardScene.Main.tutorialViewController.instantiate()
            return vc
        }
    }
}
extension TutorialViewController {
    static func newInstance() -> TutorialViewController {
        let vc =  Container.shareResolver.resolve(TutorialViewController.self)!
        return vc
    }
}

final class TabDownloadViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabDownloadViewController.self) { _ in
            let vc = StoryboardScene.Main.tabDownloadViewController.instantiate()
            return vc
        }
    }
}
extension TabDownloadViewController {
    static func newInstance() -> TabDownloadViewController {
        let vc =  Container.shareResolver.resolve(TabDownloadViewController.self)!
        return vc
    }
}

final class TabVideoViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabVideoViewController.self) { _ in
            let vc = StoryboardScene.Main.tabVideoViewController.instantiate()
            return vc
        }
    }
}
extension TabVideoViewController {
    static func newInstance() -> TabVideoViewController {
        let vc =  Container.shareResolver.resolve(TabVideoViewController.self)!
        return vc
    }
}

final class TabVideoTutorialViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabVideoTutorialViewController.self) { _ in
            let vc = StoryboardScene.Main.tabVideoTutorialViewController.instantiate()
            return vc
        }
    }
}
extension TabVideoTutorialViewController {
    static func newInstance() -> TabVideoTutorialViewController {
        let vc =  Container.shareResolver.resolve(TabVideoTutorialViewController.self)!
        return vc
    }
}

final class TabCoinViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TabCoinViewController.self) { _ in
            let vc = StoryboardScene.Main.tabCoinViewController.instantiate()
            return vc
        }
    }
}
extension TabCoinViewController {
    static func newInstance() -> TabCoinViewController {
        let vc =  Container.shareResolver.resolve(TabCoinViewController.self)!
        return vc
    }
}

final class PopupDonateViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PopupDonateViewController.self) { _ in
            let vc = StoryboardScene.Main.popupDonateViewController.instantiate()
            return vc
        }
    }
}
extension PopupDonateViewController {
    static func newInstance() -> PopupDonateViewController {
        let vc =  Container.shareResolver.resolve(PopupDonateViewController.self)!
        return vc
    }
}

final class PopupWarningViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PopupWarningViewController.self) { _ in
            let vc = StoryboardScene.Main.popupWarningViewController.instantiate()
            return vc
        }
    }
}
extension PopupWarningViewController {
    static func newInstance() -> PopupWarningViewController {
        let vc =  Container.shareResolver.resolve(PopupWarningViewController.self)!
        return vc
    }
}

final class BuyCoinViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BuyCoinViewController.self) { _ in
            let vc = StoryboardScene.Main.buyCoinViewController.instantiate()
            return vc
        }
    }
}
extension BuyCoinViewController {
    static func newInstance() -> BuyCoinViewController {
        let vc =  Container.shareResolver.resolve(BuyCoinViewController.self)!
        return vc
    }
}

final class BuyVipViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BuyVipViewController.self) { _ in
            let vc = StoryboardScene.Main.buyVipViewController.instantiate()
            return vc
        }
    }
}
extension BuyVipViewController {
    static func newInstance() -> BuyVipViewController {
        let vc =  Container.shareResolver.resolve(BuyVipViewController.self)!
        return vc
    }
}
