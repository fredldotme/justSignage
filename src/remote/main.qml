import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import justSignage 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("ALARM!")

    CompositorRemote {
        id: remote
        onAlarmDone: {
            busyIndicator.running = false;
        }
    }

    CompositorFinder {
        id: finder
        onFound: {
            remote.reconnect(host, port)
        }
    }

    Button {
        anchors.centerIn: parent
        text: qsTr("Alert")
        enabled: !busyIndicator.running
        onClicked: {
            busyIndicator.running = true
            alarmTimeout.start()
            remote.causeAlarm()
        }
    }

    Timer {
        id: alarmTimeout
        interval: 10000
        repeat: false
        onTriggered: busyIndicator.running = false
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }
}
