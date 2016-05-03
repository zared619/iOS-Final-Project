//
//  Favorites.swift
//  Final Project
//
//  Created by Andrew Pier on 5/2/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

var ids: [String] = []
class FavRepo: NSObject, NSURLSessionDownloadDelegate {
    var setArr:[BeerSet] = []
    
    dynamic var downloadFinished = false
    static let singleton = FavRepo()
    
    private override init(){
        super.init()
        //var i: Double = 3.0
        for i in ids{
            let str = "https://api.brewerydb.com/v2/beers?ids=" + i + "&key=56f87afec88cd03f19d9bfa6fa67f16b&format=json"
            makeAPICall(str)
        }
    }
    
    func makeAPICall(str:String){
        let url = NSURL(string: str)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let dtask = session.downloadTaskWithURL(url!)
        
        dtask.resume()
    }

    
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do{
            let myData = NSData(contentsOfURL: location)
            let myDict = try NSJSONSerialization.JSONObjectWithData(myData!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
            print(myData)
            if let beerData = myDict["data"] as? Array<Dictionary<String, AnyObject>>{
                //print(myDict["data"])
                //let beerData =
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    for set in beerData {
                        let beerset = BeerSet()
                        for (k,v) in set{
                            if k == "id" {
                                beerset.id = v as! String
                            }
                            
                            if k == "name" {
                                beerset.name = v as! String
                            }
                            if k == "description" {
                                beerset.descript = v as! String
                            }
                        }
                        self.setArr.append(beerset)
                    }
                    self.downloadFinished = true
                    
                })
            }
            
            
        }catch{
            NSLog("Error")
        }
    }
}

class Favorites: UITableViewController {

    var beerInfo: [BeerSet] = []
        var current = 0
        
        var filteredData:[String]!
        var searchActive: Bool = false
        var filtered: [BeerSet] = []
        @IBOutlet weak var searchBar: UISearchBar!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            loadInfo()
            print(ids)
            FavRepo.singleton.addObserver(self, forKeyPath: "downloadFinished", options: .New, context: nil)
            

            
        }
    let fileManager = NSFileManager.defaultManager()
    
    var s = ""
    //var data = NSData()
    func loadInfo(){
        let str:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        
        let newPath = str.stringByAppendingPathComponent("faves.txt")
        
        //let path = NSBundle.mainBundle().pathForResource(strs as String, ofType: "txt")
        var data = String()
        
        if fileManager.isReadableFileAtPath(newPath){
            do{
                data = try String(contentsOfFile: newPath)
                for character in data.characters {
                    if(character == "," || character == "\n"){
                        ids.append(s)
                        s = ""
                    }else{
                        s.append(character)
                    }
                }
            }catch{
                print("error")
            }
        }
    }

        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            FavRepo.singleton.setArr.sortInPlace(){ $0.name > $1.name }
            FavRepo.singleton.setArr = FavRepo.singleton.setArr.reverse()
            self.tableView.reloadData()
        }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
            print(FavRepo.singleton.setArr.count)
            if(searchActive) {
                return filtered.count
            }
            return FavRepo.singleton.setArr.count
            
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! BevCell!
            //let set = BeerRepository.singleton.setArr[indexPath.row]
            if(searchActive){
                cell.beverageName.text = filtered[indexPath.row].name
            } else {
                cell.beverageName.text = FavRepo.singleton.setArr[indexPath.row].name;
            }
            //cell.beverageName.text = set.name
            return cell
        }
        
        override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
            current = indexPath.row
            return indexPath
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            
            filtered = FavRepo.singleton.setArr.filter({ (text) -> Bool in
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
            self.tableView.reloadData()
        }
        
  
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let destVC = segue.destinationViewController as! MoreDetails
            if(searchActive) {
                destVC.beer = filtered[current]
            }
            destVC.beer = FavRepo.singleton.setArr[current]
            
        }
        
    }


