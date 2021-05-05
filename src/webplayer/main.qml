import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.1
import QtWebChannel 1.0
import justSignage 1.0

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("Hello World")
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    color: "#00000000"

    readonly property string controller :
        "<script type=\"text/javascript\" src=\"qrc:///qtwebchannel/qwebchannel.js\"></script>

        <script type=\"text/javascript\">
            var compositorCtrl;

            window.onload = function()
            {
                new QWebChannel(qt.webChannelTransport, function(channel) {
                    // all published objects are available in channel.objects under
                    // the identifier set in their attached WebChannel.id property
                    compositorCtrl = channel.objects.compositorCtrl;
                });
            }
        </script>

        <style>
            .container {
              height: 200px;
              position: relative;
            }

            .center {
              margin: 0;
              position: absolute;
              top: 50%;
              left: 50%;
              -ms-transform: translateY(-50%, -50%);
              transform: translateY(-50%, -50%);
            }
        </style>
        <div class=\"container\">
            <div class=\"center\">
                <button type=\"button\" onclick=\"compositorCtrl.shuffle()\">Shuffle!</button>
            </div>
        </div>
    "

    Component.onCompleted: {
        webEngineView.loadHtml(controller)
    }

    CompositorCtrl {
        id: compositorCtrl
        WebChannel.id: "compositorCtrl"
    }

    WebChannel {
        id: webChannel
        registeredObjects: [ compositorCtrl ]
    }

    WebEngineView {
        id: webEngineView
        anchors.fill: parent
        webChannel: webChannel
    }
}
