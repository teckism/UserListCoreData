//
//  UsersListViewController.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 08/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController,UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableViewForListing: UITableView!
    @IBOutlet weak var viewForNoInternetConnection: UIView!
    @IBOutlet weak var labelForTopMessage : UILabel!
    @IBOutlet weak var topMessageHeightConstraint: NSLayoutConstraint!
    
    var dataCtlr : UsersListDataController?
    
    private var enableToast = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataCtlr == nil {
            self.dataCtlr = UsersListDataController()
        }
        
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil);
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        
        self.dataCtlr?.performOfflineDataFetch()
        
        self.tableViewForListing.tableFooterView = UIView()
        
        registerNibs()
        self.loadData()
        
    }
    
    func registerNibs(){
        let nib = UINib.init(nibName: "UserListItemTableViewCell", bundle: Bundle.main)
        
        self.tableViewForListing.register(nib, forCellReuseIdentifier: Constants.CellIdentifiers.kUserListItemCell)
        
    }
    
    @IBAction func clickedTryAgain(_ sender: Any) {
        self.loadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text
        {
            self.dataCtlr?.performFilter(searchText: searchText)
            DispatchQueue.main.async {
                self.tableViewForListing.reloadData()
            }
            
        }
        
    }
    
    
    func loadData(){
        if Reachability.isConnectedToNetwork() {
            self.dataCtlr?.getListOfUsers(onSuccess: {
                DispatchQueue.main.async {
                    self.tableViewForListing.reloadData()
                    self.tableViewForListing.isHidden = false
                    self.viewForNoInternetConnection.isHidden = true
                }
            }, onFailure: { (message) in
                
                //API Failure. Possibly coz of server issue.
                //Depending upon the contents available offline, the failure screen is shown
                
                if self.dataCtlr?.arrayOfUsersFiltered?.count ?? 0 > 0 {
                    //Showing toast from top(Instead of entire screen) to let user know about server issue
                    //The purpose of using a toast is to let user access the offline data meanwhile
                    self.showToast(message: message)
                }
                else{
                    //Since local storage doesn't contain any data showing user full screen Unable to reach server with retry option
                    
                }
                
            })
        }
        else{
            if self.dataCtlr?.arrayOfUsersFiltered?.count ?? 0 > 0 {
                //Showing toast from top(Instead of entire screen) to let user know about net connectivity
                //The purpose of using a toast is to let user access the offline data meanwhile
                self.showToast(message: Constants.Alerts.kNoInternetConnection)
            }
            else{
                //Since local storage doesn't contain any data showing user full screen No Internet connection
                
                
                self.tableViewForListing.isHidden = true
                self.viewForNoInternetConnection.isHidden = false
                
                
            }
        }
        
    }
    
    
    private func showToast(message : String){
        self.labelForTopMessage.text = message
        
        
        if(self.enableToast == true ){
            self.enableToast = false
            self.labelForTopMessage.text = message
            self.view.layoutIfNeeded();
            self.topMessageHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                self.view.layoutIfNeeded()
                
                self.topMessageHeightConstraint.constant = -35 - (self.tabBarController?.tabBar.frame.size.height ?? 0)
                
                UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (compl) in
                    self.enableToast = true
                })
            })
        }
    }
    
}

extension UsersListViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataCtlr?.arrayOfUsersFiltered?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.kUserListItemCell) as? UserListItemTableViewCell {
            
            if let user = self.dataCtlr?.arrayOfUsersFiltered?[indexPath.row] {
                cell.loadUser(user : user)
                cell.selectionStyle = .none
                return cell
            }
            else{
                return UITableViewCell()
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil,
                                        handler: { (action, view, completionHandler) in
                                            
        })
        
        action.image = Constants.Images.imageForTick
        action.backgroundColor = Constants.Colors.kSaveColor
        
        
        let actionForRemove = UIContextualAction(style: .normal, title: nil,
                                                 handler: { (action, view, completionHandler) in
                                                    
        })
        
        actionForRemove.image = Constants.Images.imageForCross
        actionForRemove.backgroundColor = Constants.Colors.kRemoveColor
        
        let configuration = UISwipeActionsConfiguration(actions: [actionForRemove, action])
        return configuration
    }
}
