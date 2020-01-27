//
//  UserListViewController.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 25/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
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
        
        self.tableView.accessibilityLabel = "TagListTableView"
        self.tableView.isAccessibilityElement = true
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UserListViewCell.self, forCellReuseIdentifier: "UserListViewCell")
    }
    
    func fetchUsers(){
        activityStartAnimating()
        viewModel.getUserList(completionHandler: {[weak self] result in
            self?.activityStopAnimating()
            switch(result){
            case .success( _):
                self?.tableView.reloadData()
            case .failure(let error):
                debugPrint(error.message)
                self?.showError(error: error)
            }
        })
    }
    
    func showError(error:APIError){
        _ = self.showAlert(withTitle: "Error", message: error.message)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
       if segue.identifier == "GithubUserPageSegue"{
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.userCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListViewCell", for: indexPath) as? UserListViewCell else{
            fatalError("No cell found")
        }

        // Configure the cell...
        
        let user = viewModel.userAt(index: indexPath)
        
        cell.user = user
        cell.isFavorite = viewModel.isFavorite(userId: user.id)
        cell.delegate = self
        
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
        performSegue(withIdentifier: "GithubUserPageSegue", sender: user)
    }
    
    /// Estimated height for tableview row cell
    ///
    /// - Parameters:
    ///   - tableView: UITableView object
    ///   - indexPath: indexPath of the cell
    /// - Returns: CGFloat value representing the estimated height of the cell
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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
        if let indexPath = self.tableView.indexPath(for: userListViewCell) {
            _ = self.showAlert(withTitle: "Success", message: "Added to favorites", completionHandler: {
                self.viewModel.changeFavoriteStatus(userId: userId)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
    }
}

