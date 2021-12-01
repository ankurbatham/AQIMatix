//
//  CityGraphViewController.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import UIKit
import CorePlot

class CityGraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: CPTGraphHostingView!
    @IBOutlet weak var aqiDetailView: CityGraphDetailView!
    
    var viewModel: GraphAQIViewModel?
    var plotData = [Double](repeating: 0.0, count: 100)
    var maxDataPoints = 50
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AQI Graph plot"
        intilizeView()
        viewModel?.delegate = self
    }
    
    func intilizeView() {
        initPlot()
    }
    
    func initPlot(){
        configureGraphtView()
        configureGraphAxis()
        configurePlot()
    }
    
    func setupDetailView(with cityModel: AQICityModel) {
        aqiDetailView.configurView(with: cityModel)
    }
    

}

//MARK:- Graph methods
extension CityGraphViewController {
    
    func configureGraphtView(){
        graphView.allowPinchScaling = false
        self.plotData.removeAll()
        self.currentIndex = 0
    }
    
    func configurePlot(){
        let plot = CPTScatterPlotFactory().createObject()
        guard let graph = graphView.hostedGraph else { return }
        plot.dataSource = (self as CPTPlotDataSource)
        plot.delegate = (self as CALayerDelegate)
        graph.add(plot, to: graph.defaultPlotSpace)
    }

    func configureGraphAxis(){
        let graph = CPTXYGraph(frame: graphView.bounds)
        graph.plotAreaFrame?.masksToBorder = false
        graphView.hostedGraph = graph
        graph.backgroundColor = UIColor.black.cgColor
        graph.paddingBottom = 40.0
        graph.paddingLeft = 40.0
        graph.paddingTop = 30.0
        graph.paddingRight = 15.0
        
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        let axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.white()
        axisTextStyle.fontName = "HelveticaNeue-Bold"
        axisTextStyle.fontSize = 10.0
        axisTextStyle.textAlignment = .center
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor.white()
        lineStyle.lineWidth = 5
        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.gray()
        gridLineStyle.lineWidth = 0.5
        
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 10
            x.minorTicksPerInterval = 5
            x.labelTextStyle = axisTextStyle
            x.minorGridLineStyle = gridLineStyle
            x.axisLineStyle = lineStyle
            x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            x.delegate = self
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength = 50
            y.minorTicksPerInterval = 50
            y.minorGridLineStyle = gridLineStyle
            y.labelTextStyle = axisTextStyle
            y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 255, green: 255, blue: 255, alpha: 0.03)),CPTFill(color: CPTColor.black())]
            y.axisLineStyle = lineStyle
            y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            y.delegate = self
        }
        
        // Set plot space
        let xMin = 0.0
        let xMax = 50.0
        let yMin = 0.0
        let yMax = 500.0
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
        
    }
}

extension CityGraphViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.plotData.count)
    }
    
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: UIEvent) {
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        
        switch CPTScatterPlotField(rawValue: Int(field))! {
        
        case .X:
            return NSNumber(value: Int(record) + self.currentIndex-self.plotData.count)
            
        case .Y:
            return self.plotData[Int(record)] as NSNumber
            
        default:
            return 0
            
        }
        
    }
}

extension CityGraphViewController: AQIViewModelDelegate {
    func onDataDidupdate() {
        drawGraph()
    }
    
    func onDataUpdateFailed(error: Error) {
        
    }
}

extension CityGraphViewController {
    func drawGraph(){
        let graph = self.graphView.hostedGraph
        let plot = graph?.plot(withIdentifier: "mindful-graph" as NSCopying)
        if((plot) != nil){
            if(self.plotData.count >= maxDataPoints){
                self.plotData.removeFirst()
                plot?.deleteData(inIndexRange:NSRange(location: 0, length: 1))
            }
        }
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        
        let location: NSInteger
        if self.currentIndex >= maxDataPoints {
            location = self.currentIndex - maxDataPoints + 2
        } else {
            location = 0
        }
        
        let range: NSInteger
        
        if location > 0 {
            range = location-1
        } else {
            range = 0
        }
        
        let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(range)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(location)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        
        CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
        
        
        if let element = viewModel?.getSelectedCityData() {
            self.currentIndex += 1;
            print(element.aqi, element.city)
            self.plotData.append(element.aqi)
            plot?.insertData(at: UInt(self.plotData.count-1), numberOfRecords: 1)
            self.setupDetailView(with: element)
        }
    }
}
