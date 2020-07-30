//
//  AdditionalWidget.swift
//  MultipleWidgets
//
//  Created by Balaji Pandian on 29/07/20.
//

import WidgetKit
import SwiftUI
import Photos

// ---------- Additional widget -----------------//
// Mark:- using Widgetbundle we can add multiple widgets with different entries.

struct AdditionalProvider: TimelineProvider {
  
    typealias Entry = AdditionalSimpleEntry
    
    public func snapshot(with context: Context, completion: @escaping (AdditionalSimpleEntry) -> ()) {
        let entry = AdditionalSimpleEntry(date: Date(), totgallery: GetTotalGallery.getAll())
        completion(entry)
    }
    
    public func timeline(with context: Context, completion: @escaping (Timeline<AdditionalSimpleEntry>) -> ()) {
        var entries: [AdditionalSimpleEntry] = []
        let entry = AdditionalSimpleEntry(date: Date(), totgallery: GetTotalGallery.getAll())
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct AdditionalSimpleEntry: TimelineEntry {
    public let date: Date
    let totgallery : GetTotalGallery
}

struct AdditionalPlaceholderView : View {
    var body: some View {
        Text("wait...")
    }
}

struct AdditionalTimelineWidgetEntryView : View {  // bb
    var entry: AdditionalProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {  // bb
        switch family {
        case .systemMedium:
            HStack {
                VStack(alignment : .center){
                    Text("Photos").font(.largeTitle)
                    Text("\(entry.totgallery.allPhotos.count)").padding().font(.largeTitle)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4)
                        )
                }
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                VStack {
                    Text("Videos").font(.largeTitle)
                    Text("\(entry.totgallery.allVideos.count)").padding().font(.largeTitle)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4)
                        )
                }
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.black]), startPoint: .top, endPoint: .bottom))
            
        default:  // bb
            ZStack {
                VStack {
                    VStack{
                        Text("Photos").font(.largeTitle)
                        Text("\(entry.totgallery.allPhotos.count)").padding().font(.largeTitle)
                            .overlay(Circle().stroke(Color.green, lineWidth: 4)
                            )
                    }
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    VStack(alignment : .center){
                        Text("Videos").font(.largeTitle)
                        Text("\(entry.totgallery.allVideos.count)").padding().font(.largeTitle)
                            .overlay(Circle().stroke(Color.green, lineWidth: 4)
                            )
                    }
                    .foregroundColor(.white)
                    VStack(alignment : .center){
                        Text("Screenshots").font(.largeTitle)
                        Text("\(entry.totgallery.allScreenshots.count)").padding().font(.largeTitle)
                            .overlay(Circle().stroke(Color.green, lineWidth: 4)
                            )
                    }
                    .foregroundColor(.white)
                }
            }
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .top, endPoint: .bottom))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            
        }
    }
}

// @main
struct  AdditionalTimelineWidget: Widget {
    
    private let kind: String = "AdditionalTimelineWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AdditionalProvider(), placeholder: AdditionalPlaceholderView()) { entry in
            AdditionalTimelineWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}
