/**
 © Copyright 2019, The Great Rift Valley Software Company
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import UIKit
import RVS_Spinner

/* ###################################################################################################################################### */
class RVS_Spinner_Basic_Test_Harness_ViewController: UIViewController, RVS_SpinnerDelegate {
    /* ################################################################################################################################## */
    typealias ShapeValueTuple = (name: String, image: UIImage, index: Int)
    
    /* ################################################################################################################################## */
    private let _colorList: [UIColor] = [
        UIColor.clear,
        UIColor.white,
        UIColor.black,
        UIColor.lightGray,
        UIColor(red: 1, green: 1, blue: 0.75, alpha: 1),
        UIColor(red: 1, green: 0.75, blue: 1, alpha: 1),
        UIColor(red: 0.75, green: 1, blue: 1, alpha: 1)
    ]
    
    private let _darkColorList: [UIColor] = [
        UIColor.clear,
        UIColor.white,
        UIColor.black,
        UIColor.darkGray,
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),
        UIColor(red: 1, green: 0, blue: 1, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1)
    ]
    
    private let _associatedText: [String] = [
        "Associated Text #01",
        "Associated Text #02",
        "Associated Text #03",
        "Associated Text #04",
        "Associated Text #05",
        "Associated Text #06",
        "Associated Text #07",
        "Associated Text #08",
        "Associated Text #09",
        "Associated Text #10",
        "Associated Text #11",
        "Associated Text #12",
        "Associated Text #13",
        "Associated Text #14",
        "Associated Text #15",
        "Associated Text #16",
        "Associated Text #17",
        "Associated Text #18",
        "Associated Text #19",
        "Associated Text #20"
    ]
    
    /* ################################################################################################################################## */
    private var _shapes = [ShapeValueTuple]()
    
    private var _dataItems = [RVS_SpinnerDataItem]()

    /* ################################################################################################################################## */
    @IBOutlet weak var spinnerView: RVS_Spinner!
    @IBOutlet weak var numberOfItemsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var innerColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radialColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var borderColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var spinnerModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var thresholdSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rotationSlider: UISlider!
    @IBOutlet weak var hapticsSwitch: UISwitch!
    @IBOutlet weak var soundsSwitch: UISwitch!
    @IBOutlet weak var associatedTextLabel: UILabel!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    var everyShape: [ShapeValueTuple] {
        return _shapes
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBAction func soundsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isSoundOn = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func hapticsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isHapticsOn = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func rotationSliderChanged(_ inSlider: UISlider) {
        var offset = Float.pi * inSlider.value
        
        if 0.05 > abs(offset) { // Give a teeny little detent at 0.
            offset = 0
            inSlider.value = offset
        }
        
        spinnerView.rotationInRadians = offset
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func thresholdSegmentedControlHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let value = Int(inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) ?? "") {
            spinnerView?.spinnerThreshold = value
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func spinnerModeSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        spinnerView.spinnerMode = inSegmentedSwitch.selectedSegmentIndex - 1
        thresholdSegmentedControl.isEnabled = 0 == spinnerView.spinnerMode
    }

    /* ################################################################## */
    /**
     */
    @IBAction func numberSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let numberOfItems = Int(inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) ?? "") {
            setUpDataItemsArray(numberOfItems)
        }
        updateAssociatedText()
    }

    /* ################################################################## */
    /**
     */
    @IBAction func colorSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        if inSegmentedSwitch == innerColorSegmentedControl {
            spinnerView.backgroundColor = _colorList[inSegmentedSwitch.selectedSegmentIndex]
        } else if inSegmentedSwitch == radialColorSegmentedControl {
            spinnerView.openBackgroundColor = _colorList[inSegmentedSwitch.selectedSegmentIndex]
        } else {
            spinnerView.tintColor = _darkColorList[inSegmentedSwitch.selectedSegmentIndex]
        }
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func subsetOfShapes(_ inNumberOfShapes: Int) -> [ShapeValueTuple] {
        let shapes = everyShape
        let stepSize = Double(shapes.count) / Double(inNumberOfShapes)
        var ret: [ShapeValueTuple] = []
        let stepper = stride(from: 0.0, to: Double(shapes.count), by: stepSize)
        
        for step in stepper {
            ret.append(shapes[Int(step)])
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     */
    func updateAssociatedText() {
        associatedTextLabel?.text = spinnerView?.value?.value as? String
    }

    /* ################################################################## */
    /**
     */
    func extractValueList() {
        _shapes = []
        
        if let resourcePath = Bundle.main.resourcePath {
            let imagePath = resourcePath + "/SpinnerIcons"
            let fileManager = FileManager.default
            var index = 0
            
            do {
                let imagePaths = try fileManager.contentsOfDirectory(atPath: imagePath).sorted()
                imagePaths.forEach {
                    if let imageFile = fileManager.contents(atPath: imagePath + "/" + $0) {
                        if let image = UIImage(data: imageFile) {
                            var name = $0
                            name.removeLast(4)
                            _shapes.append((name: name, image: image, index: index))
                            index += 1
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func setUpControls() {
        spinnerView.delegate = self
        spinnerView.values = _dataItems
        spinnerView.selectedIndex = _dataItems.count / 2
        spinnerView.backgroundColor = _colorList[innerColorSegmentedControl.selectedSegmentIndex]
        spinnerView.openBackgroundColor = _colorList[radialColorSegmentedControl.selectedSegmentIndex]
        spinnerView.tintColor = _darkColorList[borderColorSegmentedControl.selectedSegmentIndex]
        spinner(spinnerView, hasSelectedTheValue: spinnerView?.value)
    }
    
    /* ################################################################## */
    /**
     */
    func setUpCountSwitch() {
        let step = Double(everyShape.count) / Double(numberOfItemsSegmentedControl.numberOfSegments)
        for index in 0..<numberOfItemsSegmentedControl.numberOfSegments {
            let count = Int(Swift.max(2.0, Swift.min(Double(everyShape.count), ceil(Double(index + 1) * step))))
            numberOfItemsSegmentedControl.setTitle(String(count), forSegmentAt: index)
        }
        
        numberOfItemsSegmentedControl.selectedSegmentIndex = numberOfItemsSegmentedControl.numberOfSegments / 2
    }
    
    /* ################################################################## */
    /**
     */
    func setUpDataItemsArray(_ inNumberOfItems: Int) {
        _dataItems = []
        let items = subsetOfShapes(inNumberOfItems)
        items.forEach {
            _dataItems.append(RVS_SpinnerDataItem(title: $0.name, icon: $0.image, value: _associatedText[$0.index]))
        }
        setUpControls()
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        extractValueList()
        setUpCountSwitch()
        numberSegSwitchHit(numberOfItemsSegmentedControl)
        spinnerModeSegSwitchHit(spinnerModeSegmentedControl)
        rotationSliderChanged(rotationSlider)
        thresholdSegmentedControlHit(thresholdSegmentedControl)
        updateAssociatedText()
    }
        
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func spinner(_ inSpinner: RVS_Spinner, hasSelectedTheValue inValueSelected: RVS_SpinnerDataItem?) {
        updateAssociatedText()
    }
}
