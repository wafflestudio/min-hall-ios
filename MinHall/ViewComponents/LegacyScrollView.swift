//
//  LegacyScrollView.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/20.
//

import SwiftUI

struct ScrollOffset {
    var x: CGFloat
    var y: CGFloat
    var zoom: CGFloat
}

struct LegacyScrollView<Content: View>: UIViewRepresentable {
    @Binding var isMoving: Bool
    @Binding var reload: Bool
    @Binding var offset: ScrollOffset
    
    private let hosting: UIHostingController<Content>

    init(isMoving: Binding<Bool>, offset: Binding<ScrollOffset>, reload: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isMoving = isMoving
        self._offset = offset
        self._reload = reload
        
        hosting = UIHostingController(rootView: content())
    }
    
    func setupView(uiScrollView: UIScrollView, viewToScroll: UIView) {
        uiScrollView.addSubview(viewToScroll)
        
        viewToScroll.translatesAutoresizingMaskIntoConstraints = false
        
        viewToScroll.topAnchor.constraint(equalTo: uiScrollView.topAnchor).isActive = true
        viewToScroll.leadingAnchor.constraint(equalTo: uiScrollView.leadingAnchor).isActive = true
        viewToScroll.trailingAnchor.constraint(equalTo: uiScrollView.trailingAnchor).isActive = true
        viewToScroll.bottomAnchor.constraint(equalTo: uiScrollView.bottomAnchor).isActive = true
    }

    func makeUIView(context: Context) -> UIScrollView {
        let uiScrollView = UIScrollView()
        
        uiScrollView.delegate = context.coordinator
        
        uiScrollView.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height-200).isActive = true
        uiScrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        uiScrollView.showsVerticalScrollIndicator = false
        uiScrollView.showsHorizontalScrollIndicator = false
        uiScrollView.maximumZoomScale = 2
        uiScrollView.minimumZoomScale = 0.7
        
        let viewToScroll = hosting.view!
        
        setupView(uiScrollView: uiScrollView, viewToScroll: viewToScroll)
        
        return uiScrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if reload {
            let lastX = offset.x
            let lastY = offset.y
            
            uiView.subviews[0].removeFromSuperview()
            
            let viewToScroll = hosting.view!
            
            context.coordinator.viewToScroll = viewToScroll
            
            setupView(uiScrollView: uiView, viewToScroll: viewToScroll)
            
            uiView.setZoomScale(offset.zoom, animated: false)
            uiView.setContentOffset(CGPoint(x: lastX, y: lastY), animated: false)
            
            self.offset.x = lastX
            self.offset.y = lastY
            
            reload = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: LegacyScrollView
        var viewToScroll: UIView

        init(_ legacyScrollView: LegacyScrollView) {
            self.parent = legacyScrollView
            self.viewToScroll = parent.hosting.view
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isMoving = true
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.isMoving = false
        }
        
        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            parent.isMoving = true
        }
        
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            parent.isMoving = false
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return self.viewToScroll
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                parent.offset.x = scrollView.contentOffset.x
                parent.offset.y = scrollView.contentOffset.y
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
                parent.offset.zoom = scrollView.zoomScale
        }
    }
}

struct LegacyScrollView_Previews: PreviewProvider {
    static var previews: some View {
        LegacyScrollView(isMoving: .constant(false), offset: .constant(ScrollOffset(x: 0, y: 0, zoom: 1)), reload: .constant(false)) {
            Text("hi")
        }
    }
}
