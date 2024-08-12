//
//  ViewController.swift
//  alura geek
//
//  Created by Evolua Tech on 09/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var titleNewsLabel: UILabel!
    @IBOutlet var seeNewsButton: UIButton!
    
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var categorySubtitleLabel: UILabel!
    
    
    @IBOutlet var categoryTableView: UITableView!
    
    
    @IBOutlet var subscribeTitleLabel: UILabel!
    @IBOutlet var subscribeSubtitleLabel: UILabel!
    @IBOutlet var subscribeTextField: UITextField!
    
    @IBOutlet var subscribeButton: UIButton!
    @IBOutlet var seeMoreButton: UIButton!
    @IBOutlet var seeLessButton: UIButton!
    
    @IBOutlet var footerTitleLabel: UILabel!
    
    @IBOutlet var footerFirstSubtitleLabel: UILabel!
    @IBOutlet var footerSecondSubtitleLabel: UILabel!
    @IBOutlet var footerThirdSubtitleLabel: UILabel!
    
    @IBOutlet var daysAndHourLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    
    @IBOutlet var searchProductBar: UISearchBar!
    
    
    
    
    
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    var viewModel = HomeViewModel()
    
    var myString: String = "Hora de abraçar seu lado geek"
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        setupFonts()
        startViewModel()
        
    }
    
    func startViewModel(){
        viewModel.delegate = self
        viewModel.fetchCategories()
    }
    
    
    func setupTableView() {
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryTableViewCell")
        categoryTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productTableViewCell")
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        categoryTableView.estimatedRowHeight = 400
        categoryTableView.backgroundColor = .clear
    }
    
    func setupUI() {
        seeLessButton.isHidden = true
        subscribeButton.layer.cornerRadius = 24
        searchProductBar.delegate = self
    }
    
    func setupFonts() {
        titleNewsLabel.font = UIFont(name: "Orbitron-Black", size: 48)
        categoryTitleLabel.font = UIFont(name: "Orbitron-Regular", size: 25)
        subscribeTitleLabel.font = UIFont(name: "Orbitron-Bold", size: 16)
        
        
        var myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font :UIFont(name: "Orbitron-Black", size: 48.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 255/255, green: 85/255, blue: 223/255, alpha: 1.0), range: NSRange(location:0,length:19))
        titleNewsLabel.attributedText = myMutableString
        
        seeNewsButton.layer.cornerRadius = 24
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        fullHeightTableView()
        seeMoreButton.isHidden = true
        seeLessButton.isHidden = false
    }
    
    @IBAction func seeLessButtonTapped(_ sender: Any) {
        heightToCategoryTableView()
        seeMoreButton.isHidden = false
        seeLessButton.isHidden = true
    }
    
    func fetchCategoriesListEnd() {
        DispatchQueue.main.async {
            self.categoryTableView.reloadData()
            self.categoryTableView.isHidden = false
        }
    }
    
    func fetchProductsListEnd() {
        DispatchQueue.main.async {
            self.heightToCategoryTableView()
            self.categoryTableView.reloadData()
            self.categoryTableView.isHidden = false
        }
    }
    
    func fullHeightTableView() {
        tableViewHeight.constant = CGFloat((self.viewModel.productList.count * 376 + self.viewModel.categoryList.count * 336 + 100))
    }
    
    func heightToCategoryTableView() {
        self.tableViewHeight.constant = CGFloat(( self.viewModel.categoryList.count * 336))
    }
    
    func heightToSearchTableView() {
        tableViewHeight.constant = CGFloat((self.viewModel.searchproductList.count * 376 + self.viewModel.categoryList.count * 336 + 100))
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if viewModel.isSearching == false {
            seeMoreButton.isHidden = true
            viewModel.isSearching = true
            viewModel.searchproductList = viewModel.productList
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchProductBar.text = ""
        self.viewModel.searchproductList = []
        seeMoreButton.isHidden = false
        viewModel.isSearching = false
        self.searchProductBar.showsCancelButton = false
        self.searchProductBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.categoryTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == ""  {
            self.viewModel.searchproductList = viewModel.productList
            self.fullHeightTableView()
            self.categoryTableView.reloadData()
        } else {
            self.fullHeightTableView()
            self.viewModel.searchproductList = viewModel.productList.filter({ (character) -> Bool in
                return (character.nome.localizedCaseInsensitiveContains(String(searchBar.text!)))
            })
            self.categoryTableView.reloadData()
        }
    }
}

extension ViewController: HomeViewModelProtocol {
    func returnCategories() {
        fetchCategoriesListEnd()
        viewModel.fetchProducts()
    }
    
    func returnProducts() {
        fetchProductsListEnd()
    }
    
    func returnError() {
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.categoryList.count
        }
        
        
        if viewModel.isSearching {
            if viewModel.searchproductList.count > 0 {
                return viewModel.searchproductList.count
            }
        }
        
        return viewModel.productList.count
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Promos Especiais"
        label.font = UIFont(name: "Orbitron-Bold", size: 25)
        label.textAlignment = .center
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if viewModel.categoryList.count == 0 {
                return UITableViewCell()
            }
            
            
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            
            categoryCell.setupCell(imageUrl: viewModel.categoryList[indexPath.row].imagem, title: viewModel.categoryList[indexPath.row].nome )
            
            return categoryCell
        }
        
        
        if viewModel.productList.count == 0 || viewModel.productList.count == 0 {
            return UITableViewCell()
        }
        
        let productCell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell
        
        if viewModel.isSearching == true {
            
            productCell.setupCell(imageUrl: viewModel.searchproductList[indexPath.row].imagem, title: viewModel.searchproductList[indexPath.row].nome, price: "R$ \(viewModel.searchproductList[indexPath.row].preço)" )
            
            return productCell
        }
        
        
        productCell.setupCell(imageUrl: viewModel.productList[indexPath.row].imagem, title: viewModel.productList[indexPath.row].nome, price: "R$ \(viewModel.productList[indexPath.row].preço)" )
        
        return productCell
    }
    
    
}

