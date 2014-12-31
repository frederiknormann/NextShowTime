//
//  RecipesViewController.swift
//  Kogeri Tid
//
//  Created by Jannie Henriksen on 10/12/14.
//  Copyright (c) 2014 Normann Development. All rights reserved.
//

import UIKit

class RecipesViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RecipeTableViewCell = tableView.dequeueReusableCellWithIdentifier("recipeCell") as RecipeTableViewCell
        cell.recipeNameLabel.text = "Hindbær"
        cell.typeLabel.text = "Rock"
        
        return UITableViewCell()
        
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}
