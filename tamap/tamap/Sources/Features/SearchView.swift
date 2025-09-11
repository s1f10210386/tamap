//
//  SearchView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

// --- ルート提案用モデル ---
struct RouteConditions {
    let childAge: Int          // 0-12歳
    let transport: String      // "車" or "電車"
    let energyLevel: String    // "元気" or "疲れ気味"
    let timeAvailable: String  // "1時間", "2時間", "3時間以上"
}

struct SpotInfo: Identifiable {
    let id = UUID()
    let name: String
    let stayTime: String
    let description: String
}

struct RouteOption: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let spots: [SpotInfo]
    let totalDistance: String
    let highlight: String
    let iconName: String
}

struct SearchView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""

    // ルート条件用の状態
    @State private var childAge: Int = 5
    @State private var transport: String = "車"
    @State private var energyLevel: String = "元気"
    @State private var timeAvailable: String = "2時間"

    @State private var routeOptions: [RouteOption] = []

    // MapViewで使っているようなスポット名をサンプルとして用意
    private let sampleSpotInfos: [SpotInfo] = [
        SpotInfo(name: "多摩動物公園", stayTime: "30分", description: "動物と触れ合える子ども向けスポット"),
        SpotInfo(name: "定食屋 藤ノ木", stayTime: "40分", description: "多摩動物公園前にある定食屋さん"),
        SpotInfo(name: "府中の森公園", stayTime: "30分", description: "広い芝生と遊具でのんびり"),
        SpotInfo(name: "いちご狩り園", stayTime: "50分", description: "季節の果物狩り（子どもに人気）"),
        SpotInfo(name: "多摩動物園駅周辺 のたまポスト", stayTime: "30分", description: "「子供がまた行きたいと喜んでた！」"),
        SpotInfo(name: "京王あそびの森 HUGHUGカフェ", stayTime: "40分", description: "天候に左右されず、子供も親も楽しめる"),
        SpotInfo(name: "科学館", stayTime: "60分", description: "体験型の展示で学びがある"),
        SpotInfo(name: "ハイキングコース", stayTime: "70分", description: "自然の中を歩くアクティブなコース"),
        SpotInfo(name: "逸品居", stayTime: "50分", description: "リーズナブルな価格で楽しめる中華屋さん"),
    ]

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // ヘッダー
                    VStack(alignment: .leading, spacing: 6) {
                        Text("お出かけプランを見つけよう！")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("家族で楽しめるルートを簡単に提案します ✨")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // 条件フォーム（カード風にして情報過多にならないよう整理）
                    VStack(spacing: 12) {
                        HStack {
                            Label("子どもの年齢", systemImage: "person.2.fill")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(childAge) 歳")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Stepper("", value: $childAge, in: 0...12)
                                .labelsHidden()
                        }

                        HStack {
                            Label("移動手段", systemImage: "car.fill")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Picker("移動手段", selection: $transport) {
                                Text("車").tag("車")
                                Text("電車").tag("電車")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 180)
                        }

                        HStack {
                            Label("体力", systemImage: "heart.fill")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Picker("体力", selection: $energyLevel) {
                                Text("元気").tag("元気")
                                Text("疲れ気味").tag("疲れ気味")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 220)
                        }

                        HStack {
                            Label("滞在時間", systemImage: "clock")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Picker("時間", selection: $timeAvailable) {
                                Text("1時間").tag("1時間")
                                Text("2時間").tag("2時間")
                                Text("3時間以上").tag("3時間以上")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 260)
                        }

                        Button {
                            let cond = RouteConditions(childAge: childAge, transport: transport, energyLevel: energyLevel, timeAvailable: timeAvailable)
                            withAnimation { routeOptions = computeRoutes(for: cond) }
                        } label: {
                            HStack {
                                Spacer()
                                Text("ルートを提案する")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(LinearGradient(colors: [Color.green.opacity(0.95), Color.green], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    // 提案リスト
                    if !routeOptions.isEmpty {
                        VStack(spacing: 12) {
                            ForEach(routeOptions) { route in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .top) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.green.opacity(0.12))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: route.iconName)
                                                .foregroundColor(.green)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(route.title)
                                                .font(.headline)
                                            Text("所要: \(route.duration) ・ 距離: \(route.totalDistance)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        // Map アイコン（丸）
                                        Button {
                                            appState.mapFocusNames = route.spots.map { $0.name }
                                            appState.showMap = true
                                            appState.selectedTab = 0
                                        } label: {
                                            Image(systemName: "map.fill")
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(Color.green)
                                                .clipShape(Circle())
                                        }
                                    }

                                    Text(route.highlight)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)

                                    // スポット一覧は簡潔に
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(route.spots) { spot in
                                            HStack(alignment: .top, spacing: 10) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.green.opacity(0.2))
                                                    .frame(width: 8, height: 8)

                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(spot.name)
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                    HStack(spacing: 8) {
                                                        Text("滞在: \(spot.stayTime)")
                                                            .font(.caption2)
                                                            .foregroundColor(.secondary)
                                                        Text(spot.description)
                                                            .font(.caption2)
                                                            .foregroundColor(.secondary)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 40)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .navigationTitle("さがす")
        }
        // ヒラギノ丸ゴをデフォルトフォントとして全体に適用（表示の雰囲気を丸くする）
        .font(.custom("Hiragino Maru Gothic ProN", size: 16))
    }

    private var filteredResults: [String] {
        let sampleData = ["サンプル1", "サンプル2", "テスト", "検索結果"]
        return sampleData.filter { $0.contains(searchText) }
    }

    // ルート生成のハードコーディングロジック
    private func computeRoutes(for cond: RouteConditions) -> [RouteOption] {
        var options: [RouteOption] = []

        // ルートA: ファミリーショート（子どもが小さい or 時間1時間）
        let familyShortSpots: [SpotInfo] = [
            sampleSpotInfos[0], // 多摩動物公園
            sampleSpotInfos[4], // カフェ
            sampleSpotInfos[2]  // 府中の森公園
        ]
        let familyShort = RouteOption(title: "ファミリーショート", duration: "約1.5時間", spots: familyShortSpots, totalDistance: "2.5km", highlight: "授乳室・おむつ替え対応の場所中心。移動少なめ。", iconName: "house.fill")

        // ルートB: リラックス（疲れ気味、電車利用を想定）
        let relaxSpots: [SpotInfo] = [
            sampleSpotInfos[4], // カフェ休憩
            sampleSpotInfos[5], // 室内遊び場
        ]
        let relax = RouteOption(title: "駅近リラックスコース", duration: "約1時間", spots: relaxSpots, totalDistance: "徒歩中心", highlight: "駅近で移動少なめ、天候に左右されないプラン。", iconName: "cup.and.saucer.fill")

        // ルートC: アドベンチャー（元気で車、長時間向け）
        let adventureSpots: [SpotInfo] = [
            sampleSpotInfos[6], // 科学館
            sampleSpotInfos[7], // ハイキングコース
            sampleSpotInfos[8]  // 体験工房
        ]
        let adventure = RouteOption(title: "アドベンチャー満喫コース", duration: "約3時間", spots: adventureSpots, totalDistance: "約12km", highlight: "学びと体験を詰め込んだアクティブコース。車推奨。", iconName: "flame.fill")

        // 条件に合わせて提案を調整（簡易ルール）
        if cond.timeAvailable == "1時間" || cond.childAge <= 2 || cond.energyLevel == "疲れ気味" {
            options = [relax, familyShort, adventure]
        } else if cond.timeAvailable == "2時間" || (cond.childAge >= 3 && cond.childAge <= 6) {
            options = [familyShort, relax, adventure]
        } else {
            options = [adventure, familyShort, relax]
        }

        // 交通手段が電車なら徒歩中心の説明に差し替え（表示の簡易的調整）
        if cond.transport == "電車" {
            // adjust descriptions
            return options.map { opt in
                var o = opt
                var newSpots = opt.spots
                // 簡易的に徒歩中心の滞在時間調整
                newSpots = newSpots.map { sp in
                    SpotInfo(name: sp.name, stayTime: sp.stayTime, description: sp.description + "（駅近を優先）")
                }
                o = RouteOption(title: o.title, duration: o.duration, spots: newSpots, totalDistance: "公共交通を利用（徒歩中心）", highlight: o.highlight + " 公共交通推奨。", iconName: o.iconName)
                return o
            }
        }

        return options
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("検索...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    SearchView()
}
