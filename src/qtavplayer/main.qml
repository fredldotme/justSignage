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

    VideoOutput2 {
        anchors.fill: parent
        source: player
        opengl: true
        backgroundColor: "transparent"
    }

    MediaPlayer {
        id: player
        source: "file:///home/alfred/Videos/dancer1.webm"
        autoLoad: true
        autoPlay: true
        videoFilters: [chromaKeyFilter]
    }

    VideoFilter {
        id: chromaKeyFilter
        avfilter: "chromakey=0x818081:0.1:0.2:1"
    }
}
