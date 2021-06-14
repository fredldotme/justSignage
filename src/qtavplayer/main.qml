import QtQuick 2.12
import QtQuick.Window 2.12
import QtAV 1.7

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"
    property int counter : 0

    VideoOutput2 {
        anchors.fill: parent
        source: player
        opengl: true
        backgroundColor: "transparent"
    }

    MediaPlayer {
        id: player
        source: files[counter % files.length]
        loops: MediaPlayer.Infinite
    }

    Component.onCompleted: {
        player.play()
    }
}
