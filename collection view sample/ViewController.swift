import UIKit
import Themes

class ViewController: UIViewController{
 
    //visual elements variables
    var searchBar = UISearchBar()
    var upcomingFilter = UIButton()
    var appTitle = UILabel()
    var switchButton = UISwitch()
    var myCollectionView: UICollectionView?
    
    //other variables
    var movieArray: [Movie] = []
    var upcomingButtonTapped = false
    var searchButtonTapped = false
    var vcImage: UIImageView = UIImageView()
    var page = 0
    var currentCount = 0
    var commonConstraints : [NSLayoutConstraint] = []
    var queryText = ""
    var cell_id = 0
    var total_pages = 0
    
    override func loadView(){
        super.loadView()
        checkForTheme()
        //applyTheme()
        addSpecifications()
        addSubViews()
        settingDelegates()
        applyConstraints()
        addActions()
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        page = 1
        getApiResponse(iterator: page)
        
        //myCollectionView.reloadData()
        }
    
    
    func checkForTheme(){
        if UserDefaults.standard.object(forKey: "LightTheme") != nil {
           if UserDefaults.standard.bool(forKey: "LightTheme"){
                    switchButton.setOn(true, animated: true)
                    }else{
                        switchButton.setOn(false, animated: false)
                    }
            }
        
        
    }
    func addSubViews(){
        view.addSubview(myCollectionView!)
        view.addSubview(searchBar)
        view.addSubview(appTitle)
        view.addSubview(switchButton)
        view.addSubview(upcomingFilter)
    }
    
    func addSpecifications(){
        //specifications
        myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ViewController.createLayout())
        myCollectionView?.register(CellConfiguration.self, forCellWithReuseIdentifier: CellConfiguration.identifier)
        //view.backgroundColor = ThemeManager.shared.currentTheme.background
        use(ThemeProperties.self){
            $0.view.backgroundColor = $1.background
            $0.myCollectionView?.backgroundColor = $1.background
            $0.appTitle.textColor = $1.titleColor
            $0.upcomingFilter.setTitleColor($1.switchColor, for: .normal)
        }
        searchBar.layer.cornerRadius = 10
        searchBar.barStyle = .default
        searchBar.placeholder = " search"
        
        appTitle.text = "MOVIE DB".localized()
        appTitle.font = .boldSystemFont(ofSize: 17)
        appTitle.textAlignment = .center
        
        switchButton.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        upcomingFilter.setTitle("UPCOMING", for: .normal)
        upcomingFilter.titleLabel?.font = .boldSystemFont(ofSize: 12)
        
    }
    
    func addActions(){
        //actions
        switchButton.addTarget(self, action: #selector(switchFunc), for: .valueChanged)
        upcomingFilter.addTarget(self, action: #selector(langFunc), for: .touchUpInside)
    }
    func applyConstraints(){
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        upcomingFilter.translatesAutoresizingMaskIntoConstraints = false
        
        
        //common constraints
        commonConstraints = [
            upcomingFilter.widthAnchor.constraint(equalToConstant: 90),
            upcomingFilter.heightAnchor.constraint(equalToConstant: 50),
            upcomingFilter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            upcomingFilter.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),

            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor , constant: 10),
            searchBar.rightAnchor.constraint(equalTo: upcomingFilter.leftAnchor, constant: -10),
            myCollectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            myCollectionView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor , constant: 10),
            myCollectionView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor , constant: -10),
            myCollectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            switchButton.widthAnchor.constraint(equalToConstant: 60),
            switchButton.heightAnchor.constraint(equalToConstant: 50),
            switchButton.topAnchor.constraint(equalTo: upcomingFilter.bottomAnchor, constant: 10),
            switchButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor , constant: -10),

            appTitle.heightAnchor.constraint(equalToConstant: 50),
            appTitle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 3),
            appTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor , constant: 10),
            appTitle.rightAnchor.constraint(equalTo: switchButton.leftAnchor,constant: -10)
            
            
        ]
        NSLayoutConstraint.activate(commonConstraints)
    }
    
    func applyTheme(){

        use(ThemeProperties.self){
            $0.view.backgroundColor = $1.background
            $0.myCollectionView?.backgroundColor = $1.background
            $0.appTitle.textColor = $1.titleColor
            $0.upcomingFilter.setTitleColor($1.switchColor, for: .normal)
            $0.myCollectionView?.reloadData()
        }

    }
    
    func settingDelegates(){
        //delegates
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        searchBar.delegate = self
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))


        item.contentInsets = NSDirectionalEdgeInsets (top: 2, leading: 2, bottom: 2, trailing: 2)

        //group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.3/5)), subitem: item, count: 1)

        //section
        let section = NSCollectionLayoutSection(group: group)


        //return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    @objc func switchFunc( sender: UISwitch){
        if sender.isOn{
            ThemeManager.shared.currentTheme = LightTheme
            applyTheme()
        }
        else{
            ThemeManager.shared.currentTheme = DarkTheme
            applyTheme()
        }
        UserDefaults.standard.set(sender.isOn, forKey: "LightTheme")
    }
        
    @objc func langFunc(sender: UIButton){
        upcomingButtonTapped = !upcomingButtonTapped
        if upcomingButtonTapped{
            movieArray = []
            page = 1
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.getApiResponse(iterator: self.page)
                self.myCollectionView?.reloadData()
            }
            myCollectionView?.reloadData()
       }else{
            movieArray = []
           myCollectionView?.reloadData()
            page = 1
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.getApiResponse(iterator: self.page)
            }
           myCollectionView?.reloadData()
        }
    }
    
}

extension ViewController: UICollectionViewDelegate{
   
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if queryText != ""{
            if indexPath.item == currentCount-1 && page <= total_pages{
                page += 1
                getApiResponse(with: queryText, iterator: page)
                print("the page number is \(page)")
                myCollectionView?.reloadData()
            }
        }else{
            if indexPath.item == currentCount-1 && page <= total_pages {
                page += 1
                getApiResponse( iterator: page)
                print("the page number is \(page)")
                myCollectionView?.reloadData()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //print("collection view at row \(collectionView.tag) selected index path \(indexPath.item)")
        let vc = vc()
        let navigationVc = UINavigationController(rootViewController: vc)
        navigationVc.modalPresentationStyle = .fullScreen
        
        
        //when to display what movie
        let thisMovie: Movie?
        thisMovie =  movieArray[indexPath.item]
        
        var description: String = ""
        var title: String = ""
        
        if thisMovie != nil{
            description = thisMovie?.overview ?? "no description"
            
            title = thisMovie?.original_title ?? "no title"
            
            if thisMovie?.backdrop_path != nil{
                
                //download task
                DispatchQueue.main.async {
                    if thisMovie?.poster_path != nil{
                    vc.downloadImage(imageLink: (thisMovie?.poster_path!)!)
                    }
                }
            }

            
        }
        
        vc.label.text = "\(title.uppercased()) \n \n \(description)"
        present(navigationVc, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentCount = movieArray.count
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.identifier, for: indexPath) as! CellConfiguration
        
       
        
        let thisMovie: Movie?
        
        if !movieArray.isEmpty{
        thisMovie = movieArray[indexPath.item]
        
        if thisMovie != nil{
            cell.setTitle(with: thisMovie?.original_title ?? "no title")
            cell.setVote(with: thisMovie?.vote_average! ?? 0.0)
            cell.setLanguage(with: thisMovie?.original_language! ?? "no language")
            cell.movieImage.image =  UIImage(named: "image")
            cell_id = (thisMovie?.id)!
            
            if thisMovie?.poster_path != nil{
                DispatchQueue.main.async {
                    cell.downloadImage(imageLink:(thisMovie?.poster_path!)! )
                }
            }
        }
        }
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width-20, height: collectionView.bounds.size.height-100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
}


    
extension ViewController{
    func getApiResponse(iterator: Int) {
        let api="https://api.themoviedb.org"
        var keywordToAdd = ""
        
        if upcomingButtonTapped{
            keywordToAdd = "movie/upcoming"
        }
        else if searchButtonTapped{
            keywordToAdd = "search/movie"
        }
        else{
            keywordToAdd = "movie/popular"
        }
        
        
        let endpoint = "/3/\(keywordToAdd)?api_key=fb4759c3bceadbbf3d8980c1aa95c5e1&page=\(iterator)"
        var urlString : String = ""
        urlString = api + endpoint
        
        let url = URL(string: urlString)
        //var jsonObject: Movie?
        guard url != nil else {
            print("error in url object")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url!) { [weak self] data, response, error in
            //if not error
            if error == nil && data != nil {
                //parse the data
                let decoder = JSONDecoder()
                do{
                    let responded = try decoder.decode(DataFormat.self, from: data!)
                    print("got data")
                    guard let movies = responded.results else{
                        return
                    }
                    DispatchQueue.main.async {
                        self?.movieArray.append(contentsOf: movies)
                        self?.total_pages = responded.total_pages!
                        self?.myCollectionView?.reloadData()
                    }
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
        myCollectionView?.reloadData()
    }
    
    func getApiResponse(with query: String ,iterator: Int) {
        let api="https://api.themoviedb.org"
        var keywordToAdd = ""
        
        if upcomingButtonTapped{
            keywordToAdd = "movie/upcoming"
        }
        else if searchButtonTapped{
            keywordToAdd = "search/movie"
        }
        else{
            keywordToAdd = "movie/popular"
        }
        let endpoint = "/3/\(keywordToAdd)?api_key=fb4759c3bceadbbf3d8980c1aa95c5e1&page=\(iterator)&query=\(query)"
        
        let urlString : String = api + endpoint
        
        let url = URL(string: urlString)
        //var jsonObject: Movie?
        guard url != nil else {
            print("error in url object")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url!) {[weak self] data, response, error in
            //if not error
            if error == nil && data != nil {
                //parse the data
                let decoder = JSONDecoder()
                do{
                    let responded = try decoder.decode(DataFormat.self, from: data!)
                    print("got data")
                    guard let movies = responded.results else{
                        return
                    }
                    DispatchQueue.main.async {
                        self?.movieArray.append(contentsOf: movies)
                        self?.total_pages = responded.total_pages!
                        self?.myCollectionView?.reloadData()
                    }
                
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
}

extension ViewController: UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            queryText = text
            searchButtonTapped = true
            upcomingButtonTapped = false
            movieArray = []
            myCollectionView?.reloadData()
            page = 1
            getApiResponse(with: text,iterator: page)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        queryText = ""
        movieArray = []
        myCollectionView?.reloadData()
        page = 1
        searchButtonTapped = false
        upcomingButtonTapped = false
        getApiResponse(iterator: page)

    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

