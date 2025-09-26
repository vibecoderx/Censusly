//
// File: OrientationManager.swift (MODIFIED)
// Folder: Helpers
//

import SwiftUI

struct OrientationLockViewModifier: ViewModifier {
    let orientation: UIInterfaceOrientationMask

    func body(content: Content) -> some View {
        content
            .onAppear {
                setOrientation(to: orientation)
            }
            .onChange(of: orientation) {
                setOrientation(to: orientation)
            }
    }

    private func setOrientation(to orientation: UIInterfaceOrientationMask) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if #available(iOS 16.0, *) {
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
            scene.requestGeometryUpdate(geometryPreferences)
            
            // FIX: Use the modern method to notify the system of the orientation change.
            // This replaces the deprecated `attemptRotationToDeviceOrientation()`.
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        } else {
            // The older method remains for backward compatibility.
            let orientationValue = orientation == .landscape ? UIInterfaceOrientation.landscapeRight.rawValue : UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation() // This is still needed for the older path.
        }
    }
}

extension View {
    func lockOrientation(to orientation: UIInterfaceOrientationMask) -> some View {
        self.modifier(OrientationLockViewModifier(orientation: orientation))
    }
}
