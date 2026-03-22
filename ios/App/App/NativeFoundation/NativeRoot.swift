import UIKit
import SwiftUI
import Combine
extension Color {
    static let unadNavy = Color(red: 0 / 255, green: 27 / 255, blue: 80 / 255)
    static let unadBlue = Color(red: 0 / 255, green: 70 / 255, blue: 173 / 255)
    static let unadCyan = Color(red: 0 / 255, green: 157 / 255, blue: 196 / 255)
    static let unadGold = Color(red: 255 / 255, green: 184 / 255, blue: 28 / 255)
}

@objc(NativeRootViewController)
final class NativeRootViewController: UIViewController {
    private let model = LeanUpAppModel()
    private var hostingController: UIHostingController<LeanUpNativeRootView>?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let host = UIHostingController(rootView: LeanUpNativeRootView(model: model))
        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)

        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        hostingController = host
        bindThemeUpdates()
        applyTheme(model.snapshot.themeMode)
    }

    private func bindThemeUpdates() {
        model.$snapshot
            .map(\.themeMode)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] theme in
                self?.applyTheme(theme)
            }
            .store(in: &cancellables)
    }

    private func applyTheme(_ theme: LeanUpThemeMode) {
        let style: UIUserInterfaceStyle
        switch theme {
        case .light:
            style = .light
        case .dark:
            style = .dark
        case .system:
            style = .unspecified
        }

        overrideUserInterfaceStyle = style
        hostingController?.overrideUserInterfaceStyle = style
    }
}

struct LeanUpNativeRootView: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        TabView {
            LeanUpNavigationContainer {
                LeanUpDashboardRootView(model: model)
            }
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }

            LeanUpNavigationContainer {
                LeanUpMallaView(model: model)
            }
            .tabItem {
                Label("Malla", systemImage: "list.bullet.clipboard")
            }

            LeanUpNavigationContainer {
                LeanUpProfileView(model: model)
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }

            LeanUpNavigationContainer {
                LeanUpSettingsView(model: model)
            }
            .tabItem {
                Label("Config", systemImage: "gearshape.fill")
            }
        }
        .tint(.unadBlue)
        .preferredColorScheme(model.preferredColorScheme)
    }
}

struct LeanUpDashboardRootView: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                LeanUpDashboardView(model: model)
                    .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            } else {
                LeanUpDashboardView(model: model)
            }
        }
        .background(LeanUpScrollViewBehaviorConfigurator())
    }
}

struct LeanUpNavigationContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}

private struct LeanUpScrollViewBehaviorConfigurator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let scrollView = uiView.leanUpEnclosingScrollView else { return }
            scrollView.alwaysBounceHorizontal = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.directionalLockEnabled = true
        }
    }
}

private extension UIView {
    var leanUpEnclosingScrollView: UIScrollView? {
        var current = superview
        while let view = current {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            current = view.superview
        }
        return nil
    }
}


