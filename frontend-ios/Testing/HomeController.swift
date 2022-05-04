//
//  HomeController.swift
//  Testing
//
//  Created by Derek Sanchez on 5/2/22.
//

import UIKit
import SwiftUI

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2318199277, green: 0.8869469762, blue: 0.7684106231, alpha: 1)
        print("Home Controller!")        
    }
    
    
}

struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
