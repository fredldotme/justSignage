import QtQuick 2.5
import QtMir 0.1
import QtQuick.Controls 2.0

Item {
    Instantiator {
        id: root

        model: Screens

        ScreenWindow {
            id: window
            visible: true
            screen: model.screen

            Shell {
                id: shell
                anchors.fill: parent
            }

            Rectangle {
                x: (parent.width - 16) / 2
                y: 0
                width: 16
                height: parent.height
                color: "black"
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
