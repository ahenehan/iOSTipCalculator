//
//  ViewController.swift
//  Tips
//
//  Created by Aaron Henehan on 4/27/15.
//  Copyright (c) 2015 Aaron Henehan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var defaults = NSUserDefaults.standardUserDefaults()
        tipControl.selectedSegmentIndex = defaults.integerForKey("default_tip_index")
        let dateAppClosed = defaults.objectForKey("time_screen_disappear") as NSDate!
        if dateAppClosed == nil
        {
            return
        }
        let timeSinceEntered = NSDate().timeIntervalSinceDate(dateAppClosed)
        if timeSinceEntered > 600 // 10 minutes have passed return
        {
            return
        }
        let billAmount = defaults.doubleForKey("current_bill_amount")
        if billAmount == 0 // user did not enter a value
        {
            return
        }
        billField.text = "\(billAmount)"
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let billAmount = (billField.text as NSString).doubleValue
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(billAmount, forKey: "current_bill_amount")
        defaults.setObject(NSDate(), forKey: "time_screen_disappear")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        var tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        //var billAmount = billField.text.bridgeToObjectiveC().doubleValue
        let billAmount = (billField.text as NSString).doubleValue
        let tip = billAmount * tipPercentage
        let total = tip + billAmount
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

