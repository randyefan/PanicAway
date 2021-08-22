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
        if let entry = getDefaultBreathing() {
            completion(entry)
        }
        
        fatalError("cant get default breathing")
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BreathingModel>) -> Void) {
        if let entry = getDefaultBreathing() {
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
        
        fatalError("cant get default breathing")
    }
    
    func placeholder(in context: Context) -> BreathingModel {
        if let entry = getDefaultBreathing() {
            return entry
        }
        
        fatalError("cant get default breathing")
    }

    func getDefaultBreathing() -> BreathingModel? {
        let data = BreathingLoader()
        data.loadDataBreath()
        if let userDefault = UserDefaults(suiteName: "group.com.panicaway.javier.mc3") {
            let breathingId = userDefault.integer(forKey: "defaultBreatheId")
            return data.entries[breathingId]
        }
        
        return nil
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
            
            
        }.widgetURL(URL(string: "panicaway://open"))
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

