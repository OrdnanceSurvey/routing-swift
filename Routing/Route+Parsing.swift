//
//  Route+Parsing.swift
//  Routing
//
//  Created by Dave Hardiman on 01/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Fetch

enum ParseError: ErrorType {
    case BboxParseError
}

extension Route: Parsable {
    public static func parse(fromData data: NSData?, withStatus status: Int) -> Result<Route> {
        if status == 200 {
            return parseRoute(data)
        }
        return .Failure(NSError(domain: "unimplemented", code: 1, userInfo: nil))
    }
}

private typealias JSON = OSJSON

private func parseRoute(data: NSData?) -> Result<Route> {
    guard let data = data else {
        return .Failure(RoutingError.NoDataReceived)
    }
    let json = JSON(data: data, initialKeyPath: "paths.@firstObject")
    guard let crsName = json.jsonForKey("crs")?.jsonForKey("properties")?.stringValueForKey("name"),
        crs = CoordinateReferenceSystem(rawValue: crsName) else {
            return .Failure(RoutingError.FailedToParseJSON)
    }
    let distance = json.doubleValueForKey("distance")
    let time = json.doubleValueForKey("time")
    guard let bbox = json.arrayValueForKey("bbox") as? [Double],
        boundingBox = try? bboxFromArray(bbox) else {
            return .Failure(RoutingError.FailedToParseJSON)
    }
    guard let instructionsJson = json.arrayValueForKey("instructions") as? [[String: AnyObject]] else {
        return .Failure(RoutingError.FailedToParseJSON)
    }
    guard let coordinatesJSON = json.jsonForKey("points")?.arrayValueForKey("coordinates") as? [[Double]] else {
        return .Failure(RoutingError.FailedToParseJSON)
    }
    return .Success(Route(crs: crs, distance: distance, time: time, instructions: instructionsJson.flatMap(instructionFromJSON), bbox: boundingBox, points: coordinatesJSON.flatMap(pointFromPointArray)))
}

private func bboxFromArray(array: [Double]) throws -> BoundingBox {
    if array.count != 4 {
        throw ParseError.BboxParseError
    }
    let bottomLeft = Point(x: array[0], y: array[1])
    let topRight = Point(x: array[2], y: array[3])
    return BoundingBox(bottomLeft: bottomLeft, topRight: topRight)
}

private func instructionFromJSON(dict: [String: AnyObject]) -> Instruction? {
    guard let sign = dict["sign"] as? Int,
        text = dict["text"] as? String,
        time = dict["time"] as? Double,
        distance = dict["distance"] as? Double,
        interval = dict["interval"] as? [Int],
        first = interval.first,
        last = interval.last else {
            return nil
    }
    return Instruction(
        sign: sign,
        text: text,
        time: time,
        distance: distance,
        startPoint: first,
        endPoint: last,
        annotationText: dict["annotation_text"] as? String,
        annotationImportance: dict["annotation_importance"] as? Int,
        turnAngle: dict["turn_angle"] as? Double,
        exitNumber: dict["exit_number"] as? Int
    )
}

private func pointFromPointArray(pointArray: [Double]) -> Point? {
    guard pointArray.count == 2 else {
        return nil
    }
    return Point(x: pointArray.first!, y: pointArray.last!)
}
