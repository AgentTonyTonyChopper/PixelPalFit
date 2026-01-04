import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), state: .low, gender: .male)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let state = SharedData.loadState()
        let gender = SharedData.loadGender() ?? .male
        let entry = SimpleEntry(date: Date(), state: state, gender: gender)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let state = SharedData.loadState()
        let gender = SharedData.loadGender() ?? .male

        // Create entries for the next hour (refresh every 15 minutes)
        var entries: [SimpleEntry] = []
        for minuteOffset in stride(from: 0, to: 60, by: 15) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, state: state, gender: gender)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Timeline Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let state: AvatarState
    let gender: Gender
}

// MARK: - Widget View

struct PixelPalWidgetEntryView: View {
    var entry: Provider.Entry

    /// Frame selection based on minute (static snapshot, changes on refresh)
    private var frameNumber: Int {
        let minute = Calendar.current.component(.minute, from: entry.date)
        return (minute % 2) + 1
    }

    var body: some View {
        let spriteName = SpriteAssets.spriteName(
            gender: entry.gender,
            state: entry.state,
            frame: frameNumber
        )

        VStack(spacing: 8) {
            Image(spriteName)
                .resizable()
                .interpolation(.none)
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)

            Text(entry.state.description)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

// MARK: - Home Screen Widget

struct PixelPalHomeWidget: Widget {
    let kind: String = "PixelPalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PixelPalWidgetEntryView(entry: entry)
                    .containerBackground(.black, for: .widget)
            } else {
                PixelPalWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color.black)
            }
        }
        .configurationDisplayName("Pixel Pal")
        .description("Your ambient walking companion.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Widget Bundle

@main
struct PixelPalWidgetBundle: WidgetBundle {
    var body: some Widget {
        PixelPalHomeWidget()
        PixelPalLiveActivity()
    }
}
