//
//  Beverage.swift
//  Final Project
//
//  Created by Andrew Pier on 4/28/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

class ViewControlle: UIViewController, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var current = 0
    
    var filteredData:[String]!
    var searchActive: Bool = false
    var filtered: [BeerSet] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cell:UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BeerRepository.singleton.addObserver(self, forKeyPath: "downloadFinished", options: .New, context: nil)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        BeerRepository.singleton.setArr.sortInPlace(){ $0.name > $1.name }
        BeerRepository.singleton.setArr = BeerRepository.singleton.setArr.reverse()
        tableView.reloadData()
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        print(BeerRepository.singleton.setArr.count)
        if(searchActive) {
            return filtered.count
        }
        return BeerRepository.singleton.setArr.count
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cells = tableView.dequeueReusableCellWithIdentifier("cell") as! BevCell!
        //let set = BeerRepository.singleton.setArr[indexPath.row]
        if(searchActive){
            cells.beverageName.text = filtered[indexPath.row].name
        } else {
            cells.beverageName.text = BeerRepository.singleton.setArr[indexPath.row].name;
        }
        //cell.beverageName.text = set.name
        return cells
    }
    
     func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        current = indexPath.row
        return indexPath
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = BeerRepository.singleton.setArr.filter({ (text) -> Bool in
            let tmp: NSString = text.name
            //print(searchText)
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        //  print(filtered.count)
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
}
