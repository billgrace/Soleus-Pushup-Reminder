//
//  Complication.swift
//  Complication
//
//  Created by Bill Grace on 2/6/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Reminder {
        .example
    }

    func getSnapshot(in context: Context, completion: @escaping (Reminder) -> ()) {
        let entry = Reminder.example
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [Reminder] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            _ = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = Reminder.example
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct Reminder: TimelineEntry {
    let date: Date
    let longReminder: String
    let shortReminder: Image
    
    static let example = Reminder(date: .now, longReminder: "Push those toes!", shortReminder: Image("LightFoot").resizable())
}

struct ComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image("LightFoot").resizable()
//        VStack {
//            HStack {
//                Text("Time:")
//                Text(entry.date, style: .time)
//            }
//
//            Text("Pic:")
//            Image("LightFoot").resizable()
////            Text("Emoji:")
////            Text(entry.emoji)
//        }
    }
}

@main
struct Complication: Widget {
    let kind: String = "Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                ComplicationEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ComplicationEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Soleus Pushup Reminder")
        .description("Reminder to excersize")
    }
}

#Preview(as: .accessoryRectangular) {
    Complication()
} timeline: {
    Reminder.example
    Reminder.example
}
