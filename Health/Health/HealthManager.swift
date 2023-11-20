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
    static var oneMonthAgo:Date{
        let calendar=Calendar.current
        let oneMonth=Calendar.current.date(byAdding: .month, value: -1,to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
}
class HealthManager: ObservableObject {
    @Published var activities: [String: Activity] = [:]
    @Published var mockActivities: [String:Activity]=[:]
    @Published var oneMonthChartData=[DailyStepView]()
    @Published var oneMonthChartCaloriesData=[DailyCaloriesView]()
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
                fetchLastNightSleep()
                fetchPastOneMonthCaloriesData()
                fetchPastOneMonthStepData()
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
    
    
    
    func fetchLastNightSleep() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let oggi = Calendar.current.startOfDay(for: Date())
        guard let ieri = Calendar.current.date(byAdding: .day, value: -1, to: oggi) else {
            print("Errore nel calcolare la data della scorsa notte.")
            return
        }
        
        print("Start Date: \(ieri)")
        print("End Date: \(oggi)")
        
        // Predicato per ottenere i dati di sonno dalla scorsa notte
        let predicate = HKQuery.predicateForSamples(withStart: oggi, end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { (_, results, error) in
            guard let samples = results as? [HKCategorySample], error == nil else {
                print("Errore nel recupero dei dati di sonno: \(String(describing: error))")
                return
            }
            
            // Print information about the retrieved samples
            print("Number of samples retrieved: \(samples.count)")
            for sample in samples {
                print("Sample Start Date: \(sample.startDate), End Date: \(sample.endDate), Value: \(sample.value)")
            }
            
            // Calcola le ore di sonno
            let oreDormite = samples.reduce(into: 8) { acc, sample in
                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    let inBedStart = max(sample.startDate, ieri)
                    let inBedEnd = min(sample.endDate, oggi)
                    acc += Int(inBedEnd.timeIntervalSince(inBedStart)) / 3600
                }
            }
            
            print("Ore di sonno della scorsa notte: \(oreDormite) hours")
            
            let activity = Activity(id: 2, title: "Sleep", subtitle: "Last Night", image: "moon", amount: "\(oreDormite) hours")
            DispatchQueue.main.async {
                self.activities["Sleep"] = activity
            }
        }
        healthStore.execute(query)
    }
    func fetchDailyCalories(startDate: Date, endDate: Date, completion: @escaping ([DailyCaloriesView]) -> Void) {
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let interval = DateComponents(day: 1)

        let query = HKStatisticsCollectionQuery(
            quantityType: caloriesType,
            quantitySamplePredicate: nil,
            anchorDate: startDate,
            intervalComponents: interval
        )

        query.initialResultsHandler = { query, result, error in
            guard let result = result else {
                completion([])
                return
            }

            var dailyCalories = [DailyCaloriesView]()

            result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let caloriesCount1 = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.0
                let dailyCalorie = DailyCaloriesView(date: statistics.startDate, caloriesCount: caloriesCount1)
                dailyCalories.append(dailyCalorie)
            }
            completion(dailyCalories)
        }

        healthStore.execute(query)
    }

    func fetchDailySteps(startDate: Date, endDate: Date, completion: @escaping ([DailyStepView]) -> Void) {
            let steps = HKQuantityType(.stepCount)
            let interval = DateComponents(day: 1)

            let query = HKStatisticsCollectionQuery(
                quantityType: steps,
                quantitySamplePredicate: nil,
                anchorDate: startDate,
                intervalComponents: interval
            )

            query.initialResultsHandler = { query, result, error in
                guard let result = result else {
                    completion([])
                    return
                }

                var dailySteps = [DailyStepView]()

                result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let stepCount = statistics.sumQuantity()?.doubleValue(for:.count()) ?? 0.0
                    let dailyStep = DailyStepView(date: statistics.startDate, stepCount: stepCount)
                    dailySteps.append(dailyStep)
                }

                completion(dailySteps)
            }

            healthStore.execute(query)
        }
    func fetchPastOneMonthCaloriesData() {
        let startDate = Date.oneMonthAgo
        let endDate = Date()

        fetchDailyCalories(startDate: startDate, endDate: endDate) { dailyCalories in
            DispatchQueue.main.async {
                self.oneMonthChartCaloriesData = dailyCalories
            }
        }
    }
}

extension HealthManager{
    func fetchPastOneMonthStepData(){
        fetchDailySteps(startDate: .oneMonthAgo, endDate: Date()){ dailySteps in
            DispatchQueue.main.async{
                self.oneMonthChartData=dailySteps
            }
        }
    }
}
