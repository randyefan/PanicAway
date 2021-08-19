//
//  PanicAway_Widget.swift
//  PanicAway Widget
//
//  Created by Javier Fransiscus on 19/08/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (BreathingModel) -> Void) {
        let data = BreathingLoader()
        data.loadDataBreath()
        let entry = data.entries[2]
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BreathingModel>) -> Void) {
        let data = BreathingLoader()
        data.loadDataBreath()
        let entry = data.entries[2]
        
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> BreathingModel {
        let data = BreathingLoader()
        data.loadDataBreath()
        return data.entries[2]
    }

    func getDefaultBreathing() -> BreathingModel{
        let data = BreathingLoader()
        data.loadDataBreath()
        if let userDefault = UserDefaults(suiteName: "group.com.panicaway.javier") {
            
        }
//        print(breathingCycle)
        
//        return data.entries[breathingCycle]
    }
}

struct PanicAway_WidgetEntryView : View {
    let provider:Provider.Entry
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack{
            Image(colorScheme == .dark ? "WidgetBackgroundDark":"WidgetBackgroundLight")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 5){
                    Text("Panic Away")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color("Main") : Color.black)
                    Text("Breathe and ask for help")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color("MainHard"))
                    
                }.frame(alignment: .topLeading)
                Spacer()
                HStack{
                    Spacer()
                    Text(provider.breathingName).font(.system(size: 22, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color("Main") : Color.black)
                }
            }.padding()
            
            
        }
    }
    
}



@main
struct PanicAway_Widget: Widget {
    let kind: String = "PanicAway_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            PanicAway_WidgetEntryView(provider: entry)
        })
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

