//
//  BaseAssembly.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class RootVCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RootViewController.self) { resolver in
            return RootViewController()
        }
    }
}

extension RootViewController {
    static func newInstance() -> RootViewController {
        return Container.shareResolver.resolve(RootViewController.self)!
    }
}

final class ApiSeviceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ApiSevice.self) { _ in
            return ApiSevice()
        }
    }
}
