import Foundation
import CoreLocation
import SwiftUI

final class AppState: ObservableObject {
    // タブ選択（必要ならTabBarと同期）
    @Published var selectedTab: Int = 0

    // Map表示用フラグとフォーカス名リスト
    @Published var showMap: Bool = false
    @Published var mapFocusNames: [String]? = nil
}
