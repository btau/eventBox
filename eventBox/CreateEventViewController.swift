//
//  CreateEventViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import Calendar_iOS
import GoogleMaps

class CreateEventViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CalendarViewControllerDelegate, TimeViewControllerDelegate, GMSAutocompleteViewControllerDelegate {
    
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    @IBOutlet weak var eventAddressTextField: UITextField!
    @IBOutlet weak var eventBackgroundImageView: UIImageView!
    @IBOutlet weak var eventBackgroundButton: UIButton!
    
    
    var textFields: [UITextField]!
    
    var eventDate: NSDate?
    var eventTime: NSDate?
    var eventLocation: CLLocationCoordinate2D?
    
    let animationSpeed = 0.25
    
    var tintView: UIView?
    
    var cancel = true
    
    var animator: UIDynamicAnimator?
    var snap: UISnapBehavior?
    
    let autocompleteController = GMSAutocompleteViewController()
    
    var selectedImage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [eventNameTextField,eventDateTextField,eventTimeTextField, eventAddressTextField]
        autocompleteController.delegate = self
        
        for textField in textFields {
            textField.borderColor = UIColor.eventBoxAccent()
        }
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        clearTextfields(Except: nil)
        return true
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        clearTextfields(Except: textField)
        
        UIView.animateWithDuration(animationSpeed) { () -> Void in
            textField.backgroundColor = .whiteColor()
        }
        
        
        textField.borderWidth = 3
        
        let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue        = 0
            width.toValue          = 3
            width.duration         = animationSpeed
            width.timingFunction   = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        textField.layer.addAnimation(width, forKey: "borderWidth")
        
        switch textField.tag {
        case 1:
            return true
        case 2:
            performSegueWithIdentifier("CalendarPop", sender: nil)
        case 3:
            performSegueWithIdentifier("TimePop", sender: nil)
        case 4:
            
            self.presentViewController(autocompleteController, animated: true, completion: nil)
            
        default:
            return false
        }
        return false
        
    }
    
    func clearTextfields(Except selectedTextfield: UITextField?) {
        
        for textField in textFields {
            guard textField.tag != selectedTextfield?.tag else {
                continue
            }
            
            if selectedTextfield?.tag == 2 || selectedTextfield?.tag == 3 {
                textField.resignFirstResponder()
            }
            
            let color = UIColor(red: 240/255, green: 249/255, blue: 255/255, alpha: 1.0)
            UIView.animateWithDuration(animationSpeed) { () -> Void in
                textField.backgroundColor = color
            }
            
            let currentWidth = textField.borderWidth
            textField.borderWidth = 0
            let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = currentWidth
            width.toValue = 0
            width.duration = animationSpeed
            width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            textField.layer.addAnimation(width, forKey: "borderWidth")
            
        }
    }
    
    //MARK: - Google Location
    
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithPlace place: GMSPlace!) {
        print("Place Name: \(place.name)")
        print("Place Address: \(place.formattedAddress)")
        print("Place Attributions: \(place.attributions)")
        
        eventLocation = place.coordinate
        
        eventAddressTextField.text = place.name
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        clearTextfields(Except: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: NSError!) {
        print("Error", error.description)
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        clearTextfields(Except: nil)
    }
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: - CalenderView -
    
    func calendarViewControllerDidDismiss() {
        dismissTintView()
    }
    
    func calendarViewControllerDidSelectDate(date: NSDate) {
        let formatter = NSDateFormatter()
            formatter.dateStyle = .LongStyle
            formatter.timeStyle = .NoStyle
        self.eventDate = date
        
        eventDateTextField.text = formatter.stringFromDate(date)
    }
    
    func timeViewControllerDidDismiss() {
        dismissTintView()
    }
    
    func timeViewControllerDidSelectTime(time: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        self.eventTime = time
        
        eventTimeTextField.text = formatter.stringFromDate(time)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CalendarPop" {
            
            let calVC = segue.destinationViewController as! CalendarViewController
            
            calVC.delegate = self
            
            tintView = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
            tintView!.alpha = 0
            tintView!.backgroundColor = .blackColor()
            self.view.insertSubview(tintView!, atIndex: self.view.subviews.count)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tintView!.alpha = 0.5
            })
            
            
        } else if segue.identifier == "TimePop" {
            
            let timeVC = segue.destinationViewController as! TimeViewController
            
            timeVC.delegate = self
            
            tintView = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
            tintView!.alpha = 0
            tintView!.backgroundColor = .blackColor()
            self.view.insertSubview(tintView!, atIndex: self.view.subviews.count)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tintView!.alpha = 0.5
            })
            
            
        } else if segue.identifier == "addEventUnwind" {
            
            let unwindSegue = segue as! NewEventUnwind
            
            animator = UIDynamicAnimator(referenceView: segue.destinationViewController.view)
            snap = UISnapBehavior(item: segue.sourceViewController.view, snapToPoint: CGPointMake(0, 0))
            
            unwindSegue.animator = animator!
            unwindSegue.snap = snap!
            unwindSegue.cancel = cancel
            
            
            
            //  let time = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "dismiss", userInfo: nil, repeats: false)
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(false, completion: nil)
        print("dealloc")
    }
    
    func dismissTintView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tintView!.alpha = 0
            }) { (bool:Bool) -> Void in
                self.tintView?.removeFromSuperview()
        }
        
        clearTextfields(Except: nil)
    }
    
    
    @IBAction func onCreateTapped(sender: UIButton)
    {
        
        let eventName = eventNameTextField.text
        
        
        if eventName != "" && self.eventDate != nil && self.eventTime != nil 
        {
            
            // Creating new start date by combing both Date Field with Time Field by use of combineDate func
            let createdStartDate = combineDate(self.eventDate!, WithTime: self.eventTime!)
            
            // Taking createdStartDate and converting it to Double via timeIntervalSince1970
            let newStartDate = createdStartDate.timeIntervalSince1970
            
            let newEvent = Event()
                newEvent.eventName    = eventName!
                newEvent.startDate    = newStartDate
                newEvent.location.lat = (eventLocation?.latitude)!
                newEvent.location.lon = (eventLocation?.longitude)!
                newEvent.imageName    = "\(selectedImage)"
            
            print("Event Latitude:\(newEvent.location.lat)")
            print("Event Longitude:\(newEvent.location.lon)")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
            print("\(dateFormatter.stringFromDate(createdStartDate))")
            
            NetworkManager.sharedManager.createEvent(newEvent, created: { () -> Void in
                 self.dismiss()
            })
            
           
            
        }
        else
        {
            let alertController = UIAlertController(title: "Error!", message: "Please Fill In All Fields", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(cancel)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    func combineDate(date: NSDate, WithTime time: NSDate) -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Month, .Day, .Year], fromDate: date)
        let timeComponents = calendar.components([.Hour, .Minute, .Second], fromDate: time)
        
        let components        = NSDateComponents()
            components.year   = dateComponents.year
            components.month  = dateComponents.month
            components.day    = dateComponents.day
            components.hour   = timeComponents.hour
            components.minute = timeComponents.minute
            components.second = timeComponents.second
        
        return calendar.dateFromComponents(components)!
        
    }
    
    
    //MARK: - Image Select -
    
    let imageCount = 10
    var imageCollectionView: UICollectionView?
    var exitImageButton = UIButton(frame: CGRect(x: 10, y: -44, width: 44, height: 44))
    var imageReturnFrame: CGRect!
    
    @IBAction func onBackgroundTapped(sender: UIButton) {
        initImageSelect()
    }
    
    @IBAction func onExitBackgroundSelectTapped(sender: UIButton) {
        closeImageSelect()
    }
    
    
    func initImageSelect() {
        
        
        imageReturnFrame = eventBackgroundImageView.frame
        
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionHeight = 150 as CGFloat
        let space = 10.0 as CGFloat
        
        flowLayout.itemSize = CGSizeMake(100, collectionHeight)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        
        flowLayout.headerReferenceSize = CGSize(width: 10, height: collectionHeight)
        flowLayout.footerReferenceSize = CGSize(width: 10, height: collectionHeight)
        
        let sH = UIScreen.mainScreen().bounds.height
        let sW = UIScreen.mainScreen().bounds.width
        
        imageCollectionView = UICollectionView(frame: CGRect(x: 0, y: sH, width: sW, height: collectionHeight), collectionViewLayout: flowLayout)
 
        imageCollectionView?.backgroundColor = .clearColor()
        imageCollectionView?.showsHorizontalScrollIndicator = false
        
        imageCollectionView!.registerClass(BackgroundImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.imageCollectionView?.delegate = self
        self.imageCollectionView?.dataSource = self
        self.view.insertSubview(self.imageCollectionView!, aboveSubview: self.eventBackgroundImageView)
        
        self.imageCollectionView!.reloadData()
        self.imageCollectionView?.selectItemAtIndexPath(NSIndexPath(forRow: selectedImage - 1, inSection: 0), animated: true, scrollPosition: .CenteredVertically)
        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .CurveEaseInOut,
            animations: { () -> Void in
            
                self.eventBackgroundImageView.frame = self.view.frame
                self.eventBackgroundImageView.cornerRadius = 0
                self.eventBackgroundButton.alpha = 0
                
            }, completion: { (done) -> Void in
                
                self.view.addSubview(self.exitImageButton)
                
                self.exitImageButton.tintColor = .blackColor()
                self.exitImageButton.setImage(UIImage(named: "noun_multiply_315673"), forState: .Normal)
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveEaseInOut,
                    animations: { () -> Void in
                        
                        self.exitImageButton.frame.origin.y = 20
                        self.imageCollectionView?.frame.origin.y = (sH - collectionHeight - 10)
                    }, completion: { (done) -> Void in
                        self.exitImageButton.addTarget(self, action: "onExitBackgroundSelectTapped:", forControlEvents: .TouchUpInside)
                })

        })
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BackgroundImageCollectionViewCell
        cell.imageView.image = UIImage(named: "\(indexPath.row + 1)")
        
        cell.addSubview(cell.imageView)
        cell.backgroundColor = .whiteColor()
        cell.clipsToBounds   = true
        cell.cornerRadius    = 10
        
        cell.imageView.frame       = cell.bounds
        cell.imageView.contentMode = .ScaleAspectFill
        cell.borderColor           = UIColor.eventBoxAccent()
        
        if cell.selected {
            cell.borderWidth = cellSelectWidth
        } else {
            cell.borderWidth = 0
        }
        
        return cell
    }

    let cellSelectWidth = 5 as CGFloat
    let cellSelectDuration = 0.1 as Double
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        guard let cell = imageCollectionView?.cellForItemAtIndexPath(indexPath) as? BackgroundImageCollectionViewCell else {
            return false
        }
        
        if cell.selected {
            return false
        }
        
        cell.borderWidth = cellSelectWidth
        
        let Width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        Width.fromValue = 0
        Width.toValue   = cellSelectWidth
        Width.duration  = cellSelectDuration
        Width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        cell.layer.addAnimation(Width, forKey: "borderWidth")
        
        self.eventBackgroundImageView.image = UIImage(named: "\(indexPath.row + 1)")
        
        return true
    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = imageCollectionView?.cellForItemAtIndexPath(indexPath) as? BackgroundImageCollectionViewCell else {
            return
        }
        cell.borderWidth = 0
        
        let Width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        Width.fromValue = cellSelectWidth
        Width.toValue   = 0
        Width.duration  = cellSelectDuration
        
        cell.layer.addAnimation(Width, forKey: "borderWidth")
    }

    
    func closeImageSelect() {
        
        if let selectedRow = imageCollectionView?.indexPathsForSelectedItems()?.first?.row {
            selectedImage = selectedRow + 1
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .CurveEaseInOut,
            animations: { () -> Void in
            
                self.eventBackgroundImageView.frame = self.imageReturnFrame
                self.eventBackgroundImageView.cornerRadius = 10
                self.eventBackgroundButton.alpha = 1
                
                self.exitImageButton.frame.origin.y = -100
                self.imageCollectionView?.frame.origin.y = (UIScreen.mainScreen().bounds.height)
                
            }) { (complete) -> Void in
                self.exitImageButton.removeFromSuperview()
                self.imageCollectionView?.removeFromSuperview()
                
        }
        
    }
    
 }


