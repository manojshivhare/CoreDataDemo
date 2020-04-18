//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Manoj Shivhare on 02/04/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    // Properties
    var dataArr:[Octokit]?
    var pageNumber = 1
    let perPageCount = 10
    var isLoadingList : Bool = false
    
    var newDataArr:[OctokitModel]? {
        didSet {
            // Add the new spots to Core Data Context
            self.addNewDataToCoreData(self.newDataArr!)
            // Save them to Core Data
            CoreDataStore.saveContext()
            // Reload the tableView
            self.reloadTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.isHidden = true
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataArr = CoreDataStore.getAllDataFromStore()
        DispatchQueue.main.async {
            if self.dataArr?.count == 0 {
                self.getDataFromServer(pageNumber: self.pageNumber)
            }
            else
            {
                self.reloadTableView()
            }
        }
    }
    
    //MARK: TableView - Delegate method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataStore.getAllDataFromStore().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCellIdentifier") as! DataTableViewCell
        
        self.dataArr = CoreDataStore.getAllDataFromStore()
        if dataArr?.count != 0 {
            if let name = dataArr?[indexPath.row].name {
                cell.cellNameLabel?.text = name
            }
            
            if let descriptionInfo = dataArr?[indexPath.row].brief {
                cell.cellDescriptionLabel?.text = descriptionInfo
            }
            
            if let count = dataArr?[indexPath.row].openIssuesCount {
                cell.cellOpenIssuesCountLabel?.text = String(format: "Open issues:%d", count as CVarArg)
            }
        }
      
        return cell
    }
    
    //MARK: scrollview delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isLoadingList = false
    }
    
    //scrollview delegate method for pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((dataTableView.contentOffset.y + dataTableView.frame.size.height) >= dataTableView.contentSize.height)
        {
            if !isLoadingList{
                isLoadingList = true
                loadMoreData()
            }
        }
    }
    //reload table view
    func reloadTableView() {
        DispatchQueue.main.async {
            self.dataTableView.reloadData()
        }
    }
    
    //call function for pagination
    func loadMoreData() {
         self.isLoadingList = true
        pageNumber = pageNumber + 1
        getDataFromServer(pageNumber: pageNumber)
    }
    
    //call service and get data
    func getDataFromServer(pageNumber:Int) {
        print("Updating...")
        let urlPath = "https://api.github.com/orgs/octokit/repos?page=\(pageNumber)&per_page=\(perPageCount)"
        
        guard let url = URL(string: urlPath) else {return}
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in

            DispatchQueue.main.async {
                self.progressView.isHidden = true
                self.progressView.stopAnimating()
                guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    self.showAlertWith(title: "Alert!", message: error?.localizedDescription ?? "Response Error", style: .alert)
                    return
                }
                
                do {
                    self.isLoadingList = false
                    self.newDataArr = try JSONDecoder().decode([OctokitModel].self, from: dataResponse)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //call alert view function
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //add data into core data
    func addNewDataToCoreData(_ object: [OctokitModel]) {
        
        for Obj in object {
            let entity = NSEntityDescription.entity(forEntityName: "Octokit", in: CoreDataStore
                .getContext())
            let storeDic = NSManagedObject(entity: entity!, insertInto: CoreDataStore.getContext())
    
            // Set the data to the entity
            storeDic.setValue(Obj.name, forKey: "name")
            storeDic.setValue(Obj.description, forKey: "brief")
            storeDic.setValue(Obj.openIssuesCount, forKey: "openIssuesCount")
        }
        
    }
}
