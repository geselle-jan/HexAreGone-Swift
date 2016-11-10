//
//  MenuViewController.swift
//  HexaGone
//
//  Created by Jan Geselle on 29.05.15.
//  Copyright (c) 2015 Jan Geselle. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var highscoreLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userDefaults.synchronize()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let score: AnyObject = userDefaults.value(forKey: "highscore") as AnyObject? {
            appDelegate.highscore = Int(score as! NSNumber)
        }
        
        let nf = NumberFormatter()
        nf.groupingSeparator = ","
        nf.numberStyle = NumberFormatter.Style.decimal
        let highscoreString = nf.string(from: NSNumber(value: appDelegate.highscore))!
        
        highscoreLabel.text = highscoreString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
