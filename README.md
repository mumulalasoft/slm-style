# slm-style

Reusable QML style module for SLM apps, with a Big Sur-inspired baseline.

## Module

- QML module: `SlmStyle`
- Entry path: `qml/SlmStyle`
- Singleton theme: `SlmStyle.Theme`

## Contents

- `Theme.qml` token system (color, typography, spacing, radius, motion)
- Styled controls (`Button`, `TextField`, `ComboBox`, `Dialog`, etc.)
- Surface primitives (`PopupSurface`, `WindowDialogSurface`, `AppDialog`)

## Usage

```qml
import SlmStyle
import QtQuick.Controls

ApplicationWindow {
    Component.onCompleted: {
        Theme.applyModeString("auto")
        Theme.userAccentColor = "#0a84ff"
        Theme.userFontScale = 1.0
    }

    Button {
        text: "OK"
    }

    TextField {
        placeholderText: "Password"
    }
}
```

## Integrating in CMake (Qt 6)

```cmake
qt_add_qml_module(myapp
    URI MyApp
    VERSION 1.0
    QML_FILES
        Main.qml
)

# Add SlmStyle to import path (filesystem or qrc, depending on your packaging)
# Example (filesystem during dev):
# engine.addImportPath("<repo>/qml")
```

## Notes

- Current module was bootstrapped from `Desktop_Shell/Style` + `Qml/Theme.qml`.
- Imports were normalized from `Slm_Desktop`/`Style` to `SlmStyle`.
