import QtQuick
import SlmStyle as DSStyle
import SlmStyle

DSStyle.Label {
    id: control

    property bool emphasized: false

    color: Theme.color("textSecondary")
    font.family: Theme.fontFamilyUi
    font.pixelSize: Theme.fontSize("body")
    font.weight: emphasized ? Theme.fontWeight("semibold") : Theme.fontWeight("normal")
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
}
