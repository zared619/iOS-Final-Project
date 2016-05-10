//
//  MoreDetails.swift
//  Final Project
//
//  Created by Andrew Pier on 4/30/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit
import Social

protocol Details{
    func childDone(vc: MoreDetails)
}

class MoreDetails: UIViewController {

    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var website: UIWebView?
    
    var beer: BeerSet?
    var delegate: Details!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if beer?.descript == "" {
            beer?.descript = "No description available"
        }
        label1?.text = beer?.descript
        name!.text = beer?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func Faves(sender: AnyObject) {
        delegate.childDone(self)
        
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let path = documents.URLByAppendingPathComponent("faves.txt").path!
        print(path)
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            let text = beer!.id + ",\n"
            outputStream.write(text,maxLength: 10)
            
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        
        
        /*let str : NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let path = str.stringByAppendingPathComponent("faves.txt")
        print(path)
        do{
            if let out = NSOutputStream(toFileAtPath: "faves.txt", append: true){
                let text = beer!.id + ",\n"
                out.write(text, maxLength: 100)
                out.close()
            }
            //let texts = ""
            //try texts.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            
            
        } catch{
            print("error")
        }*/
        print(FavRepo.singleton.setArr.count)
        FavRepo.singleton.setArr.append(beer!)
        print(FavRepo.singleton.setArr.count)

        
    }
    
    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText(
                "Really enjoying " + beer!.name +  " check it out!!" )
            self.presentViewController(tweetVC, animated: true, completion: nil)
        }
            else {
            let alert = UIAlertController(title: "Cannot find twitter please log in", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
                }
    }

    
   // @IBAction func done(segue: UIStoryboardSegue) {
   //     self.dismissViewControllerAnimated(true, completion: nil)
   // }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
