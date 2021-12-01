//
//  GraphFactory.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import Foundation
import CorePlot

protocol GraphFactory {
    associatedtype T
    func createObject()->T
}

class CPTScatterPlotFactory: GraphFactory {
    typealias T = CPTScatterPlot
    
    func createObject()->T {
        let plot = CPTScatterPlot()
        plot.dataLineStyle = CPTMutableLineStyleFactory().createObject()
        plot.curvedInterpolationOption = .catmullCustomAlpha
        plot.interpolation = .curved
        plot.identifier = "mindful-graph" as NSCoding & NSCopying & NSObjectProtocol
        return plot
    }
}

class CPTMutableLineStyleFactory: GraphFactory {
    typealias T = CPTMutableLineStyle
    
    func createObject()->T {
        let plotLineStile = CPTMutableLineStyle()
        plotLineStile.lineJoin = .round
        plotLineStile.lineCap = .round
        plotLineStile.lineWidth = 2
        plotLineStile.lineColor = CPTColor.white()
        return plotLineStile
    }
}

