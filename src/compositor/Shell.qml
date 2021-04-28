import QtQuick 2.4
import Unity.Application 0.1
import Mir.Pointer 0.1
import QtQuick.Controls 2.0

FocusScope {
    id: root
    focus: true

    readonly property bool stupidAnimation : true
    property color bgColor : "gray"

    property int nextX : 0
    property int nextY : 0

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

    WindowModel {
        id: windowModel;
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
                x: surface.position.x
                y: surface.position.y
                width: surface.size.width
                height: surface.size.height
                focus: surface.focused
                visible: surface.visible

                function nextPoint() {
                    var x = nextX
                    var y = nextY

                    nextX += 400
                    if (nextX >= windowViewContainer.width) {
                        nextX = 0
                        nextY += 400
                    }

                    return Qt.point(x, y);
                }

                Component.onCompleted: {
                    var point = nextPoint();
                    x = point.x
                    y = point.y
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

    Text {
        anchors { left: parent.left; bottom: parent.bottom }
        text: "Move window: Ctrl+click\nResize window: Ctrl+Right click"
    }

    Rectangle {
        id: mousePointer
        color: "black"
        width: 6
        height: 10
        x: PointerPosition.x // - window.screen.position.x
        y: PointerPosition.y // - window.screen.position.y
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: false
        property variant window: null
        property int initialWindowXPosition
        property int initialWindowYPosition
        property int initialWindowWidth
        property int initialWindowHeight
        property int initialMouseXPosition
        property int initialMouseYPosition
        property var action

        function moveWindowBy(window, delta) {
            window.surface.requestedPosition = Qt.point(initialWindowXPosition + delta.x,
                                                        initialWindowYPosition + delta.y);
        }
        function resizeWindowBy(window, delta) {
            window.surface.resize(Qt.size(initialWindowWidth + delta.x,
                                          initialWindowHeight + delta.y))
        }

        onPressed: {
            if (mouse.modifiers & Qt.ControlModifier) {
                window = windowViewContainer.childAt(mouse.x, mouse.y)
                if (!window) return;

                if (mouse.button == Qt.LeftButton) {
                    initialWindowXPosition = window.surface.position.x
                    initialWindowYPosition = window.surface.position.y
                    action = moveWindowBy
                } else if (mouse.button == Qt.RightButton) {
                    initialWindowHeight = window.surface.size.height
                    initialWindowWidth = window.surface.size.width
                    action = resizeWindowBy
                }
                initialMouseXPosition = mouse.x
                initialMouseYPosition = mouse.y
            } else {
                mouse.accepted = false
            }
        }

        onPositionChanged: {
            if (!window) {
                mouse.accepted = false
                return
            }
            action(window, Qt.point(mouse.x - initialMouseXPosition, mouse.y - initialMouseYPosition))
        }

        onReleased: {
            if (!window) {
                mouse.accepted = false
                return
            }
            action(window, Qt.point(mouse.x - initialMouseXPosition, mouse.y - initialMouseYPosition))
            window = null;
        }
    }
}
