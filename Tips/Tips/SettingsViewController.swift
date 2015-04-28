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
    
    var hasShiftedView = false
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var defaults = NSUserDefaults.standardUserDefaults()
        let tipControlIndex = defaults.integerForKey("default_tip_index")
        settingsTipController.selectedSegmentIndex = tipControlIndex
        if tipControlIndex == 3
        {
            let customTipAmount = defaults.doubleForKey("default_custom_tip_percentage")
            tipPercentField.text = "\(customTipAmount)"
            revealTipPercentage()
        }
    }
    
    func hideTipPercentage()
    {
        UIView.animateWithDuration(1, animations: {
            self.descriptionLabel.frame.origin.y = 231
            self.tipPercentField.alpha = 0
            self.tipPercentLabel.alpha = 0
        })
        hasShiftedView = false
    }
    
    func revealTipPercentage()
    {
        UIView.animateWithDuration(1, animations: {
            self.descriptionLabel.frame.origin.y = 180
            self.tipPercentField.alpha = 1
            self.tipPercentLabel.alpha = 1
        })
        hasShiftedView = true
    }
    
    @IBAction func onPercentSelected(sender: AnyObject) {
        if settingsTipController.selectedSegmentIndex == 3 && !hasShiftedView
        {
            revealTipPercentage()
        }
        else if hasShiftedView
        {
            hideTipPercentage()
        }
    }
    
    
    @IBAction func onBackButton(sender: AnyObject) {
        let tipControllerIndex = settingsTipController.selectedSegmentIndex
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControllerIndex, forKey: "default_tip_index")
        
        if tipControllerIndex == 3
        {
            let tipPercentage = (tipPercentField.text as NSString).doubleValue
            var test = tipPercentage
            defaults.setDouble(tipPercentage, forKey: "default_custom_tip_percentage")
            UIView.animateWithDuration(1, animations: {
                self.descriptionLabel.frame.origin.y = 180
                self.tipPercentField.alpha = 1
                self.tipPercentLabel.alpha = 1
            })
        }
        defaults.synchronize()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
