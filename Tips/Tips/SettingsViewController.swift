//
//  SettingsViewController.swift
//  Tips
//
//  Created by Aaron Henehan on 4/27/15.
//  Copyright (c) 2015 Aaron Henehan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTipController: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onPercentSelected(sender: AnyObject) {
        let tipControllerIndex = settingsTipController.selectedSegmentIndex
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControllerIndex, forKey: "default_tip_index")
        defaults.synchronize()
        if tipControllerIndex < 3
        {
            UIView.animateWithDuration(1, animations: {
                self.descriptionLabel.frame.origin.y = 231
                self.tipPercentField.alpha = 0
                self.tipPercentLabel.alpha = 0
            })
        }
        else
        {
            let tipPercentage = (tipPercentField.text as NSString).doubleValue
            defaults.setDouble(tipPercentage, forKey: "default_custom_tip_percentage")
            UIView.animateWithDuration(1, animations: {
                self.descriptionLabel.frame.origin.y = 180
                self.tipPercentField.alpha = 1
                self.tipPercentLabel.alpha = 1
            })
        }
    }
    
    
    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
