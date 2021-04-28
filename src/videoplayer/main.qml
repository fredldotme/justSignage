import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Window {
    visible: true
    width: 640
    height: 480
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"

    VideoOutput {
        anchors.fill: parent
        source: player
    }

    MediaPlayer {
        id: player
        source: ""
        autoLoad: true
        autoPlay: true
        muted: true
    }
}
