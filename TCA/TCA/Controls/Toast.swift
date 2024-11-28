//
//  Toast.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 28/11/2024.
//

import SwiftUI

struct ToastItem: Identifiable {
    let id = UUID()
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.5
}

final class Toast: ObservableObject {
    static let shared = Toast()
    @Published fileprivate var toasts: [ToastItem] = []
    
    func present(title: String,
                 symbol: String? = nil,
                 tint: Color = .gray,
                 isUserInteractionEnabled: Bool = false,
                 timing: ToastTime = .medium) {
        Task { @MainActor in
            withAnimation {
                toasts.append(.init(title: title,
                                    symbol: symbol,
                                    tint: tint,
                                    isUserInteractionEnabled: isUserInteractionEnabled,
                                    timing: timing))
            }
        }
    }
}

struct SceneView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?
    
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    
                    let rootContoller = UIHostingController(rootView: ToastGroup())
                    rootContoller.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootContoller.view.backgroundColor = .clear
                    window.rootViewController = rootContoller
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
    }
}

private class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        return rootViewController?.view == view ? nil : view
    }
}

fileprivate struct ToastGroup: View {
    @ObservedObject var model = Toast.shared
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    @State var delayTask: DispatchWorkItem?
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.footnote)
                    .padding(.trailing, 10)
            }
            
            Text(item.title)
                .font(.footnote)
                .lineLimit(5)
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 16)
        .background(item.tint)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
            in: .rect(cornerRadius: 8)
        )
        .contentShape(.rect(cornerRadius: 8))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if (endY + velocityY) > 100 {
                        removeToast()
                    }
                })
        )
        .onAppear {
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
            }
        }
        .frame(maxWidth: size.width * 0.8)
        .transition(.offset(y: 150))
    }
    
    func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        ToastGroup()
            .previewLayout(.sizeThatFits)
    }
}

