//
//  vc.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 18/10/21.
//

import UIKit
import Themes

class vc: UIViewController  {

    var vcImage = UIImageView()
    let label = UILabel()

    @objc func tappedButton(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        navBarSpec()
        addSpec()
    }
    
    //functions used in viewDidLoad
    func addSubViews(){
        view.addSubview(label)
        view.addSubview(vcImage)
        view.sendSubviewToBack(vcImage)
    }
    
    func navBarSpec(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.backgroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tappedButton))
        title = "Description"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    func addSpec(){
        label.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        label.center = view.center
        label.textAlignment = .center
        label.numberOfLines = 0
        vcImage.frame = view.bounds
        use(ThemeProperties.self){
        $0.label.backgroundColor = $1.vc
        $0.label.textColor = $1.text
        $0.view.backgroundColor = $1.background
        }
    }

}

//networking function
extension vc{
    func downloadImage(imageLink imageUrl: String) {
        let downloadPath = "https://www.themoviedb.org/t/p/w300"
        let forImage = downloadPath + imageUrl
        guard let url = URL (string: forImage) else{
           return
        }
        let downloadTask = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
               self?.vcImage.image = image
            }
        }
        downloadTask.resume()
    }
}

