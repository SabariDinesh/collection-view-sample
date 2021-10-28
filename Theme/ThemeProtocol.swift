//
//  ThemeProtocol.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 19/10/21.
//

import UIKit
import Themes

struct ThemeProperties: Theme {
    var background: UIColor
    var text: UIColor
    var cell: UIColor
    var switchColor: UIColor
    var searchBar: UIColor
    var titleColor: UIColor
    var vc: UIColor
}
let LightTheme = ThemeProperties(background: UIColor(named: "white")!, text: UIColor(named: "black")!, cell: UIColor(named: "blue")!, switchColor: UIColor(named: "sblue")!, searchBar: UIColor(named: "white")!, titleColor: UIColor(named: "dark grey")!, vc: UIColor(named: "vcLight")!)

let DarkTheme = ThemeProperties(background: UIColor(named: "grey")!, text: UIColor(named: "white")!, cell: UIColor(named: "dark grey")!, switchColor: UIColor(named: "yellow")!, searchBar: UIColor(named: "white")!, titleColor: UIColor(named: "light grey")!, vc: UIColor(named: "vcDark")!)

