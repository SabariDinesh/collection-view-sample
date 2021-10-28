//
//  vc.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 18/10/21.
//

import UIKit

class vc: UIViewController  {

    var vcImage = UIImageView()
    let button = UIButton()
    
    @objc func tappedButton(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Description"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        view.backgroundColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tappedButton))
    }
    

}

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

