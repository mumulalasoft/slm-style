import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Layouts
import SlmStyle

T.MenuItem {
    id: control

    readonly property bool hasSubMenu: !!control.subMenu
    property string iconSource: ""
    property string fallbackIconSource: ""
    property string secondaryText: ""
    property string shortcutText: ""
    readonly property string _resolvedPrimaryIconSource: resolvedIconSource()
    readonly property bool _hasPrimaryIconSource: String(_resolvedPrimaryIconSource || "").length > 0
    readonly property bool _hasFallbackIconSource: String(fallbackIconSource || "").length > 0
    readonly property bool _iconSlotVisible: _hasPrimaryIconSource || _hasFallbackIconSource

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(28,
                             implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topPadding: 2
    bottomPadding: 2
    leftPadding: 8
    rightPadding: 8
    spacing: 8
    font.family: Theme.fontFamilyUi
    font.pixelSize: Theme.fontSize("menu")

    function resolvedIconSource() {
        var src = String(control.iconSource || "")
        if (src.length > 0) {
            return src
        }

        var iconSrc = String(control.icon.source || "")
        if (iconSrc.length > 0) {
            return iconSrc
        }

        var iconName = String(control.icon.name || "")
        if (iconName.length > 0) {
            return "image://themeicon/" + iconName
        }

        if (control.hasSubMenu && control.subMenu) {
            var entryIconSrc = String(control.subMenu.entryIconSource || "")
            if (entryIconSrc.length > 0) {
                return entryIconSrc
            }
            var entryIconName = String(control.subMenu.entryIconName || "")
            if (entryIconName.length > 0) {
                return "image://themeicon/" + entryIconName
            }
            var subIconSrc = String(control.subMenu.icon.source || "")
            if (subIconSrc.length > 0) {
                return subIconSrc
            }
            var subIconName = String(control.subMenu.icon.name || "")
            if (subIconName.length > 0) {
                return "image://themeicon/" + subIconName
            }
        }

        if (control.menu) {
            var menuEntryIconSrc = String(control.menu.entryIconSource || "")
            if (menuEntryIconSrc.length > 0) {
                return menuEntryIconSrc
            }
            var menuEntryIconName = String(control.menu.entryIconName || "")
            if (menuEntryIconName.length > 0) {
                return "image://themeicon/" + menuEntryIconName
            }
            var menuIconSrc = String(control.menu.icon.source || "")
            if (menuIconSrc.length > 0) {
                return menuIconSrc
            }
            var menuIconName = String(control.menu.icon.name || "")
            if (menuIconName.length > 0) {
                return "image://themeicon/" + menuIconName
            }
        }

        var label = String(control.text || "")
        var subTitle = String((control.subMenu && control.subMenu.title) ? control.subMenu.title : "")
        var menuTitle = String((control.menu && control.menu.title) ? control.menu.title : "")
        var key = label.length > 0 ? label : (subTitle.length > 0 ? subTitle : menuTitle)
        if (key === "Recent Applications") {
            return "qrc:/icons/launchpad.svg"
        }
        if (key === "Recent Files") {
            return "qrc:/icons/logo.svg"
        }
        return ""
    }

    contentItem: RowLayout {
        spacing: 6

        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: (_iconSlotVisible || control.hasSubMenu) ? 16 : 0
            implicitHeight: 16
            visible: _iconSlotVisible || control.hasSubMenu

            IconImage {
                id: iconImage
                anchors.centerIn: parent
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
                source: control._resolvedPrimaryIconSource
                visible: control._hasPrimaryIconSource
                opacity: control.enabled ? 1.0 : 0.5
            }

            IconImage {
                id: fallbackIcon
                anchors.centerIn: parent
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
                source: String(control.fallbackIconSource || "")
                visible: control._hasFallbackIconSource
                         && (!control._hasPrimaryIconSource || iconImage.status === Image.Error)
                opacity: control.enabled ? 1.0 : 0.5
            }
        }

        Text {
            Layout.preferredWidth: 14
            Layout.alignment: Qt.AlignVCenter
            text: control.checkable && control.checked ? "\u2713" : ""
            color: !control.enabled ? Theme.color("textDisabled")
                  : (control.highlighted ? Theme.color("selectedItemText") : Theme.color("textPrimary"))
            font.family: Theme.fontFamilyUi
            font.pixelSize: Theme.fontSize("menu")
            font.weight: Theme.fontWeight("bold")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.weight: control.highlighted ? Theme.fontWeight("medium") : Theme.fontWeight("normal")
            color: !control.enabled ? Theme.color("textDisabled")
                  : (control.highlighted ? Theme.color("selectedItemText") : Theme.color("textPrimary"))
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            lineHeightMode: Text.ProportionalHeight
            lineHeight: Theme.lineHeight("normal")
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            visible: String(control.secondaryText || "").length > 0
            text: String(control.secondaryText || "")
            font.family: Theme.fontFamilyUi
            font.pixelSize: Theme.fontSize("small")
            color: !control.enabled ? Theme.color("textDisabled")
                  : (control.highlighted ? Theme.color("selectedItemText") : Theme.color("textSecondary"))
            elide: Text.ElideRight
        }

        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            visible: String(control.shortcutText || "").length > 0
            implicitWidth: shortcutLabel.implicitWidth + 10
            implicitHeight: Math.max(16, shortcutLabel.implicitHeight + 2)
            radius: Theme.radiusSm
            color: control.highlighted ? Qt.rgba(1, 1, 1, Theme.darkMode ? 0.22 : 0.28) : Theme.color("controlBg")
            border.width: Theme.borderWidthThin
            border.color: control.highlighted ? Qt.rgba(1, 1, 1, Theme.darkMode ? 0.45 : 0.38) : Theme.color("panelBorder")

            Text {
                id: shortcutLabel
                anchors.centerIn: parent
                text: String(control.shortcutText || "")
                font.family: Theme.fontFamilyUi
                font.pixelSize: Theme.fontSize("tiny")
                color: !control.enabled ? Theme.color("textDisabled")
                      : (control.highlighted ? Theme.color("selectedItemText") : Theme.color("textSecondary"))
            }
        }

        Item {
            Layout.preferredWidth: control.hasSubMenu ? 12 : 0
            Layout.alignment: Qt.AlignVCenter
            implicitHeight: 12
            visible: control.hasSubMenu

            Text {
                anchors.centerIn: parent
                text: "\u25B6"
                color: !control.enabled ? Theme.color("textDisabled")
                      : (control.highlighted ? Theme.color("selectedItemText") : Theme.color("textPrimary"))
                font.family: Theme.fontFamilyUi
                font.pixelSize: Theme.fontSize("small")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    background: Rectangle {
        radius: Theme.radiusMdPlus
        color: (control.enabled && control.highlighted) ? Theme.color("menuHover") : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Math.round(Theme.transitionDuration * 0.6)
                easing.type: Easing.InOutQuad
            }
        }
    }
}
