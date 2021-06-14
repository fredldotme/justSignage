import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 1920
    height: 300
    title: qsTr("marquee")
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"

    Rectangle {
        id: runningTextBackground
        width: parent.width
        height: 100
        y: parent.height - 400
        color: "#808080"
        clip: true
        Text {
            id: runningText
            color: "white"
            text: "Dies ist ein informativer Lauftext"
            font.pixelSize: 100
            PropertyAnimation {
                id: textAnim
                target: runningText
                property: "x"
                from: runningTextBackground.width
                to: -runningText.width
                duration: 10000
                loops: PropertyAnimation.Infinite
                running: true
            }
        }
    }
}
