//
//  SampleIntentWidgets.swift
//  SampleTimelineWidgetExtension
//
//  Created by Balaji Pandian on 29/07/20.
//

import WidgetKit
import SwiftUI
import Photos
import Intents

struct SampleIntentProvider: IntentTimelineProvider {
    
    typealias Entry = SampleIntentSimpleEntry
    
    typealias Intent = SampleIntentConfigIntent
    
    func snapshot(for configuration: SampleIntentConfigIntent, with context: Context, completion: @escaping (SampleIntentSimpleEntry) -> ()) {
        let entry = SampleIntentSimpleEntry(date: Date(), configuration: configuration, totgallery: GetTotalGallery.getAll(), gallery: GetGallery.getAllPhotos())
        completion(entry)
    }
    
    func timeline(for configuration: SampleIntentConfigIntent, with context: Context, completion: @escaping (Timeline<SampleIntentSimpleEntry>) -> ()) {
        
        var entries: [SampleIntentSimpleEntry] = []
        
        let selected = configuration.sample.rawValue
        
        switch selected {
        case 1:
            let entry = SampleIntentSimpleEntry(date: Date(), configuration: configuration, totgallery: GetTotalGallery.getAll(), gallery: GetGallery.getAllPhotos())
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            break;
        case 2:
            let entry = SampleIntentSimpleEntry(date: Date(), configuration: configuration,totgallery: GetTotalGallery.getAll(), gallery: GetGallery.getAllVideos())
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            break;
        case 3:
            let entry = SampleIntentSimpleEntry(date: Date(), configuration: configuration, totgallery: GetTotalGallery.getAll(), gallery: GetGallery.getAllScreenShot())
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            break;
        default:
            if selected != 0 {
                let entry = SampleIntentSimpleEntry(date: Date(), configuration: configuration, totgallery: GetTotalGallery.getAll(), gallery: GetGallery.getAllPhotos())
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            break;
        }
    }

    

}

struct SampleIntentSimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: SampleIntentConfigIntent
    let totgallery : GetTotalGallery
    let gallery : GetGallery
}

struct SampleIntentPlaceholderView : View {
    var body: some View {
        Text("Loading...")
    }
}

struct SampleIntentWidgetsEntryView : View {  // bb
    var entry: SampleIntentProvider.Entry
    
    @Environment(\.widgetFamily) var family
    

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack{
                VStack(alignment : .center){
                    let data = entry.gallery.Details.asset
                    let img = getAssetThumbnail(assets: data as! [PHAsset])
                    Image(uiImage: img.first!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 70, alignment: .center)
                        .clipped()
                        .shadow(radius: 2)
                        .cornerRadius(5.0)
                    HStack {
                        Text("\(entry.gallery.Details.displayName!)").font(Font.subheadline)
                            .multilineTextAlignment(.leading)
                            .lineLimit(0)
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                        Text("\(entry.gallery.Details.asset!.count)")
                            .font(Font.title.bold())
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                          
                    }

                }
                .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.yellow,.green]), startPoint: .top, endPoint: .bottom))
            
        default :
            ZStack {
                HStack {
                    HStack {
                        let data = entry.gallery.Details.asset
                        let img = getAssetThumbnail(assets: data as! [PHAsset])
                        Image(uiImage: img.first!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .clipped()
                            .shadow(radius: 2)
                            .cornerRadius(10.0)
                    }.padding(.all , 10)
                    .frame(alignment: .center)
                    .padding(.top,10)

                    HStack{
                        VStack {
                            Text("\(entry.gallery.Details.displayName!)").font(Font.largeTitle.bold())
                            Text("\(entry.gallery.Details.asset!.count)")
                                .font(Font.title.bold())
                                .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                        }
                    }.padding(.leading , 30)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [.green,.blue,.accentColor]), startPoint: .top, endPoint: .bottom))
            }
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.purple,.black]), startPoint: .top, endPoint: .bottom))
            
        }
    }
    
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
           var arrayOfImages = [UIImage]()
           for asset in assets {
               let manager = PHImageManager.default()
               let option = PHImageRequestOptions()
               var image = UIImage()
               option.isSynchronous = true
               manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                   image = result!
                   arrayOfImages.append(image)
               })
           }

           return arrayOfImages
       }

}

//@main
struct SampleIntentWidgets: Widget {
    private let kind: String = "SampleIntentWidgets"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SampleIntentConfigIntent.self, provider: SampleIntentProvider(), placeholder: SampleIntentPlaceholderView()) { entry in
            SampleIntentWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}
