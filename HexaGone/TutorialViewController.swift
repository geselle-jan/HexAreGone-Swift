//
//  TutorialViewController.swift
//  HexaGone
//
//  Created by Jan Geselle on 29.05.15.
//  Copyright (c) 2015 Jan Geselle. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setContentOffset(CGPoint(x: 0, y: textView.contentSize.height), animated: false)
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
