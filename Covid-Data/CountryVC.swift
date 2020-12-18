//
//  CountryVC.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/17/20.
//

import UIKit

class CountryVC: UIViewController {
    
    public var country: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(country ?? "no country")
    }
}
