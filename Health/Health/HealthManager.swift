import SwiftUI
import HealthKit
import HealthKitUI

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Date {
    static var startOfTheDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    @Published var activities: [String: Activity] = [:]
    @Published var mockActivities: [String:Activity]=[:]
    let healthStore = HKHealthStore()
    
    init() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let steps = HKQuantityType(.stepCount)
        let sleepSampleType = HKCategoryType(.sleepAnalysis)
        let audioSampleType = HKCategoryType(.headphoneAudioExposureEvent)
        let healthTypes: Set = [steps, calories, sleepSampleType, audioSampleType]
   
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                processDataLastNightSleep()
                processHeadphoneExposureWithGoal()
            } catch {
                print("Couldn't get \(healthTypes) permission")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfTheDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Couldn't get steps")
                return
            }
            
            let stepsCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: stepsCount.formattedString())
            let mockActivity = Activity(id: 0, title: "Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "12,000")
            DispatchQueue.main.async {
                self.activities["Steps"] = activity
                self.mockActivities["Steps"]=mockActivity
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfTheDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Couldn't get calories")
                return
            }
            
            let caloriesCount = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Calories", subtitle: "Goal: 500", image: "flame", amount: caloriesCount.formattedString())
            let mockActivity = Activity(id: 1, title: "Calories", subtitle: "Goal: 500", image: "flame", amount: "230")
            DispatchQueue.main.async {
                self.activities["Calories"] = activity
                self.mockActivities["Calories"]=mockActivity
            }
        }
        
        healthStore.execute(query)
    }
    
    func processDataLastNightSleep() {
        let sleepType = HKCategoryTypeIdentifier.sleepAnalysis
        let currentDate = Date()
        let endDate = Calendar.current.startOfDay(for: currentDate)
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sleepQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: sleepType)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, error in
            guard error == nil else {
                print("Couldn't get sleep data: \(error!.localizedDescription)")
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
                
                let activity = Activity(id: 2, title: "Sleep", subtitle: "Goal: 8hrs", image: "bed.double", amount: formattedDuration)
                let mockActivity = Activity(id: 2, title: "Sleep", subtitle: "Goal: 8hrs", image: "bed.double", amount:"5 hrs")
                DispatchQueue.main.async {
                    self.activities["Sleep"] = activity
                    self.mockActivities["Sleep"]=mockActivity
                }
            }
        }
        healthStore.execute(sleepQuery)
    }
    
    func processHeadphoneExposureWithGoal() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available")
            return
        }

        let audioExposureType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.environmentalAudioExposureEvent)!
        let authorized = healthStore.authorizationStatus(for: audioExposureType) == .sharingAuthorized

        guard authorized else {
            print("Audio exposure data not authorized")
            return
        }

        let currentDate = Date()
        let endDate = Calendar.current.startOfDay(for: currentDate)
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        let headphoneExposureQuery = HKSampleQuery(sampleType: audioExposureType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, error in
            guard error == nil else {
                print("Couldn't get headphone exposure data: \(error!.localizedDescription)")
                return
            }

            if let samples = results as? [HKCategorySample] {
                for sample in samples {
                    print("Audio Exposure Sample:")
                    print("Start Date: \(sample.startDate)")
                    print("End Date: \(sample.endDate)")
                    print("Value: \(sample.value)")

                    let exposureDuration = sample.endDate.timeIntervalSince(sample.startDate)
                    let safeExposureLimit = 4 * 60 * 60.0
                    let exposurePercentage = min((exposureDuration / safeExposureLimit) * 100, 100.0)

                    print("Headphone exposure duration: \(exposureDuration) seconds")
                    let activityKey = "Headphone Exposure" // Chiave corretta per l'attività di esposizione dell'audio
                    let activity = Activity(id: 4, title: "Headphone Exposure", subtitle: "Goal: \(Int(exposurePercentage))%", image: "headphones", amount: "\(Int(exposurePercentage))%")
                    let mockActivity = Activity(id: 4, title: "Headphone Exposure", subtitle: "Goal: \(Int(exposurePercentage))%", image: "headphones", amount: "\(Int(exposurePercentage))%")

                    DispatchQueue.main.async {
                        self.activities[activityKey] = activity
                        self.mockActivities[activityKey] = mockActivity
                    }
                }
            }
        }
        healthStore.execute(headphoneExposureQuery)
    }

}
