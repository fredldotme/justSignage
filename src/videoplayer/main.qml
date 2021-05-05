import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Window {
    visible: true
    width: 640
    height: 480
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"
    property int counter : 0
    property var playList : [
        "file:///home/alfred/Videos/caminandes_llamigos_1080p_hevc.mp4",
        "file:///home/alfred/Videos/Nextcloud.mp4",
        "file:///home/alfred/Videos/realisticdragon.mp4"
    ]

    Connections {
        target: videoCtrl
        onNextVideoTriggered: counter++
    }

    VideoOutput {
        anchors.fill: parent
        source: player
    }

    MediaPlayer {
        id: player
        source: playList[counter % playList.length]
        autoLoad: true
        autoPlay: true
        muted: true
    }
}
