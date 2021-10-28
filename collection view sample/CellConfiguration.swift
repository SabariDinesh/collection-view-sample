//
//  CellConfiguration.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 15/10/21.
//

import UIKit

class CellConfiguration: UICollectionViewCell{

    var movieImage = UIImageView()
    var titleLable = UILabel()
    var originalLanguage = UILabel()
    var voteAverage = UILabel()
    var cellImageUrl: String?
    let imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     }
    
    
    func setLanguage(with language:String){
        originalLanguage.text = language
    }
     
    func setVote(with vote:Double){
        voteAverage.text = String(vote)
    }
    
    func setTitle(with title: String){
        titleLable.text = title
    }
    
    
    //identifier of the cell
    static let identifier = "CellConfiguration"
    
    
    func downloadImage(imageLink imageUrl: String) {
        let downloadPath = "https://www.themoviedb.org/t/p/w92"
        let urlForImage = downloadPath + imageUrl
        cellImageUrl = urlForImage
        
        //checking whether it is in cache
        if let img = imageCache.object(forKey: NSString(string: cellImageUrl!)){
            movieImage.image = img
            return
        }
            
        
        guard let url = URL (string: urlForImage) else{
           print ("invalid image URL")
           return
        }
        cellImageUrl = urlForImage
        let downloadTask = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                
                if self?.cellImageUrl == urlForImage {
                self?.movieImage.image = image
                }else{
                    self?.movieImage.image = UIImage(named: "image")
                }
                self?.imageCache.setObject(image!, forKey: NSString(string: (self?.cellImageUrl)!))
                
            }
        }
        downloadTask.resume()
        
    }
}

