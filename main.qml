import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    //flags: "FramelessWindowHint"
    maximumWidth: 1920; maximumHeight: 480;
    minimumWidth: 640; minimumHeight: 160
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
//    Rectangle {     // rear-view mirror in dashboard
//        id: mirrorRectangle
//        width: 500
//        height: 150
//        x: window.width - 503
//        y: 3
//        color: "black"
//        border.width: 3
//        border.color: "grey"
//        DefaultCamera {
//            id: mirrorCamera
//            anchors.centerIn: mirrorRectangle
//            width: mirrorRectangle.width - 6
//            height: mirrorRectangle.height - 6
//        }
//        Rectangle {
//            anchors.centerIn: mirrorRectangle
//            width: mirrorRectangle.width - 6
//            height: mirrorRectangle.height - 6
//            color: "black"
//            opacity: mirrorOpacity
//        }
//    }
    RearViewMirror {    // floating rear-view mirror
        visible: true
        width: window.width * 0.31
        height: width * 0.3
    }

    Rectangle {     // main gadgets
        id: mainMeters
        height: window.height
        width: revMeter.width + speedoMeter.width + (window.height * 0.05)
        color: "transparent"
        anchors.centerIn: windowBorder

        CircularGauge {
            id: revMeter
            anchors.leftMargin: window.height * 0.0375
            anchors.verticalCenter: parent.verticalCenter
            gaugeName: "rpm"
            height: mainMeters.height * 0.8
            width: height
            Rectangle {
                id: gearDisplay
                width: revMeter.width / 7
                height: revMeter.height / 5
                anchors.bottom: revMeter.bottom
                anchors.bottomMargin: window.height * 0.07
                anchors.horizontalCenter: revMeter.horizontalCenter
                anchors.leftMargin: 0
                color: "transparent"
                border.width: 1
                border.color: "#484848"
                Text {
                    id: gear
                    text: qsTr("P")
                    anchors.centerIn: parent
                    color: "#00cccc"
                    opacity: 0.75
                    font.pixelSize: {
                        if ((parent.height * 0.9) > 0) {
                            parent.height * 0.9
                        } else {
                            1
                        }
                    }
                }
            }
        }

        CircularGauge {
            id: speedoMeter
            anchors.right: mainMeters.right
            anchors.rightMargin: window.height * 0.0375
            anchors.verticalCenter: revMeter.verticalCenter
            gaugeName: "km/h"
            height: mainMeters.height * 0.8
            width: height
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
        anchors.horizontalCenter: mainMeters.horizontalCenter
        y: window.height * 0.15
        width: window.height * 0.21; height: window.height * 0.21
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
