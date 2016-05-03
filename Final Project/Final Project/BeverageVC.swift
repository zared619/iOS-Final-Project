//  Created by Zared Hollabaugh on 4/21/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

class BeerSet: NSObject {
    var name: String = ""
    var id: String = ""
    var descript: String = ""
    
}

class BeerRepository: NSObject, NSURLSessionDownloadDelegate {
    var setArr:[BeerSet] = []
    
    dynamic var downloadFinished = false
    static let singleton = BeerRepository()
    
    private override init(){
        super.init()
        var i: Double = 3.0
        while(i<5){
            let str = "https://api.brewerydb.com/v2/beers?abv=" + String(i) + "," + String(i+0.05) + "&key=56f87afec88cd03f19d9bfa6fa67f16b&format=json"
            makeAPICall(str)
            i+=0.05
        }
    }
    
    func makeAPICall(str:String){
        let url = NSURL(string: str)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let dtask = session.downloadTaskWithURL(url!)
        
        dtask.resume()
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        
    }
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
        
    }

    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do{
            let myData = NSData(contentsOfURL: location)
            let myDict = try NSJSONSerialization.JSONObjectWithData(myData!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
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

class MainViewController: UITableViewController, UISearchBarDelegate{
    
    var current = 0
    
    var filteredData:[String]!
    var searchActive: Bool = false
    var filtered: [BeerSet] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BeerRepository.singleton.addObserver(self, forKeyPath: "downloadFinished", options: .New, context: nil)
        
        searchBar.delegate = self
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        BeerRepository.singleton.setArr.sortInPlace(){ $0.name > $1.name }
        BeerRepository.singleton.setArr = BeerRepository.singleton.setArr.reverse()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        print(BeerRepository.singleton.setArr.count)
        if(searchActive) {
            return filtered.count
        }
        return BeerRepository.singleton.setArr.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! BevCell!
        //let set = BeerRepository.singleton.setArr[indexPath.row]
        if(searchActive){
            cell.beverageName.text = filtered[indexPath.row].name
        } else {
            cell.beverageName.text = BeerRepository.singleton.setArr[indexPath.row].name;
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
        self.tableView.reloadData()
    }

    override func scrollViewDidScroll(scrollView: UIScrollView){
        let tableBounds = self.tableView.bounds;
        let searchBarFrame = self.searchBar.frame;
        
        // make sure the search bar stays at the table's original x and y as the content moves
        self.searchBar.frame = CGRectMake(tableBounds.origin.x,
                                          tableBounds.origin.y,
                                          searchBarFrame.size.width,
                                          searchBarFrame.size.height
        )
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! UINavigationController
        let date = destVC.childViewControllers[0] as! MoreDetails
        if(searchActive) {
            date.beer = filtered[current]
        }
        date.beer = BeerRepository.singleton.setArr[current]
       
    }
    
}
