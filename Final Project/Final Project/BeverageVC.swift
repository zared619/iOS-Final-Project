//  Created by Zared Hollabaugh on 4/21/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

class BeerSet {
    var name: String = ""
}

class BeerRepository: NSObject, NSURLSessionDownloadDelegate {
    var setArr:[BeerSet] = []
    dynamic var downloadFinished = false
    static let singleton = BeerRepository()
    
    private override init(){
        super.init()
        let url = NSURL(string: "https://api.brewerydb.com/v2/beers?abv=-13&key=d6d3ba48e44a407ef82c7d9a20f7fcc7&format=json")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let dtask = session.downloadTaskWithURL(url!)
        
        dtask.resume()
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do{
            let myData = NSData(contentsOfURL: location)
            let myDict = try NSJSONSerialization.JSONObjectWithData(myData!, options: NSJSONReadingOptions.MutableContainers) as! Array<Dictionary<String, AnyObject>>
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                for set in myDict {
                    let beerset = BeerSet()
                    for (k,v) in set {
                        if k == "name"{
                            beerset.name = v as! String
                        }
                    }
                    self.setArr.append(beerset)
                }
                self.downloadFinished = true
                
            })
            
        }catch{
            NSLog("Error")
        }
    }
}

class MainViewController: UITableViewController{
    
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BeerRepository.singleton.addObserver(self, forKeyPath: "downloadFinished", options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return BeerRepository.singleton.setArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! BevCell!
        let set = BeerRepository.singleton.setArr[indexPath.row]
        cell.beverageName.text = set.name
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "mySegue"){
//            let dest = segue.destinationViewController as! setDisplayVC
//            dest.url = NetRepository.singleton.setArr[current].url
//            dest.number = NetRepository.singleton.setArr[current].number
//            dest.cycle = NetRepository.singleton.setArr[current].cycleNumber
//        }
//    }
    
}
