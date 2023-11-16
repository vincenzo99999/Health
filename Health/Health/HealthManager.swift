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
                processDataLastNightSleep()
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

    func processDataLastNightSleep() {
        let sleepType = HKCategoryTypeIdentifier.sleepAnalysis

        // Get the current date and time
        let currentDate = Date()

        // Set the end date to the start of the current day
        let endDate = Calendar.current.startOfDay(for: currentDate)

        // Set the start date to the start of the day before the current day
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        let sleepQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: sleepType)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, error in
            guard error == nil else {
                print("Couldn't get sleepDatas: \(error!.localizedDescription)")
                return
            }

            if let sample = results?.first as? HKCategorySample {
                print("Last Night's Sleep Sample Details:")
                print("Start Date: \(sample.startDate)")
                print("End Date: \(sample.endDate)")
                print("Value: \(sample.value)")

                let sleepDuration = sample.endDate.timeIntervalSince(sample.startDate)
                let sleepDurationComponents = DateComponents(hour: 0, minute: Int(sleepDuration / 60))
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .positional
                formatter.allowedUnits = [.hour, .minute]
                guard let formattedDuration = formatter.string(from: sleepDurationComponents) else {
                    print("Error formatting sleep duration")
                    return
                }
                print("Last night's sleep duration: \(formattedDuration)")

                let activity = Activity(id: 2, title: "Sleep", subtitle: "Goal: 8hrs", image: " ", amount: formattedDuration)
                DispatchQueue.main.async {
                    self.activities["Sleep"] = activity
                }
            }
        }
        healthStore.execute(sleepQuery)
    }

}

    
