//
//  UserListViewController.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 25/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
    var alert : UIAlertController?

    let viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupTableView()
        fetchUsers()
    }
    
    /// Setup Table View properties
    func setupTableView(){
        
        self.tableView.accessibilityLabel = "UserListTableView"
        self.tableView.isAccessibilityElement = true
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UserListViewCell.self, forCellReuseIdentifier: AppIdentifierStrings.kUserListViewCellReuseIdentifier)
    }
    
    func fetchUsers(){
        activityStartAnimating()
        viewModel.getUserList(completionHandler: {[weak self] result in
            switch(result){
            case .success( _):
                self?.reloadTableView()
            case .failure(let error):
                debugPrint(error.message)
                self?.setError(error: error)
            }
        })
    }
    
    /// Reload data after successful API request
    func reloadTableView() {
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    /// Error received from API request
    ///
    /// - Parameter error: APIError
    func setError(error:APIError){
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            self.alert = self.showAlert(withTitle: "Error", message: error.message)
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
        if segue.identifier == AppSegueIdentifierStrings.kGithubUserPageSegue {
           if let githubWebViewController = segue.destination as? GithubWebViewController, let user = sender as? User {
               githubWebViewController.setUpWith(user: user)
           }
       }
    }

}

extension UserListViewController{
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRows(inSection: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppIdentifierStrings.kUserListViewCellReuseIdentifier, for: indexPath) as? UserListViewCell else{
            fatalError("No cell found")
        }

        // Configure the cell...
        
        let user = viewModel.userAt(index: indexPath)
        
        cell.user = user
        cell.isFavorite = viewModel.isFavorite(userId: user.id)
        cell.delegate = self
        cell.isAccessibilityElement = true

        return cell
    }
    
    /// TableView Delegate method for height of the cell
    ///
    /// - Parameters:
    ///   - tableView: UITableView object
    ///   - indexPath: indexPath of the cell
    /// - Returns: Automatic height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Tableview did select cell action
    ///
    /// - Parameters:
    ///   - tableView: UITableView object
    ///   - indexPath: indexPath of the cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.userAt(index: indexPath)
        performSegue(withIdentifier: AppSegueIdentifierStrings.kGithubUserPageSegue, sender: user)
    }
    
    /// Estimated height for tableview row cell
    ///
    /// - Parameters:
    ///   - tableView: UITableView object
    ///   - indexPath: indexPath of the cell
    /// - Returns: CGFloat value representing the estimated height of the cell
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            fetchUsers()
        }
    }
}

extension UserListViewController : UserListViewCellDelegate {
    func userListViewCell(_ userListViewCell: UserListViewCell, favoriteButtonTapped userId: Int) {
        // show alert
        if let indexPath = self.tableView.indexPathForRow(at: userListViewCell.center){
            let isFavorited = self.viewModel.addFavoriteStatus(userId: userId)
            DispatchQueue.main.async() { () -> Void in
                if isFavorited == true {
                    self.alert = self.showAlert(withTitle: "Success", message: "Added to favorites", completionHandler: {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    })
                } else{
                    self.alert = self.showAlert(withTitle: "Success", message: "Removed to favorites", completionHandler: {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    })
                }
            }
        }
    }
}

