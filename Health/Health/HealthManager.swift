//
//  HealthManager.swift
//  Health
//
//  Created by Vincenzo Eboli on 15/11/23.
//

import SwiftUI
import HealthKit
import HealthKitUI

extension Double{
    func formattedString()->String {
        let numberFormatter=NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
extension  Date{
    static var startOfTheDay:Date{
        Calendar.current.startOfDay(for: Date())
    }
}
class HealthManager:ObservableObject{
    @Published var activities:[String:Activity]=[:]
    
    let healthStore=HKHealthStore()
    init(){
        let calories=HKQuantityType(.activeEnergyBurned)
        let steps=HKQuantityType(.stepCount)
        let sleepSampleType = HKCategoryType(.sleepAnalysis)
        
        let healthTypes:Set=[steps,calories,sleepSampleType]
        Task{
            do{
                try await  healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
            } catch{
                print("couldn't get \(healthTypes) permission")
            }
        }
        
    }
    func fetchTodaySteps(){
        let steps=HKQuantityType(.stepCount)
        let predicate=HKQuery.predicateForSamples(withStart: .startOfTheDay, end: Date())
        let query=HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate){_,result,error in
            guard let quantity=result?.sumQuantity(), error == nil
            else{
                print("couldn't get steps")
                return
            }
            let stepsCount=quantity.doubleValue(for: .count())
            let activity=Activity(id: 0, title: "steps", subtitle: "Goal:10,000", image: "figure.walk", amount: stepsCount.formattedString())
            DispatchQueue.main.async{
                self.activities["steps"]=activity
            }
        }
        
        healthStore.execute(query)
        
    }
    func fetchTodayCalories(){
        let calories=HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart:.startOfTheDay, end: Date())
        let query=HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) {_,result,error in
            guard let quantity=result?.sumQuantity(), error == nil else{
                print("couldn't get calories")
                return
            }
            let Calories=quantity.doubleValue(for: .kilocalorie())
            let activity=Activity(id: 1, title: "calories", subtitle: "Goal:500", image:"flame", amount: Calories.formattedString())
            DispatchQueue.main.async {
                self.activities["calories"]=activity
            }
        }
        healthStore.execute(query)
    }
    /*
     func processDataSleep() {
        let sleepType = HKCategoryTypeIdentifier.sleepAnalysis
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sleepQuery = HKCategoryQuery(quantityType: HKObjectType.categoryType(forIdentifier: sleepType)!, predicate: predicate) { _, results, error in
            guard error == nil else {
                print("couldn't get sleepDatas")
                return
            }
            
            if let quantitySamples = results?.quantitySamples {
                let sleepCategoryValues = quantitySamples.map { $0.value }
                let sleepCategoryCount = sleepCategoryValues.reduce(0, +)
                print("Total asleep time: \(sleepCategoryCount) hours")
            }
        }
        healthStore.execute(sleepQuery)
    }*/
}

    
