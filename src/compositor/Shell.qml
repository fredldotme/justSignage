import QtQuick 2.12
import Unity.Application 0.1
import Mir.Pointer 0.1
import QtQuick.Controls 2.0

FocusScope {
    id: root
    focus: true

    property bool stupidAnimation : true
    property color bgColor : "gray"

    property int nextX : 0
    property int nextY : 0

    property int canvasWidth : 0
    property int canvasHeight : 0

    property QtObject screen : null
    property var windowModel : null

    signal shuffleStart();

    Connections {
        target: dbusInterface
        onShuffleTriggered: shuffleStart()
    }

    SequentialAnimation {
        loops: Animation.Infinite
        running: stupidAnimation
        ColorAnimation {
            target: root
            property: "bgColor"
            from: "white"
            to: "black"
            duration: 7000
        }
        ColorAnimation {
            target: root
            property: "bgColor"
            from: "black"
            to: "white"
            duration: 7000
        }
    }

    Rectangle {
        id: windowViewContainer
        anchors.fill: parent
        color: bgColor

        Repeater {
            model: windowModel

            delegate: MirSurfaceItem {
                id: surfaceItem
                surface: model.surface
                consumesInput: true
                x: posX - root.screen.position.x
                y: posY - root.screen.position.y
                width: surface.size.width
                height: surface.size.height
                focus: surface.focused
                visible: surface.visible

                property int oldPosX : 0
                property int oldPosY : 0
                property int posX : 0
                property int posY : 0
                property int nextShuffleX : 0
                onNextShuffleXChanged: console.log(nextShuffleX)
                property int nextShuffleY : 0
                onNextShuffleYChanged: console.log(nextShuffleY)

                function getRandomInt(max) {
                    return Math.floor(Math.random() * max);
                }

                function recalculateNextShuffle() {
                    var maxX = canvasWidth - surface.size.width
                    var maxY = canvasHeight - surface.size.width
                    nextShuffleX = Math.abs(getRandomInt(maxX));
                    nextShuffleY = Math.abs(getRandomInt(maxY));
                }

                ParallelAnimation {
                    id: shuffle
                    NumberAnimation {
                        duration: 1000
                        from: oldPosX
                        to: nextShuffleX
                        target: surfaceItem
                        property: "posX"
                    }
                    NumberAnimation {
                        duration: 1000
                        from: oldPosY
                        to: nextShuffleY
                        target: surfaceItem
                        property: "posY"
                    }
                    onFinished: {
                        surfaceItem.recalculateNextShuffle()
                    }
                }

                Connections {
                    target: root
                    onShuffleStart: {
                        surfaceItem.oldPosX = surfaceItem.posX
                        surfaceItem.oldPosY = surfaceItem.posY
                        shuffle.start()
                    }
                }

                function nextPoint() {
                    var x = nextX
                    var y = nextY

                    nextX += surfaceItem.width
                    if (nextX >= root.canvasWidth) {
                        nextX = 0
                        nextY += surfaceItem.height
                    }

                    return Qt.point(x, y);
                }

                Component.onCompleted: {
                    var point = nextPoint();
                    posX = point.x
                    posY = point.y
                    surfaceItem.recalculateNextShuffle()
                }

                SequentialAnimation {
                    loops: Animation.Infinite
                    running: stupidAnimation
                    PropertyAnimation {
                        from: 0.7
                        to: 1.0
                        duration: 1000
                        target: surfaceItem
                        property: "scale"
                    }
                    PropertyAnimation {
                        to: 0.7
                        from: 1.0
                        duration: 200
                        target: surfaceItem
                        property: "scale"
                    }
                }
            }
        }
    }

    Rectangle {
        id: mousePointer
        color: "black"
        width: 6
        height: 10
        x: PointerPosition.x - root.screen.position.x
        y: PointerPosition.y - root.screen.position.y
    }
}
