//
//  Instruction.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/**
 *  Represents an instruction on the route
 */
@objc(OSInstruction)
public class Instruction: NSObject {
    /// Represents the direction sign to display to a user
    public let sign: Int // TODO: Convert to enum

    /// The text to display to a user
    public let text: String

    /// The time taken to cover this instruction
    public let time: Double

    /// The distance covered by this instruction
    public let distance: Double

    /// The first point in the parent route that this instruction covers
    public let startPoint: Int

    /// The last point in the parent route that this instruction covers
    public let endPoint: Int

    /// Any additional information attached to this instruction
    public let annotationText: String?

    /// How important the additional information is to the user
    public let annotationImportance: Int?

    init(sign: Int, text: String, time: Double, distance: Double, startPoint: Int, endPoint: Int, annotationText: String? = nil, annotationImportance: Int? = nil) {
        self.sign = sign
        self.text = text
        self.time = time
        self.distance = distance
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.annotationText = annotationText
        self.annotationImportance = annotationImportance
        super.init()
    }
}