//
//  CollabFiltering.swift
//  RecommendyRecommenderExample
//
//  Created by Peter Prokop on 06/12/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import Foundation

func dotProduct(a: [Double], _ b: [Double]) -> Double {
    // TODO: assert dimensions
    var sum = Double()
    for i in 0 ..< a.count {
        sum += (a[i] * b[i])
    }
    
    return sum
}

func vectorDiff(a: [Double], _ b: [Double]) -> [Double] {
    var diff = [Double](count: a.count, repeatedValue: Double())
        
    for i in 0 ..< a.count {
        diff[i] = a[i] - b[i]
    }
    return diff
}

func vectorNorm(a: [Double]) -> Double {
    var sum = Double()
    for i in 0 ..< a.count {
        sum += a[i] * a[i]
    }
    
    return sum
}

public class CollabFiltering {

    /// "n_m" in original
    var numProducts: Int
    
    /// "n_u" in original
    var numUsers: Int

    var numFeatures: Int

    /// "y" in original
    var ratings: [[Double]]
    
    /// "r" in original
    var isRatingPresent: [[Bool]]
    
    /// "x" in original
    var featuresOfProducts: [[Double]]

    /// "theta" in original
    var userPreferenceForFeatures: [[Double]]

    /**
     - parameter numProducts: number of products
     - parameter numUsers: number of users
     - parameter numFeatures: number of features (should be << than numProducts)
     - parameter ratings: matrix of known ratings (first index - product, second index - user)
     - parameter isRatingPresent: bool matrix which elements indicate what pairs product&user ratings are known (indexing as in *ratings*)
     */
    init(numProducts: Int, numUsers: Int, numFeatures: Int, ratings: [[Double]], isRatingPresent: [[Bool]]) {
        // TODO: assert matrix sizes
        self.numProducts = numProducts
        self.numUsers = numUsers
        self.numFeatures = numFeatures
        self.ratings = ratings
        self.isRatingPresent = isRatingPresent

        // Init "x" and "theta" with small random values
        featuresOfProducts = [[Double]]()
        for _ in 0 ..< numProducts {
            var arr = [Double]()
            for _ in 0 ..< numFeatures {
                arr.append(drand48())
            }
            featuresOfProducts.append(arr)
        }
        
        userPreferenceForFeatures = [[Double]]()
        for _ in 0 ..< numUsers {
            var arr = [Double]()
            for _ in 0 ..< numFeatures {
                arr.append(drand48())
            }
            userPreferenceForFeatures.append(arr)
        }
    }
    
    /**
     Applies gradient descent to the current values of *featuresOfProducts* and *userPreferenceForFeatures*
     
     - parameter alpha: learning rate, shouldn't be too large (compared to elements of *ratings*)
     - parameter lambda: regularization parameter, shouldn't be too large
     - parameter iterations: number of gradient descent iterations
     */
    public func descend(alpha: Double, lambda: Double, iterations: Int) {

        for _ in 0 ..< iterations {
            var tmpX = featuresOfProducts
            var tmpTheta = userPreferenceForFeatures
            
            for i in 0 ..< numProducts {
                for k in 0 ..< numFeatures {
                    tmpX[i][k] = featuresOfProducts[i][k] * (1 - lambda * alpha)
                    
                    var sum = Double()
                    
                    for j in 0 ..< numUsers {
                        if isRatingPresent[i][j] {
                            sum += userPreferenceForFeatures[j][k] * (dotProduct(
                                    userPreferenceForFeatures[j],
                                    featuresOfProducts[i]
                                ) - ratings[i][j])
                        }
                    }
                    tmpX[i][k] -= sum * alpha
                }
            }
            
            for j in 0 ..< numUsers {
                for k in 0 ..< numFeatures {
                    tmpTheta[j][k] = userPreferenceForFeatures[j][k] * (1 - lambda * alpha)
                    
                    var sum = Double()
                    
                    for i in 0 ..< numProducts {
                        if isRatingPresent[i][j] {
                            sum += featuresOfProducts[i][k] * (dotProduct(
                                userPreferenceForFeatures[j],
                                featuresOfProducts[i]
                                ) - ratings[i][j])
                        }
                    }
                    tmpTheta[j][k] -= sum * alpha
                }
            }
            
            featuresOfProducts = tmpX
            userPreferenceForFeatures = tmpTheta
        }
    }
    
    public func ratingPredictions() -> [[Double]] {
        var result = [[Double]]()
        
        for j in 0 ..< numProducts {
            var arr = [Double]()
            
            for i in 0 ..< numUsers {
                arr.append(dotProduct(userPreferenceForFeatures[i], featuresOfProducts[j]))
            }
            result.append(arr)
        }
        
        return result
    }
}