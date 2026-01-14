# Building LibrePods for iOS

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 16.0+ SDK
- Apple Developer account (for device testing)

## Quick Start

### Option 1: Swift Package Manager (Command Line)

1. Navigate to the iOS directory:
```bash
cd ios
```

2. Build the package:
```bash
swift build
```

3. Run tests:
```bash
swift test
```

### Option 2: Xcode Project (Recommended)

Since this is a Swift Package, you can open it directly in Xcode:

1. Open Xcode

2. File → Open → Navigate to `ios` directory

3. Select `Package.swift`

4. Xcode will automatically resolve dependencies and prepare the project

5. Create a new iOS App target:
   - File → New → Target
   - Choose "iOS App"
   - Product Name: LibrePods
   - Organization Identifier: me.kavishdevar.librepods
   - Interface: SwiftUI
   - Life Cycle: SwiftUI App

6. Add the LibrePods package as a dependency to your new target

7. Select your development team in Signing & Capabilities

8. Build and run on your device (⌘R)

### Option 3: Create Xcode Project from Scratch

For a full Xcode project setup:

1. Create new Xcode project:
   - File → New → Project
   - Choose "iOS App"
   - Product Name: LibrePods
   - Interface: SwiftUI
   - Include Tests: Yes

2. Copy all Swift files from the package to the project

3. Add `Info.plist` permissions

4. Configure Bundle Identifier: `me.kavishdevar.librepods`

5. Add required frameworks:
   - CoreBluetooth.framework
   - Combine.framework
   - UserNotifications.framework

## Configuration

### Info.plist Permissions

The app requires these permission descriptions:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>LibrePods needs Bluetooth access to connect to your AirPods</string>

<key>NSBluetoothPeripheralUsageDescription</key>
<string>LibrePods uses Bluetooth to communicate with your AirPods</string>

<key>NSMicrophoneUsageDescription</key>
<string>LibrePods uses microphone access for hearing aid features</string>

<key>NSUserNotificationsUsageDescription</key>
<string>LibrePods sends notifications for battery status</string>

<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
    <string>bluetooth-peripheral</string>
</array>
```

### Signing

For device testing:

1. Select your target in Xcode
2. Go to "Signing & Capabilities"
3. Check "Automatically manage signing"
4. Select your team
5. Xcode will create a provisioning profile

## Running on Device

1. Connect your iPhone via USB
2. Trust the computer on your iPhone if prompted
3. Select your iPhone as the build destination in Xcode
4. Build and run (⌘R)
5. On first launch, go to Settings → General → VPN & Device Management
6. Trust the developer certificate

## Troubleshooting

### "No such module 'SwiftUI'" error
- This error appears when building on Linux (CI). SwiftUI is iOS/macOS only.
- The code will compile correctly on macOS with Xcode.

### Bluetooth not connecting
- Ensure Bluetooth permissions are granted in Settings → LibrePods
- Check that AirPods are paired with device via Settings → Bluetooth
- Try resetting connection in the app's Troubleshooting screen

### App crashes on launch
- Check that all required permissions are in Info.plist
- Verify iOS deployment target is 16.0 or later
- Check Xcode console for specific error messages

## Development Tips

### Testing Without AirPods

The app includes mock data for UI development:
- Battery status displays placeholder values
- Screens can be previewed using SwiftUI previews
- Navigation works without BLE connection

### Debug Logging

Enable verbose Bluetooth logging:
```swift
// In BluetoothManager.swift
private let debugLogging = true
```

### Xcode Previews

All screens have SwiftUI preview providers:
```swift
struct MyScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyScreen()
            .environmentObject(AirPodsService())
    }
}
```

Use ⌘⌥P to refresh previews in Xcode.

## App Store Distribution

1. Archive the app (Product → Archive)
2. Validate the archive
3. Distribute to App Store Connect
4. Submit for review

Note: Ensure compliance with:
- App Store Review Guidelines
- Bluetooth accessory requirements
- Privacy policy for Bluetooth usage

## CI/CD

For GitHub Actions:

```yaml
name: iOS Build

on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    - name: Build
      run: |
        cd ios
        swift build -c release
```

## Additional Resources

- [Swift Package Manager Documentation](https://swift.org/package-manager/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [CoreBluetooth Documentation](https://developer.apple.com/documentation/corebluetooth)
- [LibrePods Android App](../android/README.md)
- [Main Project README](../README.md)
