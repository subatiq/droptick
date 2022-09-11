//
//  SandleakWidget.swift
//  SandleakWidget
//
//  Created by Владимир Семенов on 10.09.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}


struct SmallWidgetView: View {
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var total: Int
    @State var secondsLeft: Int
    
    var body: some View {
    VStack(alignment: .center) {
        Text("Unused minutes".uppercased())
            .multilineTextAlignment(.center)
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(Color("AccentColor").opacity(0.75))
        .padding(.top, 15)
        HStack {
            Text("\(UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "totalTimePassed"))")
                .font(.system(size: 50, weight: .black))
                .foregroundColor(.yellow)
            
            
        }
        .padding(.bottom)
//        Text(":\(secondsLeft)")
//            .font(.system(size: 20, weight: .black))
//            .foregroundColor(.yellow)
//        }
    .onReceive(timer) {date in
        var sleepTime = UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "sleepTime")
        var minutesUsed = UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "totalTimeUsed")
        secondsLeft = Date().secondsSinceMidnight - 60 * Date().minutesSinceMidnight
        var minutesToday = Date().minutesSinceMidnight
        var totalTimePassed = Date().minutesSinceMidnight - minutesUsed - sleepTime
    }
    }
    
}

struct MediumWidgetView : View {
    @State var total: Int
    @State var secondsLeft: Int
    @State var sleepTime: Int
    
    var body: some View {
        HStack {
            SmallWidgetView(total: total, secondsLeft: secondsLeft)
                .padding()
                .padding(.leading, 25)
            Spacer()
            VStack(alignment: .trailing) {
                HStack(alignment: .center) {
                    Text("SLEEP".uppercased())
                        .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("AccentColor").opacity(0.75))
                    .padding(.top, 3)
                    Text("\(sleepTime)")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Color("AccentColor"))
                }
                HStack(alignment: .center) {
                    Text("USED".uppercased())
                        .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("AccentColor").opacity(0.75))
                    .padding(.top, 3)
                    Text("\(UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "totalTimePassed"))")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding()
            .padding(.trailing, 25)
        }
    }
}

extension Date {
    var startOfCurrentDay: Date {
        return Calendar.current.startOfDay(for: Date.now)
    }
    var secondsSinceMidnight: Int {
        return Int(self.timeIntervalSince(startOfCurrentDay))
    }
    var minutesSinceMidnight: Int {
        return secondsSinceMidnight / 60
    }
}

struct SandleakWidgetEntryView : View {
    var entry: Provider.Entry
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var sleepTime = UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "sleepTime")
    @State var minutesUsed = UserDefaults(suiteName: "group.com.subatiq.sandleak")!.integer(forKey: "totalTimeUsed")
    @State var secondsLeft = Date().secondsSinceMidnight - 60 * Date().minutesSinceMidnight
    @State var minutesToday = Date().minutesSinceMidnight
    @State var totalTimePassed = Date().minutesSinceMidnight
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            Color("WidgetBackground")
            switch widgetFamily {
                case .systemSmall:
                SmallWidgetView(total: totalTimePassed, secondsLeft: secondsLeft)
                case .systemMedium:
                MediumWidgetView(total: totalTimePassed, secondsLeft: secondsLeft, sleepTime: sleepTime)
                default:
                    SmallWidgetView(total: totalTimePassed, secondsLeft: secondsLeft)
            }
        }
        
    }
}

@main
struct SandleakWidget: Widget {
    let kind: String = "SandleakWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SandleakWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sandleak")
        .description("Keep an eye on the time you have today")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct SandleakWidget_Previews: PreviewProvider {
    static var previews: some View {
        SandleakWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        SandleakWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
