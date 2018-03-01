//
//  ViewController.swift
//  HealthKitTest
//
//  Created by diana on 10/12/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import HealthKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var vitalsInformationJsonTextView: UITextView!
    
    var vitalsInformation: VitalsInformation!
    
    var healthStore : HKHealthStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vitalsInformation = VitalsInformation()
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            self.healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead(), completion: { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    
                    self.fetchBirthday()
                    self.fetchBiologicalSex()
                    self.fetchBloodType()
                    self.fetchSkinType()
                    self.fetchHeight()
                    self.fetchWeight()
                    self.fetchHeartRate()
                    self.fetchStepCount()
                    self.fetchSleepAnalysis()
                    self.fetchBloodGlucose()
                    self.fetchBloodPressureSystolic()
                    self.fetchBloodPressureDiastolic()
                    self.fetchOxygen()
                    DispatchQueue.main.async {
                        self.fillHealthKitInfo()
                    }
                }
            })
        }

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    private func dataTypesToRead() -> Set<HKObjectType> {
        
        let dietaryCalorieEnergyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let birthdayType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType)!
        let fitzpatrickSkinType = HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let bloodPressureSystolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let bloodPressureDiastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let oxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!

        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType,heightType,weightType,birthdayType,biologicalSexType,bloodType,fitzpatrickSkinType, heartRateType,sleepAnalysisType,stepCountType,bloodGlucoseType,bloodPressureSystolicType,bloodPressureDiastolicType,oxygenType]
        return readDataTypes
    }
    
    private func fetchBirthday() {
        if let birthDate = try? self.healthStore.dateOfBirthComponents().date {
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .short
            self.vitalsInformation.birthday = dateFormater.string(from: birthDate!)
            print("BirthDay: \(self.vitalsInformation.birthday)")
        }
    }
    
    private func fetchBiologicalSex() {
        if let biologicalSex = try? self.healthStore.biologicalSex() {
            switch biologicalSex.biologicalSex {
            case .notSet:
                self.vitalsInformation.biologicalSex = "Not Set"
            case .female:
                self.vitalsInformation.biologicalSex = "Female"
            case .male:
                self.vitalsInformation.biologicalSex = "Male"
            default:
                self.vitalsInformation.biologicalSex = "Other"
            }
            print("Biological Sex: \(self.vitalsInformation.biologicalSex)")
        }
    }
    
    private func fetchBloodType() {
        if let bloodType = try? self.healthStore.bloodType() {
            switch bloodType.bloodType {
            case .notSet:
                self.vitalsInformation.bloodType = "Not Set"
            case .aPositive:
                self.vitalsInformation.bloodType = "A+"
            case .aNegative:
                self.vitalsInformation.bloodType = "A-"
            case .bPositive:
                self.vitalsInformation.bloodType = "B+"
            case .bNegative:
                self.vitalsInformation.bloodType = "B-"
            case .abPositive:
                self.vitalsInformation.bloodType = "AB+"
            case .abNegative:
                self.vitalsInformation.bloodType = "AB-"
            case .oPositive:
                self.vitalsInformation.bloodType = "O+"
            case .oNegative:
                self.vitalsInformation.bloodType = "O-"
            }
            print("Blood Type: \(self.vitalsInformation.bloodType)")
        }
    }
    
    private func fetchSkinType() {
        if let skinType = try? self.healthStore.fitzpatrickSkinType() {
            switch skinType.skinType {
            case .notSet:
                self.vitalsInformation.skinType = "Not Set"
            case .I:
                self.vitalsInformation.skinType = "I"
            case .II:
                self.vitalsInformation.skinType = "II"
            case .III:
                self.vitalsInformation.skinType = "III"
            case .IV:
                self.vitalsInformation.skinType = "IV"
            case .V:
                self.vitalsInformation.skinType = "V"
            case .VI:
                self.vitalsInformation.skinType = "VI"
            }
            print("Skin Type: \(self.vitalsInformation.skinType)")
        }
    }
    
    private func fetchHeight() {
        let heightType = HKSampleType.quantityType(forIdentifier: .height)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let heightQuery = HKSampleQuery(sampleType: heightType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.height = result.quantity.doubleValue(for: HKUnit.meter()) * 100
                print("Height: \(self.vitalsInformation.height)cm")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting height error: \(error.localizedDescription)")
            }
        }
        self.healthStore.execute(heightQuery)
    }
    
    private func fetchWeight() {
        let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let weightQuery = HKSampleQuery(sampleType: weightType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.weight = result.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                print("Weight: \(self.vitalsInformation.weight)kg")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting weight error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(weightQuery)
    }
    

    private func fetchStepCount() {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let stepCountQuery = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: mostRecentPredicate, options: .cumulativeSum) { (query, result, error) in
            if let sum = result?.sumQuantity() {
                self.vitalsInformation.steps = Int(sum.doubleValue(for: HKUnit.count()))
                print("Step Count: \(self.vitalsInformation.steps)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting step count error: \(error.localizedDescription)")
            }
        }
        self.healthStore.execute(stepCountQuery)
    }
    
    private func fetchHeartRate() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.hearRate = Int(result.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
                print("Heart Rate: \(self.vitalsInformation.hearRate)bpm")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting heart rate error: \(error.localizedDescription))")
            }
        }
        
        self.healthStore.execute(heartRateQuery)
    }
    
    private func fetchBloodPressureSystolic() {
        let fetchBloodPressureSystolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let fetchBloodPressureSystolicQuery = HKSampleQuery(sampleType: fetchBloodPressureSystolicType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.bloodPressureSystolic = Int(result.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                print("Blood Pressure: \(self.vitalsInformation.bloodPressureSystolic)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting heart rate error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(fetchBloodPressureSystolicQuery)
    }
    
    private func fetchBloodPressureDiastolic() {
        let fetchBloodPressureDiastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let fetchBloodPressureDiastolicQuery = HKSampleQuery(sampleType: fetchBloodPressureDiastolicType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.bloodPressureDiastolic = Int(result.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                print("Heart Rate: \(self.vitalsInformation.bloodPressureDiastolic)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting heart rate error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(fetchBloodPressureDiastolicQuery)
    }
    
    private func fetchBloodGlucose() {
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let bloodGlucoseQuery = HKSampleQuery(sampleType: bloodGlucoseType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.bloodGlucose = Double(result.quantity.doubleValue(for: HKUnit.moleUnit(withMolarMass: HKUnitMolarMassBloodGlucose)))
                print("Blood Glucose: \(self.vitalsInformation.bloodGlucose)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting heart rate error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(bloodGlucoseQuery)
    }
    
    private func fetchOxygen() {
        let oxgenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let oxgenQuery = HKSampleQuery(sampleType: oxgenType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                self.vitalsInformation.oxygen = Double(result.quantity.doubleValue(for: HKUnit.percent().unitDivided(by: HKUnit.millimeterOfMercury())))
                print("Blood Glucose: \(self.vitalsInformation.bloodGlucose)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting heart rate error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(oxgenQuery)
    }

    
    private func fetchSleepAnalysis() {
        let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sleepAnalysisQuery = HKSampleQuery(sampleType: sleepAnalysisType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let result = results?.first as? HKCategorySample {
                if let sleepAnalysis = HKCategoryValueSleepAnalysis(rawValue: result.value) {
                    switch (sleepAnalysis) {
                    case .inBed:
                        self.vitalsInformation.sleep = "In Bed"
                    case .asleep:
                        self.vitalsInformation.sleep = "Asleep"
                    case .awake:
                        self.vitalsInformation.sleep = "Awake"
                    }
                }
                print("Sleep Analysis: \(self.vitalsInformation.sleep)")
                DispatchQueue.main.async {
                    self.fillHealthKitInfo()
                }
            } else if let error = error {
                print("Getting sleep analysis error: \(error.localizedDescription))")
            }
        }
        self.healthStore.execute(sleepAnalysisQuery)
    }


    private func fillHealthKitInfo() {
        detailTextView.text = "Heart Rate: \(self.vitalsInformation.hearRate)bpm" + "\n" +
        "Sleep Analysis: \(self.vitalsInformation.sleep)" + "\n" +
        "Blood Pressure Systolic: \(self.vitalsInformation.sleep)" + "\n" +
        "Blood Pressure Diastolic: \(self.vitalsInformation.sleep)" + "\n" +
        "Blood Glucose: \(self.vitalsInformation.bloodGlucose)" + "\n" +
        "Weight: \(self.vitalsInformation.weight)" + "\n" +
        "Height: \(self.vitalsInformation.height)" + "\n" +
        "Oxygen: \(self.vitalsInformation.oxygen)" + "\n" +
        "Birthday: \(self.vitalsInformation.birthday)" + "\n" +
        "Bloodtype: \(self.vitalsInformation.bloodType)" + "\n" +
        "SkinType: \(self.vitalsInformation.skinType)" + "\n" +
        "BiologicalSex: \(self.vitalsInformation.biologicalSex)" + "\n" +
        "Step Count: \(self.vitalsInformation.steps)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTappedSendButton(_ sender: Any) {
        var dic = Dictionary<String, Any>()

        dic["step"] = vitalsInformation.steps
        dic["hearRate"] = vitalsInformation.hearRate
        dic["sleep"] = vitalsInformation.sleep
        dic["bloodPressureSystolic"] = vitalsInformation.bloodPressureSystolic
        dic["bloodPressureDiastolic"] = vitalsInformation.bloodPressureDiastolic
        dic["bloodGlucose"] = vitalsInformation.bloodGlucose
        dic["birthday"] = vitalsInformation.birthday
        dic["biologicalSex"] = vitalsInformation.biologicalSex
        dic["bloodType"] = vitalsInformation.bloodType
        dic["skinType"] = vitalsInformation.skinType
        dic["height"] = vitalsInformation.height
        dic["weight"] = vitalsInformation.weight
        dic["oxygen"] = vitalsInformation.oxygen

        vitalsInformationJsonTextView.text = dic.description
    }
}

