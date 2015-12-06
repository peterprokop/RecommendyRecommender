//
//  RecommendyRecommenderExampleTests.swift
//  RecommendyRecommenderExampleTests
//
//  Created by Peter Prokop on 06/12/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import XCTest
@testable import RecommendyRecommenderExample

class RecommendyRecommenderExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCourseraExample() {
        let ratings: [[Double]] = [
            [ 5, 5, 0, 0],
            [ 5,-1,-1, 0],
            [-1, 4, 0,-1],
            [ 0, 0, 5, 4],
            [ 0, 0, 5,-1],
        ]
        
        collabFiltering(ratings)
    }
    
    func testSimilarToCoursera() {
        let ratings: [[Double]] = [
            [ 5, 5, 0, 0],
            [ 5, 5, 0, 0],
            [ 5, 4, 0, 0],
            [ 0, 0, 5, 5],
            [ 0, 0, 5, 5],
        ]
        
        collabFiltering(ratings)
    }

    func testInsuficcientFeatures() {
        let ratings: [[Double]] = [
            [ 1, 0, 0, 0],
            [ 0, 1, 0, 0],
            [ 0, 0, 1, 0],
            [ 0, 0, 0, 1],
            [ 0, 0, 0, 1],
        ]
        
        collabFiltering(ratings)
    }
    
    func collabFiltering(ratings: [[Double]]) {
        let isRatingPresent = ratings.map({$0.map({$0 != Double(-1)}) })
        print(isRatingPresent)
        
        let cf = CollabFiltering(
            numProducts: 5,
            numUsers: 4,
            numFeatures: 2,
            ratings: ratings,
            isRatingPresent: isRatingPresent,
            alpha: 0.001)
        cf.descend(Double(1), iterations:1000)
        
        print("cf.featuresOfProducts")
        print(cf.featuresOfProducts)
        
        print("cf.userPreferenceForFeatures")
        print(cf.userPreferenceForFeatures)

        print("cf.ratingPredictions()")
        let predictions = cf.ratingPredictions()
        for p in predictions {
            print(p)
        }
    }
}
