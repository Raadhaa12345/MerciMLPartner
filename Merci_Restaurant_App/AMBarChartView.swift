//
//  AMBarChartView.swift
//  AMChart, https://github.com/adventam10/AMChart
//
//  Created by am10 on 2018/01/02.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public enum AMBCDecimalFormat {
    case none
    case first
    case second
}

public protocol AMBarChartViewDataSource:class {
    
    func numberOfSections(inBarChartView barChartView: AMBarChartView) -> Int
    
    func barChartView(barChartView: AMBarChartView, numberOfRowsInSection section: Int) -> Int
    
    func barChartView(barChartView: AMBarChartView, valueForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func barChartView(barChartView: AMBarChartView, colorForRowAtIndexPath indexPath: IndexPath) -> UIColor
    
    func barChartView(barChartView: AMBarChartView, titleForXlabelInSection section: Int) -> String
}

public class AMBarChartView: UIView {

    override public var bounds: CGRect {
        
        didSet {
            
            reloadData()
        }
    }
    
    weak public var dataSource:AMBarChartViewDataSource?
    
    @IBInspectable public var yAxisMaxValue:CGFloat = 100
    
    @IBInspectable public var yAxisMinValue:CGFloat = 0
    
    @IBInspectable public var numberOfYAxisLabel:Int = 6
    
    @IBInspectable public var yAxisTitle:String = "" {
        
        didSet {
            
            yAxisTitleLabel.text = yAxisTitle
        }
    }
    
    @IBInspectable public var xAxisTitle:String = "" {
        
        didSet {
            
            xAxisTitleLabel.text = xAxisTitle
        }
    }
    
    @IBInspectable public var yLabelWidth:CGFloat = 50.0
    
    @IBInspectable public var xLabelHeight:CGFloat = 30.0
    
    @IBInspectable public var axisColor:UIColor = UIColor(displayP3Red: 228/255, green: 27/255, blue: 35/255, alpha: 1.0)
    
    @IBInspectable public var axisWidth:CGFloat = 1.0
    
    @IBInspectable public var barSpace:CGFloat = 10
    
    @IBInspectable public var yAxisTitleFont:UIFont = UIFont.systemFont(ofSize: 15)
    
    @IBInspectable public var xAxisTitleFont:UIFont = UIFont.systemFont(ofSize: 15)
    
    @IBInspectable public var xAxisTitleLabelHeight:CGFloat = 50.0
    
    @IBInspectable public var yAxisTitleLabelHeight:CGFloat = 50.0
    
    @IBInspectable public var yLabelsFont:UIFont = UIFont.systemFont(ofSize: 15)
    
    @IBInspectable public var xLabelsFont:UIFont = UIFont.systemFont(ofSize: 9)
    
    @IBInspectable public var yAxisTitleColor:UIColor = UIColor.black
    
    @IBInspectable public var xAxisTitleColor:UIColor = UIColor.lightGray
    
    @IBInspectable public var yLabelsTextColor:UIColor = UIColor.black
    
    @IBInspectable public var xLabelsTextColor:UIColor = UIColor.black
    
    public var yAxisDecimalFormat:AMBCDecimalFormat = .none

    public var animationDuration:CFTimeInterval = 0.6
    
    @IBInspectable public var isHorizontalLine:Bool = false
    
    private let space:CGFloat = 4
    
    private let xAxisView = UIView()
    
    private let yAxisView = UIView()
    
    private var xLabels = [UILabel]()
    
    private var yLabels = [UILabel]()
    
    private var barLayers = [CALayer]()
    
    private let xAxisTitleLabel = UILabel()
    
    private let yAxisTitleLabel = UILabel()
    
    private var horizontalLineLayers = [CALayer]()
    
    private var graphLineLayers = [CAShapeLayer]()
    
    private var graphLineLayer = CALayer()
    var managetranform = true
    
    //MARK:Initialize
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        initView()
    }
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        initView()
    }
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
    }
    
    private func initView() {
        
        // y軸設定
        addSubview(yAxisView)
        yAxisTitleLabel.textAlignment = .right
        yAxisTitleLabel.adjustsFontSizeToFitWidth = true
        yAxisTitleLabel.numberOfLines = 0
        addSubview(yAxisTitleLabel)
        
        // x軸設定
        addSubview(xAxisView)
        xAxisTitleLabel.textAlignment = .center
        xAxisTitleLabel.adjustsFontSizeToFitWidth = true
        xAxisTitleLabel.numberOfLines = 0
        addSubview(xAxisTitleLabel)
        
        graphLineLayer.masksToBounds = true
        layer.addSublayer(graphLineLayer)
    }
    
    override public func draw(_ rect: CGRect) {
        
        reloadData()
    }
    
    public func reloadData() {
        
        clearView()
        settingAxisViewFrame()
        settingAxisTitleLayout()
        prepareYLabels()
        
        guard let dataSource = dataSource else {
            
            return
        }
        
        let sections = dataSource.numberOfSections(inBarChartView: self)
        
        for section in 0..<sections {
            
            prepareXlabels(sections:sections, section:section)
            prepareBarLayers(section:section)
            
            let label = xLabels[section]
            label.text =  "        " + dataSource.barChartView(barChartView: self, titleForXlabelInSection: section)
            
//            if (managetranform)
//            {
//                label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//            }
            let rows = dataSource.barChartView(barChartView: self, numberOfRowsInSection: section)
            var values = [CGFloat]()
            var colors = [UIColor]()
            for row in 0..<rows {
                
                let indexPath = IndexPath(row:row, section: section)
                let value = dataSource.barChartView(barChartView: self, valueForRowAtIndexPath: indexPath)
                let color = dataSource.barChartView(barChartView: self, colorForRowAtIndexPath: indexPath)
                values.append(value)
                colors.append(color)
            }
            
            prepareBarGraph(section: section, colors: colors, values: values)
        }
        //managetranform = !managetranform
        showAnimation()
    }
    
    private func clearView() {
        
        xLabels.forEach {$0.removeFromSuperview()}
        xLabels.removeAll()
        
        yLabels.forEach {$0.removeFromSuperview()}
        yLabels.removeAll()
        
        horizontalLineLayers.forEach {$0.removeFromSuperlayer()}
        horizontalLineLayers.removeAll()
        
        barLayers.forEach {$0.removeFromSuperlayer()}
        barLayers.removeAll()
        
        graphLineLayers.forEach {$0.removeFromSuperlayer()}
        graphLineLayers.removeAll()
    }
    
    private func settingAxisViewFrame() {
        
        let a = (frame.height - space - yAxisTitleLabelHeight - space - xLabelHeight - xAxisTitleLabelHeight)
        let b = CGFloat(numberOfYAxisLabel - 1)
    
        var yLabelHeight = (a / b) * 0.6
        
        if yLabelHeight.isNaN {
            
            yLabelHeight = 0
        }
        
        // y軸設定
        yAxisView.frame = CGRect(x: space + yLabelWidth,
                                 y: space + yAxisTitleLabelHeight + yLabelHeight/2,
                                 width: axisWidth,
                                 height: frame.height - (space + yAxisTitleLabelHeight + yLabelHeight/2) - space - xLabelHeight - xAxisTitleLabelHeight)
        
        yAxisTitleLabel.frame = CGRect(x: space,
                                       y: space,
                                       width: yLabelWidth - space,
                                       height: yAxisTitleLabelHeight)
        
        // x軸設定
        xAxisView.frame = CGRect(x: yAxisView.frame.minX,
                                 y: yAxisView.frame.maxY,
                                 width: frame.width - yAxisView.frame.minX - space,
                                 height: axisWidth)
        
       
        
        xAxisTitleLabel.frame = CGRect(x: xAxisView.frame.minX,
                                        y: frame.height - xAxisTitleLabelHeight - space,
                                        width: xAxisView.frame.width,
                                        height: xAxisTitleLabelHeight)
        
        yAxisView.backgroundColor = axisColor
        xAxisView.backgroundColor = axisColor
        
        graphLineLayer.frame = CGRect(x: yAxisView.frame.minX + axisWidth,
                                      y: yAxisView.frame.minY,
                                      width: xAxisView.frame.width - axisWidth,
                                      height: yAxisView.frame.height)
    }
    
    private func settingAxisTitleLayout() {
        
        yAxisTitleLabel.font = yAxisTitleFont
        yAxisTitleLabel.textColor = yAxisTitleColor
        
        xAxisTitleLabel.font = xAxisTitleFont
        xAxisTitleLabel.textColor = xAxisTitleColor
    }
    
    private func prepareYLabels() {
        
        if numberOfYAxisLabel == 0 {
            
            return
        }
        
        let valueCount = (yAxisMaxValue - yAxisMinValue) / CGFloat(numberOfYAxisLabel - 1)
        var value = yAxisMinValue
        let height = (yAxisView.frame.height / CGFloat(numberOfYAxisLabel - 1)) * 0.6
        let space = (yAxisView.frame.height / CGFloat(numberOfYAxisLabel - 1)) * 0.4
        var y = xAxisView.frame.minY - height/2
        
        for index in 0..<numberOfYAxisLabel {
            
            let yLabel = UILabel(frame:CGRect(x: space,
                                              y: y,
                                              width: yLabelWidth - space,
                                              height: height))
            yLabel.tag = index
            yLabels.append(yLabel)
            yLabel.textAlignment = .right
            yLabel.adjustsFontSizeToFitWidth = true
            yLabel.font = yLabelsFont
            yLabel.textColor = yLabelsTextColor
            addSubview(yLabel)
            
            if yAxisDecimalFormat == .none {
                
                yLabel.text = NSString(format: "%.0f", value) as String
                
            } else if yAxisDecimalFormat == .first {
                
                yLabel.text = NSString(format: "%.1f", value) as String
                
            } else if yAxisDecimalFormat == .second {
                
                yLabel.text = NSString(format: "%.2f", value) as String
            }
            
            if isHorizontalLine {
                
                prepareGraphLineLayers(positionY:y + height/2)
                
            }
            y -= height + space
            value += valueCount
        }
    }
    
    private func prepareGraphLineLayers(positionY :CGFloat) {
        
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: xAxisView.frame.minX,
                                 y: positionY,
                                 width: xAxisView.frame.width,
                                 height: 1)
        lineLayer.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(lineLayer)
        horizontalLineLayers.append(lineLayer)
    }
    
    private func prepareXlabels(sections: Int, section: Int) {
        
        if sections == 0 {
            
            return
        }
        
        let width = (xAxisView.frame.width - axisWidth - barSpace) / CGFloat(sections) - barSpace
        var x = xAxisView.frame.minX + axisWidth + (barSpace + width) * CGFloat(section)
        x += barSpace
        let y = xAxisView.frame.minY + axisWidth
        let xLabel = UILabel(frame:CGRect(x: x - 21 ,y: y,width: width + 30  ,height: xLabelHeight))
        
        xLabel.textAlignment = .left
        xLabel.adjustsFontSizeToFitWidth = false
        xLabel.numberOfLines = 1
        xLabel.font = xLabelsFont
       // xLabel.backgroundColor = UIColor.black
        xLabel.textColor = xLabelsTextColor
        xLabel.tag = section
        xLabels.append(xLabel)
        addSubview(xLabel)
    }
    
    private func prepareBarLayers(section: Int) {
        
        let xLabel = xLabels[section]
        let barLayer = CALayer()
        barLayer.frame = CGRect(x:xLabel.frame.minX + 21  ,y: yAxisView.frame.minY,width:15,height: yAxisView.frame.height - axisWidth)
        
        barLayers.append(barLayer)
        layer.addSublayer(barLayer)
    }
    
    private func prepareBarGraph(section: Int, colors: [UIColor], values: [CGFloat]) {
        
        let sum = values.reduce(0, +)
        let barLayer = barLayers[section]
        barLayer.masksToBounds = true
        var frame = barLayer.frame
        if yAxisMaxValue > 0 {
        frame.size.height = ((sum - yAxisMinValue) / (yAxisMaxValue - yAxisMinValue)) * barLayer.frame.height
        frame.origin.y = xAxisView.frame.minY - frame.height
        barLayer.frame = frame
        }else {
            
            
            
            frame.size.height = ((sum - yAxisMinValue) / (1 - yAxisMinValue)) * barLayer.frame.height
            frame.origin.y = xAxisView.frame.minY - frame.height
            
            barLayer.frame = frame
        }
        var y = barLayer.frame.height + (barLayer.frame.height * yAxisMinValue) / (sum - yAxisMinValue)
        if y.isNaN {
            
            y = 0
        }
        
        for (index, color) in colors.enumerated() {
            
            let value = values[index]
            var height = (value/(sum - yAxisMinValue)) * barLayer.frame.height
            if height.isNaN {
                
                height = 0;
            }
            
            let valueLayer = CAShapeLayer()
            valueLayer.frame = barLayer.bounds
            valueLayer.fillColor = color.cgColor
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: y - height))
            path.addLine(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: barLayer.frame.width, y: y))
            path.addLine(to: CGPoint(x: barLayer.frame.width, y: y - height))
            path.addLine(to: CGPoint(x: 0, y: y - height))
            valueLayer.path = path.cgPath;
            barLayer.cornerRadius = 5
            barLayer.addSublayer(valueLayer)
            y -= height
        }
    }
    
    private func showAnimation (){
                
        for barLayer in barLayers {
            
            let startPath = UIBezierPath()
            startPath.move(to: CGPoint(x: 0, y: barLayer.frame.height))
            startPath.addLine(to: CGPoint(x: 0, y: barLayer.frame.height))
            startPath.addLine(to: CGPoint(x: barLayer.frame.width, y: barLayer.frame.height))
            startPath.addLine(to: CGPoint(x: barLayer.frame.width, y: barLayer.frame.height))
            startPath.addLine(to: CGPoint(x: 0, y: barLayer.frame.height))
            
            for layer in barLayer.sublayers! {
                
                let valueLayer = layer as! CAShapeLayer
                let animationPath = UIBezierPath(cgPath: valueLayer.path!)
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = animationDuration
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fromValue = startPath.cgPath
                animation.toValue = animationPath.cgPath
                valueLayer.path = animationPath.cgPath
                valueLayer.add(animation, forKey: nil)
            }
        }
    }
}
