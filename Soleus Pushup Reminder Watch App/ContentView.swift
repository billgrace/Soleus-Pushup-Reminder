//
//  ContentView.swift
//  Soleus Pushup Reminder Watch App
//
//  Created by Bill Grace on 2/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sessionIsActive = true
    @State private var sessionStartHour = 12
    @State private var sessionStartMinute = 0
    @State private var sessionFinishHour = 16
    @State private var sessionFinishMinute = 0
    @State private var minutesBetweenAlerts = 5
    @State private var timerInterruptCount = 0
    @State private var reminderCount = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Picker("", selection: $sessionStartHour){
                        ForEach(0...23, id: \.self) { i in
                            Text("\(i)")
                        }
                    }
                    Text(":")
                    Picker("", selection: $sessionStartMinute){
                        ForEach(0...59, id: \.self) { i in
                            Text("\(i)")
                        }
                    }
                    Text("/")
                    Picker("", selection: $sessionFinishHour){
                        ForEach(0...23, id: \.self) { i in
                            Text("\(i)")
                        }
                    }
                    Text(":")
                    Picker("", selection: $sessionFinishMinute){
                        ForEach(0...59, id: \.self) { i in
                            Text("\(i)")
                        }
                    }
                }
                Image("SoleusPushupReminderIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                HStack {
                    Text(sessionIsActive ? "Running" : "Paused")
                    Text(nowIsWithinSessionTime() ? "active" : "dormant")
                }
                Button("Toggle running") {
                    sessionIsActive.toggle()
                }
            }
            .sensoryFeedback(.success, trigger: reminderCount)
            .onReceive(timer, perform: { _ in
                timerInterruptCount += 1
                if timerInterruptCount >= (60 * minutesBetweenAlerts) {
                    timerInterruptCount = 0
                    if sessionIsActive && nowIsWithinSessionTime() {
                        reminderCount += 1
                    }
                }
            })
        }
    }

    func nowIsWithinSessionTime() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)
        // If the current time is the same or later than the session start time AND
        // the current time is earlier than the session finish time THEN
        // we return true, otherwise false
        if time1IsEqualToOrLaterThanTime2(Time1Hour: currentHour, Time1Minute: currentMinute, Time2Hour: sessionStartHour, Time2Minute: sessionStartMinute) {
            // The current time is later than or the same as the start time
            if time1IsEqualToOrLaterThanTime2(Time1Hour: sessionFinishHour, Time1Minute: sessionFinishMinute, Time2Hour: currentHour, Time2Minute: currentMinute) {
                // The finish time is later than or the same as the start time so the current time is between the start and finish times
                return true
            } else {
                // The current time is later than the finish time
                return false
            }
        } else {
            // The current time is earler than the start time
            return false
        }
    }
    
    func time1IsEqualToOrLaterThanTime2(Time1Hour: Int, Time1Minute: Int, Time2Hour: Int, Time2Minute: Int) -> Bool {
        if Time1Hour == Time2Hour {
            // hours are the same
            if Time1Minute < Time2Minute {
                // Time1 is earlier than Time2
                return false
            } else {
                // Time1 is later than or the same as Time2
                return true
            }
        } else if Time1Hour > Time2Hour {
            // Time1 is later than Time2
            return true
        } else {
            // Time 1 is earlier than Time2
            return false
        }
    }
}

#Preview {
    ContentView()
}
