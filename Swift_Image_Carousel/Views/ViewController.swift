//
//  ViewController.swift
//  Swift_Image_Carousel
//
//  Created by apple on 12/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var carouselCollection:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblListvw: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var floatingActionButton: UIButton!
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    var images = ["1","2","3","4","5"]
    
    var arrTblVW = [["Apple","Good Fruit in Red Color","a"],["Banana","Good Fruit in yellow Color","b"],["Rose","Good flower in Red Color","c"],["Cherry","Good Fruit in pink Color","d"],["Papaya","Good Fruit in yellowish Color","e"],["Orange","Good Fruit in Orange Color","f"],["Black Berry","Good Fruit in Black Color","a"],["Strawberry","Good Fruit in pink Color","b"],["Mango","Good Fruit in yellow Color","c"],["Tomato","Good Fruit in Red Color","d"]]
    
    var arrImg = ["a","b","c","d","e","f","a","b","c","d","e","f","a","b","c","d","e","f"]
    var isfilter:Bool = false
    var arrFilter:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.isScrollEnabled = true
        scrollView.contentInset = .zero
        
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        
        self.setCollectionView()
        self.setPageControl()
        self.setListVW()
        self.setupFloatingButton()
    }
    
    func setListVW(){
        let nib = UINib(nibName: "ListTVC", bundle: nil)
        tblListvw.register(nib, forCellReuseIdentifier: "ListTVC")
        tblListvw.reloadData()
    }

    func setCollectionView(){
        let nib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        carouselCollection.register(nib, forCellWithReuseIdentifier: "ImageCollectionCell")
        carouselCollection.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Set the scroll direction
        layout.minimumLineSpacing = 0 // Optional: Adjust as needed
        layout.minimumInteritemSpacing = 0
        // Set the layout to the collection view
        carouselCollection.collectionViewLayout = layout
        carouselCollection.layer.cornerRadius = 20
        carouselCollection.reloadData()
    }
    
    func setPageControl(){
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = images.count
    }
    
    func filterArray(_ array: [[String]], searchText: String) -> [[String]] {
        return array.filter { $0[0].localizedCaseInsensitiveContains(searchText) }
    }
    
    func setupFloatingButton() {
        
        // Make the button circular
            floatingActionButton.layer.cornerRadius = floatingActionButton.frame.size.width / 2
            
            // Add shadow for a floating effect
            floatingActionButton.layer.shadowColor = UIColor.black.cgColor
            floatingActionButton.layer.shadowOpacity = 0.3
            floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 3)
            floatingActionButton.layer.shadowRadius = 5
            
            // Set background color
            floatingActionButton.backgroundColor = UIColor.systemBlue
            
            // Optional: Set an image for the button
            floatingActionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            floatingActionButton.tintColor = .white
        
    }
    
    @IBAction func floatingButtonTapped(_ sender: UIButton) {
        // Show bottom sheet dialog
        presentBottomSheet()
    }
    
    func presentBottomSheet() {
        // Example list
        var list:[String] = []
        for values in arrTblVW {
            list.append(values[0].lowercased())
        }
        print(list)

        // Calculate statistics
        let statistics = calculateStatistics(for: list)

        // Load the bottom sheet
        if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "CalculateVC") as? CalculateVC {
            bottomSheetVC.statisticsText = statistics

            // Set presentation style for bottom sheet
            bottomSheetVC.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()] // Adjust height as needed
            }
            
            present(bottomSheetVC, animated: true)
        }
    }
    
    func calculateStatistics(for list: [String]) -> String {
        // Count total items
        let totalItems = list.count

        // Count character occurrences
        var charCounts = [Character: Int]()
        list.forEach { word in
            word.forEach { char in
                charCounts[char, default: 0] += 1
            }
        }
        print(charCounts)

        // Get top 3 characters
        let top3 = charCounts.sorted { $0.value > $1.value }.prefix(3)
        
        print(top3)

        // Build the result string
        var result = "List (\(totalItems) items)\n"
        top3.forEach { char, count in
            result += "\(char) = \(count)\n"
        }

        return result
    }


}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - UICollectionViewDataSource
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell:ImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            
            // Configure the image
            cell.imgvw.image = UIImage(named: images[indexPath.item])
            cell.imgvw.contentMode = .scaleAspectFill
            cell.imgvw.clipsToBounds = true
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //return collectionView.bounds.size
            return collectionView.frame.size
            //return CGSize(width: 320, height: 150)
        }
        
        // MARK: - UIScrollViewDelegate
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//    }
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == carouselCollection {
                let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
                pageControl.currentPage = Int(pageIndex)
            } else if scrollView == self.scrollView {
                let screenHeight = UIScreen.main.bounds.height
                
//                let tblHeight = CGFloat(arrFilter.count * 50)
//                if screenHeight > tblHeight {
//                    var height = screenHeight + (screenHeight - tblHeight)
//                    tblConstraint.constant = CGFloat(height)
//                } else {
//                    var height = screenHeight + (tblHeight - screenHeight)
//                    tblConstraint.constant = CGFloat(height)
//                }
                
                
                let maxScrollHeight: CGFloat =  screenHeight * 0.15
                if scrollView.contentOffset.y < -maxScrollHeight {
                    scrollView.contentOffset = CGPoint(x: 0, y: -maxScrollHeight)
                }
            }
        }
    
}

extension ViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            isfilter = false
            tblListvw.reloadData()
        } else {
            // Filter items based on the search text
            //filteredItems = allItems.filter { $0.lowercased().contains(searchText.lowercased()) }
            isfilter = true
            arrFilter = filterArray(arrTblVW, searchText: searchText)
            print(arrFilter)
            tblListvw.reloadData()
        }
    }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // Dismiss the keyboard when the search button is clicked
            searchBar.resignFirstResponder()
        }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isfilter == true {
            
            return arrFilter.count
            
        } else {
            return arrTblVW.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ListTVC = tableView.dequeueReusableCell(withIdentifier: "ListTVC") as! ListTVC
        
        if isfilter == true {
            
            cell.imgVW.image = UIImage(named: arrTblVW[indexPath.row][2])
            cell.lbltitle.text = arrFilter[indexPath.row][0]
            cell.lbldesc.text = arrFilter[indexPath.row][1]
            
        } else {
            
            cell.imgVW.image = UIImage(named: arrTblVW[indexPath.row][2])
            cell.lbltitle.text = arrTblVW[indexPath.row][0]
            cell.lbldesc.text = arrTblVW[indexPath.row][1]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        //UITableView.automaticDimension
    }
    
    
}


