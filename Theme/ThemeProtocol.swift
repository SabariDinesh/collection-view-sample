//
//  ThemeProtocol.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 19/10/21.
//

import UIKit

protocol ThemeProtocol {
    var background: UIColor {get}
    var text: UIColor {get}
    var cell: UIColor {get}
    var switchColor: UIColor{get}
    var searchBar: UIColor{get}
    var titleColor: UIColor{get}
    var vc: UIColor{get}
}

class LightTheme: ThemeProtocol{
    var vc: UIColor = UIColor(named: "vcLight")!
    var background: UIColor = UIColor(named: "white")!
    var text: UIColor = UIColor(named: "black")!
    var cell: UIColor = UIColor(named: "blue")!
    var switchColor = UIColor(named:"sblue")!
    var searchBar = UIColor(named: "white")!
    var titleColor: UIColor = UIColor(named: "dark grey")!
}

class DarkTheme: ThemeProtocol{
    var vc: UIColor = UIColor(named: "vcDark")!
    var switchColor: UIColor = UIColor(named: "yellow")!
    var searchBar: UIColor = UIColor(named: "white")!
    var background: UIColor = UIColor(named: "grey")!
    var text: UIColor = UIColor(named: "white")!
    var cell: UIColor = UIColor(named: "dark grey")!
    var titleColor: UIColor = UIColor(named: "light grey")!
    
}

class Theme{
    static var current: ThemeProtocol = LightTheme()
}
