//
//  MoreDetails.swift
//  Final Project
//
//  Created by Andrew Pier on 4/30/16.
//  Copyright © 2016 Zared Hollabaugh. All rights reserved.
//

import UIKit

class MoreDetails: UIViewController {

    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var website: UIWebView?
    
    var beer: BeerSet? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label1?.text = beer?.descript
        name!.text = beer?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
