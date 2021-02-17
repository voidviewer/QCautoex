import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    //flags: "FramelessWindowHint"
    maximumWidth: 1920; maximumHeight: 480; minimumWidth: 1920; minimumHeight: 480
    visible: true
    property real mirrorOpacity: 0.0
    property real rpmValue: 0

    Image {
        source: "images/background.png"
        anchors.fill: parent
    }

    Rectangle {     // window border
        id: windowBorder
        width: window.width
        height: window.height
        color: "transparent"
        border.width: 3
        border.color: "Sienna"
    }

    // Use either dashboard camera or RearViewMirror-module (as floating camera).
    Rectangle {     // rear-view mirror in dashboard
        id: mirrorRectangle
        width: 500
        height: 150
        x: window.width - 503
        y: 3
        color: "black"
        border.width: 3
        border.color: "grey"
        DefaultCamera {
            id: mirrorCamera
            anchors.centerIn: mirrorRectangle
            width: mirrorRectangle.width - 6
            height: mirrorRectangle.height - 6
        }
        Rectangle {
            anchors.centerIn: mirrorRectangle
            width: mirrorRectangle.width - 6
            height: mirrorRectangle.height - 6
            color: "black"
            opacity: mirrorOpacity
        }
    }
    //RearViewMirror {    // floating rear-view mirror
    //    visible: true
    //}

    Rectangle {     // main gadgets
        id: mainMeters
        height: window.height
        width: revMeter.width + speedoMeter.width + 24
        color: "transparent"
        anchors.centerIn: windowBorder

        CircularGauge {
            id: revMeter
            x: 18
            anchors.verticalCenter: parent.verticalCenter
            gaugeName: "RPM"
            Rectangle {
                id: gearDisplay
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                width: parent.width / 7
                height: parent.height / 5
                color: "transparent"
                border.width: 1
                border.color: "#484848"
                Text {
                    id: gear
                    text: qsTr("P")
                    color: "#00cccc"
                    opacity: 0.75
                    font.pixelSize: parent.height * 0.9
                    anchors.centerIn: parent
                }
            }
        }

        CircularGauge {
            id: speedoMeter
            anchors.verticalCenter: revMeter.verticalCenter
            anchors.left: revMeter.right
            gaugeName: "KM/H"
        }
    }

    Rectangle {     // left side gadgets
        x: 3; y: 3
        width: (window.width - mainMeters.width) / 2
        height: window.height - 6
        color: "transparent"
        border.width: 1
        border.color: "#484848"
    }

    Rectangle {     // turn signals
        id: turnSignals
        anchors.horizontalCenter: windowBorder.horizontalCenter
        y: 32
        width: 100; height: 32
        color: "transparent"

        TurnSignals {
            id: turnSignalsItem
        }
    }

    SocketServer {
        id: socketServer
        x: 9; y: 9
    }

    function timeOfDay () {
        return Qt.formatTime(new(Date), "hh:mm:ss.zzz")
    }

    SensoryEngine {
        visible: true
    }
}
