//
//  VitalsInformation.swift
//  HealthKitTest
//
//  Created by diana on 18/10/2017.
//  Copyright © 2017 diana. All rights reserved.
//

import UIKit

class VitalsInformation {
    var birthday: String!
    var biologicalSex : String!
    var bloodType : String!
    var skinType : String!
    var height : Double!
    var weight : Double!

    var steps: Int!
    var hearRate: Int!
    var sleep: String!
    var bloodPressureSystolic: Int!
    var bloodPressureDiastolic: Int!
    var bloodGlucose: Double!
    var oxygen: Double!

    init(){
        self.steps = 0
        self.hearRate = 0
        self.sleep = ""
        self.bloodPressureSystolic = 0
        self.bloodPressureDiastolic = 0
        self.bloodGlucose = 0
        self.oxygen = 0
        self.birthday = ""
        self.biologicalSex = ""
        self.bloodType = ""
        self.skinType = ""
        self.height = 0
        self.weight = 0
    }
}
