//
//  OffersViewController.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 29/10/22.
//

import UIKit
import Foundation
import Kingfisher

class OffersViewController: BaseViewController {
    // MARK: IBOutlet connections
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var offerCountView: UIView!
    @IBOutlet weak var offerCountLabel: UILabel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var customSearchBar: UISearchBar!
    @IBOutlet weak var offersTableView: UITableView!
    
    // MARK: IBOutlet actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.searchBarView.isHidden = false
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.resetResults()
        self.searchBarView.isHidden = true
    }
    
    func prepareSegueForCustomImagePickerViewControllerSegue(segue: UIStoryboardSegue) {
        guard let offerDetailsViewController = segue.destination as? OfferDetailsViewController else {
            fatalError("OfferDetailsViewController not found")
        }
        
        offerDetailsViewController.offerId = self.selectedOfferId
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOfferDetailsScreen" {
            prepareSegueForCustomImagePickerViewControllerSegue(segue: segue)
        }
    }
    
    // MARK: Class props
    private let offersViewModel = OffersViewModel()
    private var offersDataList: [OffersSectionModel]?
    private var filteredOffersDataList = [OfferDetailsModel]()
    private var selectedOfferId = ""
    private var isSearching = false
    
    // MARK: Class methods
    private func setupView() {
        
        self.searchBarView.isHidden = true
        
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 1
        KingfisherManager.shared.cache.clearCache()
        
        self.offerCountLabel.text = ""
        
        //self.offersTableView.estimatedRowHeight = 140
        //self.offersTableView.rowHeight = UITableView.automaticDimension
        //self.offersTableView.estimatedSectionHeaderHeight = 60.00
        
        self.customSearchBar.delegate = self

        self.offersTableView.delegate = self
        self.offersTableView.dataSource = self
        
        self.performRequests()
    }
    
}

// MARK: Extensions

// MARK: OffersViewController extensions
extension OffersViewController {
    
    private func performRequests() {
        self.showLoader()
        
        self.offersViewModel.getOffers() { (offersResponseModel, succeded) in
            self.hideLoader()
            if succeded {
                self.offersDataList = offersResponseModel
                self.offersTableView.reloadData()
            }
            else {
                self.showAlert(message: "Something went wrong, please try again.")
            }
        }
    }
    
    private func searchForResults(searchString: String) -> [OfferDetailsModel] {
        var filteredOfferList = [OfferDetailsModel]()
        
        let lowercasedSearchString = searchString.lowercased()
        
        guard let sections = self.offersDataList else {
            return filteredOfferList
        }
        
        for (_, section) in sections.enumerated() {
            if let items = section.items {
                let filteredResults = items.filter {
                    ($0.brand?.lowercased().contains(lowercasedSearchString) ?? false) ||
                    ($0.title?.lowercased().contains(lowercasedSearchString) ?? false) ||
                    ($0.tags?.lowercased().contains(lowercasedSearchString) ?? false)
                }
                if filteredResults.count > 0 {
                    filteredOfferList += filteredResults
                }
            }
        }
        
        return filteredOfferList
    }
    
    private func searchAndRefreshResults(searchString: String) {
        self.filteredOffersDataList = self.searchForResults(searchString: searchString)
        self.offersTableView.reloadData()
    }
    
    private func resetResults() {
        self.isSearching = false
        self.customSearchBar.text = ""
        self.filteredOffersDataList = [OfferDetailsModel]()
        self.offersTableView.reloadData()
    }
    
    private func goToOfferDetailsScreen() {
        self.performSegue(withIdentifier: "goToOfferDetailsScreen", sender: nil)
    }
    
}

// MARK: UISearchBarDelegate extensions
extension OffersViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.isNavigationBarHidden = false
        self.searchBarView.isHidden = true
        self.resetResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchString = self.customSearchBar.text, searchString != "" else {
            self.resetResults()
            return
        }
        self.isSearching = true
        self.searchAndRefreshResults(searchString: searchString.trimmingCharacters(in: .whitespaces))
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource extensions
extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.isSearching ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isSearching {
            return nil
        }
        else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = headerView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            headerView.addSubview(blurEffectView)

            let headerTitleLabel = UILabel(frame: CGRect(x: 24, y: 0, width: 176, height: 29))
            headerTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
            if let offersData = self.offersDataList {
                headerTitleLabel.text = offersData[section].title ?? "Not available"
            }
            else {
                headerTitleLabel.text = "Not available"
            }

            headerView.addSubview(headerTitleLabel)

            return headerView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isSearching ? 1 : (self.offersDataList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ? self.filteredOffersDataList.count : (self.offersDataList?[section].items?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let customViewCell = tableView.dequeueReusableCell(withIdentifier: "offerTableViewCell", for: indexPath) as? OfferTableViewCell {
            if self.isSearching {
                customViewCell.configure(offerDetails: self.filteredOffersDataList[indexPath.row])
            }
            else {
                if let offersData = self.offersDataList {
                    if let items = offersData[indexPath.section].items {
                        customViewCell.configure(offerDetails: items[indexPath.row])
                    }
                }
            }
            cell = customViewCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let dataList = self.offersDataList, dataList.count > 0 else {
            return
        }
        
        guard let items = dataList[indexPath.section].items, items.count > 0 else {
            return
        }
        
        //The offer's id to get on detail's screen
        //self.selectedOfferId = items[indexPath.row].offerId ?? ""
        self.selectedOfferId = "\(Int.random(in: 1...4))"
        self.goToOfferDetailsScreen()
    }
    
}
