//
//  ViewController.swift
//  TestApp
//
//  Created by Aleksey Makhutin on 30.04.2022.
//

import UIKit
import EMLDude

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let file = Bundle.main.path(forResource: "email", ofType: "eml"),
           let data = try? Data.init(contentsOf: URL(fileURLWithPath: file)),
           let eml = try? EMLDude(data: data) {
            print(eml)
        }
    }
}
