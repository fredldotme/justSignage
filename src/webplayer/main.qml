import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.0

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("Hello World")
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"

    WebEngineView {
        anchors.fill: parent
        url: "https://fredl.me"
    }
}
