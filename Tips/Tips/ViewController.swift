//
//  ViewController.swift
//  Tips
//
//  Created by Aaron Henehan on 4/27/15.
//  Copyright (c) 2015 Aaron Henehan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipPercentField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    var hasShiftedView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var defaults = NSUserDefaults.standardUserDefaults()
        let tipControlIndex = defaults.integerForKey("default_tip_index")
        tipControl.selectedSegmentIndex = tipControlIndex
        if tipControlIndex == 3
        {
            let customTipAmount = defaults.doubleForKey("default_custom_tip_percentage")
            tipPercentField.text = "\(customTipAmount)"
            revealTipPercentage()
        }
        else
        {
            hideTipPercentage()
        }
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
        calculateTotalAmount()
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

    func hideTipPercentage()
    {
        UIView.animateWithDuration(1, animations: {
            self.billField.frame.origin.y = 124
            self.billLabel.frame.origin.y = 128
            self.tipPercentField.alpha = 0
            self.tipPercentLabel.alpha = 0
        })
        hasShiftedView = false
    }
    
    func revealTipPercentage()
    {
        UIView.animateWithDuration(1, animations: {
            self.billField.frame.origin.y = 84
            self.billLabel.frame.origin.y = 88
            self.tipPercentField.alpha = 1
            self.tipPercentLabel.alpha = 1
        })
        hasShiftedView = true
    }
    
    func calculateTotalAmount()
    {
        let tipControlIndex = tipControl.selectedSegmentIndex
        let tipPercentages = [0.18, 0.2, 0.22]
        var tipPercentage = 0.0
        if tipControlIndex < 3
        {
            tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        }
        else
        {
            tipPercentage = (tipPercentField.text as NSString).doubleValue / 100
        }
        let billAmount = (billField.text as NSString).doubleValue
        let tip = billAmount * tipPercentage
        let total = tip + billAmount
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func onTipSelectorChanged(sender: AnyObject) {
        if tipControl.selectedSegmentIndex == 3 && !hasShiftedView
        {
            revealTipPercentage()
        }
        else if hasShiftedView
        {
            hideTipPercentage()
        }
        calculateTotalAmount()
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        calculateTotalAmount()
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

