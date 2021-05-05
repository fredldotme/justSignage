import QtQuick 2.12
import QtMir 0.1
import QtQuick.Controls 2.0
import Unity.Application 0.1

Item {
    Instantiator {
        id: root

        model: Screens

        property int canvasWidth : 0
        property int canvasHeight : 0

        property var windowModel : WindowModel {}

        ScreenWindow {
            id: window
            visible: true
            screen: model.screen

            Shell {
                id: shell
                screen: model.screen
                windowModel: root.windowModel
                canvasWidth: root.canvasWidth
                canvasHeight: root.canvasHeight
                anchors.fill: parent
                stupidAnimation: false

                Component.onCompleted: {
                    var newWidth = screen.position.x + shell.width
                    if (newWidth > root.canvasWidth)
                        root.canvasWidth = newWidth

                    var newHeight = screen.position.y + shell.height
                    if (newHeight > root.canvasHeight)
                        root.canvasHeight = newHeight
                }
            }

            Button {
                text: "Quit"
                anchors.left: parent.left
                anchors.top: parent.top
                onClicked: Qt.quit()
            }
        }
    }
}
