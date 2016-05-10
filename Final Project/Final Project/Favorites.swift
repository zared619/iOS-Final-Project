//
//  Favorites.swift
//  Final Project
//
//  Created by Andrew Pier on 5/2/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

var ids: [String] = []
class FavRepo: NSObject {
    dynamic var setArr:[BeerSet] = []
    dynamic var downloadFinished = false
    static let singleton = FavRepo()
    
    
}

class Favorites: UITableViewController {

    var beerInfo: [BeerSet] = []
    let fileManager = NSFileManager.defaultManager()
    
    var s = ""
        var current = 0
        
        var filteredData:[String]!
        var searchActive: Bool = false
        var filtered: [BeerSet] = []
        @IBOutlet weak var searchBar: UISearchBar!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //FavRepo.singleton.setArr = []
            // Do any additional setup after loading the view, typically from a nib.
            //loadInfo()
            //print(ids)
            FavRepo.singleton.addObserver(self, forKeyPath: "setArr", options: .New, context: nil)
           // print(FavRepo.singleton.setArr.count)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
        }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //FavRepo.singleton.setArr.sortInPlace(){ $0.name > $1.name }
        //FavRepo.singleton.setArr = FavRepo.singleton.setArr.reverse()
        self.tableView.reloadData()
    }
   
    //var data = NSData()
    func loadInfo(){
        
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let path = documents.URLByAppendingPathComponent("faves.txt").path!

        
        //let str:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        
        //let newPath = str.stringByAppendingPathComponent("faves.txt")
        
        //let path = NSBundle.mainBundle().pathForResource(strs as String, ofType: "txt")
        var data = String()
        
        if fileManager.isReadableFileAtPath(path){
            do{
                data = try String(contentsOfFile: path)
                for character in data.characters {
                    if(character == "," ){
                        ids.append(s)
                        print(ids)
                        s = ""
                    }else{
                        if character == "\n" {
                        
                        }else{
                            s.append(character)
                        }
                    }
                }
            }catch{
                print("error")
            }
        }
    }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
            print(FavRepo.singleton.setArr.count)
           
            return FavRepo.singleton.setArr.count
            
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("cells") as! BevCell!
            //let set = BeerRepository.singleton.setArr[indexPath.row]
           // print(FavRepo.singleton.setArr[indexPath.row].name)
            cell.beverageName.text = FavRepo.singleton.setArr[indexPath.row].name;
            
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
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let destVC = segue.destinationViewController as! MoreDetails
            destVC.beer = FavRepo.singleton.setArr[current]
            destVC.visit = true
            
        }
        
    }


