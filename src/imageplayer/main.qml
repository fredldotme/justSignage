import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 300
    height: 300
    title: qsTr("Hello World")
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"

    Image {
        anchors.fill: parent
        source: "file:///home/alfred/Bilder/Sat1.png"
    }
}
