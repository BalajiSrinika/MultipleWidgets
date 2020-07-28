//
//  SampleTimelineWidget.swift
//  SampleTimelineWidget
//
//  Created by Balaji Pandian on 27/07/20.
//

import WidgetKit
import SwiftUI
import Photos

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry
    
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), gallery: GetPhotoAsset.getAllPhotos())
        completion(entry)
    }
    
    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), gallery: GetPhotoAsset.getAllPhotos())
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    let gallery : GetPhotoAsset
}

struct PlaceholderView : View {
    var body: some View {
        Text("Loading...")
    }
}

struct SampleTimelineWidgetEntryView : View {  // bb
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {  // bb
        switch family {
        case .systemSmall:
            ZStack{
                VStack(alignment : .center){
                    Image("gallery")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 70, alignment: .center)
                        .clipped()
                        .shadow(radius: 2)
                        .cornerRadius(5.0)
                    HStack {
                        Text("Photos").font(Font.headline.bold())
                        Text("\(entry.gallery.allPhotos.count)")
                            .font(Font.title.bold())
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                    }
                    
                }
                .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .background(Color.pink)
            
        default:
            ZStack {
                HStack {
                    HStack {
                        let data = entry.gallery.allPhotos
                        let img = getAssetThumbnail(assets: data as! [PHAsset])
                        let rand = img.randomElement()!
                        Image(uiImage: rand)
                            // Image("photo")
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
                            Text("Photos").font(Font.largeTitle.bold())
                            Text("\(entry.gallery.allPhotos.count)")
                                .font(Font.title.bold())
                                .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                        }
                    }.padding(.leading , 30)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [.yellow,.orange]), startPoint: .top, endPoint: .bottom))
            }
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
struct SampleTimelineWidget: Widget {
    private let kind: String = "SampleTimelineWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            SampleTimelineWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}




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
                .padding().foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                VStack {
                    Text("Videos").font(.largeTitle)
                    Text("\(entry.totgallery.allVideos.count)").padding().font(.largeTitle)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4)
                        )
                }.padding().frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
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


// Mark:- Inherit Multiple Widgets
@main
struct CombineWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        AdditionalTimelineWidget()
        SampleTimelineWidget()
      
    }
}

struct SampleTimelineWidget_Previews: PreviewProvider {
    static var previews: some View {
        SampleTimelineWidgetEntryView(entry: SimpleEntry(date: Date(), gallery: GetPhotoAsset.getAllPhotos()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
