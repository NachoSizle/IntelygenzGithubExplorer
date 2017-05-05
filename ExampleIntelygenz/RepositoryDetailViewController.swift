//
//  RepositoryDetailViewController.swift
//  Example2
//
//  Created by Nacho Martinez on 4/5/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblRepoUrl: UILabel!
    @IBOutlet var lblCreatedAt: UILabel!
    @IBOutlet var lblStars: UILabel!
    @IBOutlet var lblWatchers: UILabel!
    @IBOutlet var lblForks: UILabel!
    @IBOutlet var txtViewDescription: UITextView!
    @IBOutlet var lblDescriptionTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let goToRepo = UITapGestureRecognizer(target: self, action: #selector(RepositoryDetailViewController.goToRepo))
        lblRepoUrl.addGestureRecognizer(goToRepo)
    }
    
    
    func goToRepo(){
        let urlRepo = URL(string: lblRepoUrl.text!)
        UIApplication.shared.open(urlRepo!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
