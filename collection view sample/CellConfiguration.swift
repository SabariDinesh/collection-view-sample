//
//  CellConfiguration.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 15/10/21.
//

import UIKit
import Themes

class CellConfiguration: UICollectionViewCell{

    //visual elements variables
    var movieImage = UIImageView()
    var titleLable = UILabel()
    var originalLanguage = UILabel()
    var voteAverage = UILabel()
    var cellImageUrl: String?
    let imageCache = NSCache<NSString, UIImage>()
    var constraintsArray: [NSLayoutConstraint] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setSpec()
        setColors()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
        contentView.layer.cornerRadius = 2
        contentView.addSubview(movieImage)
        contentView.addSubview(originalLanguage)
        contentView.addSubview(titleLable)
        contentView.addSubview(voteAverage)
    }
    
    func setSpec(){
        titleLable.font = .boldSystemFont(ofSize: 12)
        voteAverage.font = .italicSystemFont(ofSize: 10)
        originalLanguage.font = .italicSystemFont(ofSize: 10)
    }
    
    func setConstraints(){
        //movie image constraints
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        constraintsArray = [
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -15),
            movieImage.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -15),
            movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor),
            movieImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        //labels constraints
        var previous: UILabel?
        for label in [titleLable, originalLanguage, voteAverage]{
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: 130).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            label.textAlignment = .center
            
            
            if let previous = previous {
                label.centerYAnchor.constraint(equalTo: previous.bottomAnchor, constant: 6).isActive = true

            }
            else{
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
            }
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor , constant: -70).isActive = true
            previous = label
        }
        NSLayoutConstraint.activate(constraintsArray)

    }
    
    func setColors(){
        use(ThemeProperties.self){
            $0.titleLable.textColor = $1.text
            $0.voteAverage.textColor = $1.text
            $0.originalLanguage.textColor = $1.text
            $0.contentView.backgroundColor = $1.cell
        }
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


