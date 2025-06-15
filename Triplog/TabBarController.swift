//
//  TabBarController.swift
//  Triplog
//
//  Created by 배수빈 on 6/12/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.selectedIndex = 1 // 0 = 첫 번째 탭, 1 = 두 번째 탭 (홈)
    }
    
    
}
