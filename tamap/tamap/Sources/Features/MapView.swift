//
//  MapView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/31.
//

import SwiftUI
import MapKit

enum SpotCategory {
    case post
    case toilet
    case gourmet
    case other
}

enum Filter: String, CaseIterable, Identifiable {
    case all = "すべて"
    case posts = "みんなのたまポスト"
    case toilet = "乳児用トイレ"
    case gourmet = "グルメ"

    var id: String { self.rawValue }
}

struct Spot: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let isFromAPI: Bool
    let likes: Int
    let post: String? // 投稿テキスト（nilなら表示しない）
    let category: SpotCategory
}

struct MapView: View {
    // 中央は多摩動物公園周辺
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6467, longitude: 139.4353),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @State private var spots: [Spot] = {
        // まず既存の投稿スポットを作る
        let baseLat = 35.6467
        let baseLon = 139.4353
        var list: [Spot] = []
        let postOffsets: [(Double, Double)] = [
            (0.003, 0.001), ( -0.002, 0.002), (0.0015, -0.0015), ( -0.003, -0.0005), (0.0025, 0.003)
        ]
        let samplePosts = [
            "楽しかったー",
            "自然を満喫できた！都会では味わえない！",
            "また来たいなー",
            "子供がすごい喜んでた、また行きたいです！",
            "写真映えスポットって感じで一人でも寄りやすかった！"
        ]
        for i in 0..<postOffsets.count {
            let lat = baseLat + postOffsets[i].0
            let lon = baseLon + postOffsets[i].1
            let likes = Int.random(in: 1...200)
            list.append(Spot(title: "投稿Spot\(i+1)", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), isFromAPI: false, likes: likes, post: samplePosts[i % samplePosts.count], category: .post))
        }

        // 次に、組み込みの施設JSONから多摩地域の「おむつ交換台あり」を抽出してトイレスポットとして追加する
        let facilityJSON = """
[
  {
    "@type": "施設型",
    "名称": { "表記": "みどりコミュニティセンター", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "座標参照系": { "識別値": "JGD2011", "@type": "ID型" }, "経度": "139.803237", "緯度": "35.693553" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "上鷺宮区民活動センター", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.632066", "緯度": "35.731901" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "調布市教育会館", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.541713", "緯度": "35.65024" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "多摩市立複合文化施設（パルテノン多摩）", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.426387", "緯度": "35.621731" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "多摩市立唐木田コミュニティセンター", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.41345", "緯度": "35.615613" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "府中の森公園", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.493109", "緯度": "35.677984" },
    "設備": { "ex:おむつ交換台有無": "○" }
  },
  {
    "@type": "施設型",
    "名称": { "表記": "八王子市富士森公園", "@type": "名称型" },
    "地理座標": { "@type": "座標型", "経度": "139.320648", "緯度": "35.651356" },
    "設備": { "ex:おむつ交換台有無": "○" }
  }
]
"""

        // JSONを汎用的にパースして多摩地域内のおむつ交換台あり施設を抽出
        if let data = facilityJSON.data(using: .utf8) {
            if let arr = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                // 多摩地域の簡易的な境界（緯度: 35.55〜35.75、経度: 139.30〜139.60）でフィルタ
                let minLat = 35.55
                let maxLat = 35.75
                let minLon = 139.30
                let maxLon = 139.60

                for dict in arr {
                    // 名称を抽出
                    var name = "施設"
                    if let nameObj = dict["名称"] as? [String: Any], let label = nameObj["表記"] as? String {
                        name = label
                    }

                    // 地理座標を抽出（構造が様々でも対応）
                    if let geo = dict["地理座標"] as? [String: Any] {
                        var latVal: Double? = nil
                        var lonVal: Double? = nil

                        if let latStr = geo["緯度"] as? String, let lat = Double(latStr) {
                            latVal = lat
                        } else if let latNum = geo["緯度"] as? NSNumber {
                            latVal = latNum.doubleValue
                        }

                        if let lonStr = geo["経度"] as? String, let lon = Double(lonStr) {
                            lonVal = lon
                        } else if let lonNum = geo["経度"] as? NSNumber {
                            lonVal = lonNum.doubleValue
                        }

                        // 設備情報からおむつ交換台の有無を判定
                        var hasDiaper = false
                        if let equip = dict["設備"] as? [String: Any] {
                            for (k, vAny) in equip {
                                let v = String(describing: vAny)
                                if k.contains("おむつ") || k.contains("おむつ交換") || k.contains("おむつ交換台") {
                                    if v.contains("○") { hasDiaper = true }
                                }
                            }
                        }

                        if let lat = latVal, let lon = lonVal, hasDiaper {
                            // 多摩地域内なら追加
                            if lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon {
                                let spot = Spot(title: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), isFromAPI: true, likes: 0, post: name, category: .toilet)
                                list.append(spot)
                            }
                        }
                    }
                }
            }
        }

        // 既存のAPI相当のサンプル（カテゴリ付き）も残す—必要なら削除可
        let apiOffsets: [(Double, Double)] = [
            ( -0.001, 0.004), (0.002, -0.003), ( -0.0025, 0.001), (0.0005, 0.0025), ( -0.0035, 0.002)
        ]
        let apiDescriptions = [
            "都の情報: 開放時間あり",
            "定食屋 藤ノ木",
            "観光スポット",
            "イベント情報あり",
            "逸品居"
        ]
        let apiCategories: [SpotCategory] = [.toilet, .gourmet, .other, .toilet, .gourmet]
        for i in 0..<apiOffsets.count {
            let lat = baseLat + apiOffsets[i].0
            let lon = baseLon + apiOffsets[i].1
            let likes = Int.random(in: 0...500)
            list.append(Spot(title: "API Spot\(i+1)", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), isFromAPI: true, likes: likes, post: apiDescriptions[i % apiDescriptions.count], category: apiCategories[i % apiCategories.count]))
        }

        return list
    }()
    
    @State private var selectedSpotID: UUID? = nil
    @State private var selectedFilter: Filter = .all
    
    // フィルタ適用後の表示用リスト
    private var filteredSpots: [Spot] {
        switch selectedFilter {
        case .all:
            return spots
        case .posts:
            return spots.filter { $0.category == .post }
        case .toilet:
            return spots.filter { $0.category == .toilet }
        case .gourmet:
            return spots.filter { $0.category == .gourmet }
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: filteredSpots) { spot in
                // カスタムアノテーション
                MapAnnotation(coordinate: spot.coordinate) {
                    ZStack { // popup を重ねて表示することで、マーカーの位置変化を防ぐ
                        // マーカー（下層）
                        MarkerBubble(count: spot.likes, color: spot.isFromAPI ? .orange : .blue)
                            .onTapGesture {
                                if selectedSpotID == spot.id {
                                    selectedSpotID = nil
                                } else {
                                    selectedSpotID = spot.id
                                }
                            }
                            .offset(y: 0)
                            .zIndex(0)

                        // ポップアップ（選択時のみ表示）: マーカーの上に重ねる
                        if selectedSpotID == spot.id {
                            VStack(spacing: 4) {
                                if let postText = spot.post {
                                    Text(postText)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text(spot.title)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(8)
                            .background(Color.green)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .offset(y: -40) // マーカーの上に表示する
                            .zIndex(1)
                            // タップで閉じるのを許可
                            .onTapGesture {
                                selectedSpotID = nil
                            }
                        }
                    }
                }
            }
            .navigationTitle("たまっぷ")
            .ignoresSafeArea(edges: .bottom)

            // フィルタUI（画面下に重ねる）
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Filter.allCases) { filter in
                            Button {
                                withAnimation { selectedFilter = filter }
                                // 選択フィルタを変えたら選択中の注釈を閉じる
                                selectedSpotID = nil
                            } label: {
                                Text(filter.rawValue)
                                    .font(.caption2)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(selectedFilter == filter ? Color.green : Color.white.opacity(0.9))
                                    .foregroundColor(selectedFilter == filter ? .white : .primary)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .background(VisualEffectBlur(blurStyle: .systemThinMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.bottom, 70)
            }
        }
    }
}

#Preview {
    NavigationView {
        MapView()
    }
}

// 小さな下向き三角形（吹き出しの尾）
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct MarkerBubble: View {
    var count: Int
    var color: Color = .blue
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "leaf.fill")
                    .font(.caption2)
                    .foregroundColor(.white)
                Text("\(count)")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding(6)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 1)
            
            Triangle()
                .fill(color)
                .frame(width: 14, height: 8)
        }
        .fixedSize()
    }
}

// 軽いブラー用のヘルパー
struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
