//
//  newCur.swift
//  trip assistant
//
//  Created by Asuka on 2016/11/15.
//  Copyright © 2016年 Joey deVilla. All rights reserved.
//

import UIKit
import GoogleMobileAds

class newCur: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.res.text = "Exchange Rate is ?"

        // Do any additional setup after loading the view.
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var picker: UIPickerView!
    private let fromComponent = 0
    private let toComponent = 1
    private let fromTypes = ["USD","CNY", "HKD", "JPY","AUD"]
    private let toTypes = ["USD","CNY", "HKD", "JPY","AUD"]

    
    @IBOutlet weak var aniView: UIView!
    
    @IBOutlet weak var res: UILabel!
    
        
    @IBAction func refresh(sender: AnyObject) {
        aniView.startCanvasAnimation()

        let fromRow = picker.selectedRowInComponent(fromComponent)
        let toRow = picker.selectedRowInComponent(toComponent)
        
        let from = fromTypes[fromRow]
        let to = toTypes[toRow]
        
        
        var help = ""
        
        
        
        let requestURl : NSURL = NSURL (string :"http://api.fixer.io/latest?base=\(String(from))")!
        let urlRequest : NSMutableURLRequest = NSMutableURLRequest(URL: requestURl)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest)
        {
            (data, response,error)-> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let rates = json["rates"] {
                        if let change = rates![to] as? Double{//the money u want
                            
                            
                            help = String(change)
                            print("help's value is \(help)")
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.res.text = "1 \(from) == \(help) \(to)"
                            }
                            
                            
                            
                            
                        }
                    }
                }
                catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()
        
        if (from==to)
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.res.text = "1 \(from) == 1 \(to)"
            }
        }


    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if component == toComponent {
            return toTypes.count
        } else {
            return fromTypes.count
        }
    }
    
    // MARK:-
    // MARK: Picker Delegate Methods
    func pickerView(pickerView: UIPickerView,
                    titleForRow row: Int,
                                forComponent component: Int) -> String? {
        if component == toComponent {
            return toTypes[row]
        } else {
            return fromTypes[row]
        }
    }
    
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    



}
