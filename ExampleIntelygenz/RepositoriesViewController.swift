//
//  ViewController.swift
//  Example2
//
//  Created by Nacho Martinez on 4/5/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIViewControllerPreviewingDelegate { //UITableViewController
    @IBOutlet var repositories: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var repositoriesCollection: [Repositories] = []
    var urlConnectionGitHub: String = "https://api.github.com/"
    var repositoriesArray: NSArray = []
    var cellSelectedToPeek: CGPoint = CGPoint()
    var formatterDate: DateFormatter = {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd-MM-yyyy"
        return dateForm
    } ()
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if self.repositoriesCollection.count == 0 {
            return nil
        }

        let peekController = storyboard?.instantiateViewController(withIdentifier: "RepositoriesDetailView") as? RepositoryDetailViewController
        
        let indexSelectedRow = self.repositories.indexPathForRow(at: location)
        let repoSelected = repositoriesCollection[(indexSelectedRow?.row)!]
        
        cellSelectedToPeek = location
        
        peekController?.navigationItem.title = repoSelected.nameRepo
        
        let indexDate = repoSelected.createdAt.index(repoSelected.createdAt.startIndex, offsetBy: 10)
        let updateDateSplit = repoSelected.createdAt.substring(to: indexDate)
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        
        let updateFormat = dateForm.date(from: updateDateSplit)
        
        DispatchQueue.main.async(){
            peekController?.navigationItem.title = repoSelected.nameRepo
            
            peekController?.lblCreatedBy.text = repoSelected.nameAuthor
            peekController?.lblCreatedAt.text = self.formatterDate.string(for: updateFormat)
            peekController?.lblRepoUrl.text = repoSelected.repoUrl
            peekController?.lblWatchers.text = repoSelected.watchers
            peekController?.lblForks.text = repoSelected.forks
            peekController?.lblStars.text = repoSelected.stars
            if repoSelected.descRepo == "" {
                peekController?.lblDescriptionTitle.text = ""
            }
            peekController?.txtViewDescription.text = repoSelected.descRepo
        }
    
        return peekController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let popController = storyboard?.instantiateViewController(withIdentifier: "RepositoriesDetailView") as? RepositoryDetailViewController
        
        let indexSelectedRow = self.repositories.indexPathForRow(at: cellSelectedToPeek)
        let repoSelected = repositoriesCollection[(indexSelectedRow?.row)!]
        
        let indexDate = repoSelected.createdAt.index(repoSelected.createdAt.startIndex, offsetBy: 10)
        let updateDateSplit = repoSelected.createdAt.substring(to: indexDate)
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        
        let updateFormat = dateForm.date(from: updateDateSplit)
        
        DispatchQueue.main.async(){
            popController?.navigationItem.title = repoSelected.nameRepo
            
            popController?.lblCreatedBy.text = repoSelected.nameAuthor
            popController?.lblCreatedAt.text = self.formatterDate.string(for: updateFormat)
            popController?.lblRepoUrl.text = repoSelected.repoUrl
            popController?.lblWatchers.text = repoSelected.watchers
            popController?.lblForks.text = repoSelected.forks
            popController?.lblStars.text = repoSelected.stars
            if repoSelected.descRepo == "" {
                popController?.lblDescriptionTitle.text = ""
            }
            popController?.txtViewDescription.text = repoSelected.descRepo

        }
        
        show(popController!, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        repositories.delegate = self
        repositories.dataSource = self
        
        let iconGithubTitle = UIImage.init(icon: .FAGithub, size: CGSize(width: 50, height: 50))
        let imageViewFromIcon = UIImageView(image: iconGithubTitle)
        navigationItem.titleView = imageViewFromIcon
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: repositories)
        } else {
            print("Not compatible with 3dTouch")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    func getRepositories(nameToSearch: String) -> Int{
        let url = URL(string: urlConnectionGitHub + "search/repositories?q=" + nameToSearch)
        let urlReq = URLRequest(url: url!)
        print(urlReq)
        
        let task = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            
            if error != nil {
                print(error ?? "Error")
                return
            }
            
            do{
                let jsonArr = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if jsonArr.value(forKey: "items") != nil {
                    self.repositoriesArray = jsonArr.value(forKey: "items") as! NSArray
                    
                    
                    print("Repositories Array count")
                    print(self.repositoriesArray.count)
                    
                    self.parseResultsFromRepos()
                }
            } catch let jsonError {
                print(jsonError)
            }
            
        }
        
        task.resume()
        
        return self.repositoriesArray.count
    }
    
    func parseResultsFromRepos(){
        for dictionaryResult in self.repositoriesArray as! [[String: AnyObject]] {
            let nameRepo = dictionaryResult["name"]! as! String
            let createdAt = dictionaryResult["created_at"] as! String
            let repoUrl = dictionaryResult["svn_url"] as! String
            let watchers = dictionaryResult["watchers"] as! NSNumber
            let forks = dictionaryResult["forks"] as! NSNumber
            let stars = dictionaryResult["stargazers_count"] as! NSNumber
            let updateDate = dictionaryResult["updated_at"] as! String
            
            let indexDate = updateDate.index(updateDate.startIndex, offsetBy: 10)
            let updateDateSplit = updateDate.substring(to: indexDate)
            
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd"
            
            let updateFormat = dateForm.date(from: updateDateSplit)
            
            var descriptionRepo = ""
            if let description = dictionaryResult["description"] {
                if description as? String != nil {
                    descriptionRepo = description as! String
                } else {
                    descriptionRepo = ""
                }
            } else {
                descriptionRepo = ""
            }
            
            let ownerDictionary = dictionaryResult["owner"]! as! [String: AnyObject]
            let nameAuthor = ownerDictionary["login"] as! String
            
            let repository = Repositories(nameRepo: nameRepo, nameAuthor: nameAuthor, createdAt: createdAt, repoUrl: repoUrl, watchers: watchers.stringValue, forks: forks.stringValue, stars: stars.stringValue, description: descriptionRepo, updateDate: updateFormat!)
            
            
            DispatchQueue.main.async(){
                self.repositoriesCollection.append(repository)
                self.repositories.reloadData()
            }
    
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.repositoriesCollection.removeAll()
        let textToFound = searchBar.text!
        
        if textToFound != "" {
            let numRepos = getRepositories(nameToSearch: textToFound)
            if numRepos != 0 {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoriesCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let repo = self.repositoriesCollection[indexPath.row]
        let cellID = "reposCell"
        
        let cell = self.repositories.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RepositoriesTableViewCell
        
        cell.nameRepo?.text = repo.nameRepo
        cell.nameAuthor?.text = repo.nameAuthor
        cell.updateDate?.text = formatterDate.string(from: repo.updateDate)
        
        let numStars = Int(repo.stars)
        if numStars! > 0{
            cell.imgStars.image = UIImage.init(icon: .FAStar, size: CGSize(width: 60, height: 60), textColor: .yellow, backgroundColor: UIColor(red: 239, green: 236, blue: 51, alpha: 1.0))
        } else {
            cell.imgStars.image = UIImage.init(icon: .FAStar, size: CGSize(width: 60, height: 60))
        }
        
        cell.numStars?.text = repo.stars
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexSelectedRow = self.repositories.indexPathForSelectedRow
        let cellSelect = self.repositories.cellForRow(at: indexSelectedRow!) as! RepositoriesTableViewCell
        
        cellSelect.setSelected(false, animated: false)
        
        let repoSelected = repositoriesCollection[(indexSelectedRow?.row)!]
        
        let indexDate = repoSelected.createdAt.index(repoSelected.createdAt.startIndex, offsetBy: 10)
        let updateDateSplit = repoSelected.createdAt.substring(to: indexDate)
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        
        let updateFormat = dateForm.date(from: updateDateSplit)
        
        let destination = segue.destination
        if destination.view != nil {
            (destination as! RepositoryDetailViewController).navigationItem.title = repoSelected.nameRepo
            
            (destination as! RepositoryDetailViewController).lblCreatedBy.text = repoSelected.nameAuthor
            (destination as! RepositoryDetailViewController).lblCreatedAt.text = self.formatterDate.string(for: updateFormat)
            (destination as! RepositoryDetailViewController).lblRepoUrl.text = repoSelected.repoUrl
            (destination as! RepositoryDetailViewController).lblWatchers.text = repoSelected.watchers
            (destination as! RepositoryDetailViewController).lblForks.text = repoSelected.forks
            (destination as! RepositoryDetailViewController).lblStars.text = repoSelected.stars
            if repoSelected.descRepo == "" {
                (destination as! RepositoryDetailViewController).lblDescriptionTitle.text = ""
            }
            (destination as! RepositoryDetailViewController).txtViewDescription.text = repoSelected.descRepo
        }
        
     }
}
