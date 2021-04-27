import QtQuick 2.5
import QtMir 0.1

Instantiator {
    id: root

    model: Screens

    ScreenWindow {
        id: window
        visible: true
        screen: model.screen

        Binding {
            target: model.screen
            property: "active"
            value: index == 0
        }

        Shell {
            width: parent.width
            height: parent.height
            z: 1
        }
    }
}
