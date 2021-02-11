import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    //flags: "FramelessWindowHint"
    maximumWidth: 1920
    maximumHeight: 480
    minimumWidth: 1920
    minimumHeight: 480
    visible: true
    //property string socketServerUrl: ""
    property real mirrorOpacity: 0.0

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

    Rectangle {     // rear-view mirror in dashboard
        id: mirrorRectangle
        width: 500
        height: 150
        //anchors.right: window.right
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

//    RearViewMirror {    // floating rear-view mirror
//        visible: true
//    }

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
            opacity: 1

            Timer {
                id: rpmTimer
                property int maxRpm: 8000
                property bool increasing: true
                repeat: true
                interval: 1
                onTriggered: {
                    if (increasing) {
                        if (revMeter.needleRotation < maxRpm) {
                            revMeter.needleRotation += 25
                        } else {
                            increasing = false
                        }
                    } else {
                        if (revMeter.needleRotation > 0) {
                            revMeter.needleRotation -= 25
                        } else {
                            increasing = true
                        }
                    }
                }
            }
        }

        CircularGauge {
            id: speedoMeter
            anchors.verticalCenter: revMeter.verticalCenter
            anchors.left: revMeter.right

            Timer {
                id: speedTimer
                property int maxRpm: 8000
                property bool increasing: true
                repeat: true
                interval: 1
                onTriggered: {
                    if (increasing) {
                        if (speedoMeter.needleRotation < maxRpm) {
                            speedoMeter.needleRotation += 15
                        } else {
                            increasing = false
                        }
                    } else {
                        if (speedoMeter.needleRotation > 0) {
                            speedoMeter.needleRotation -= 15
                        } else {
                            increasing = true
                        }
                    }
                }
            }
        }
    }

    Rectangle {     // control buttons
        id: controlbuttons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 8
        height: controlButtonsItem.buttonHeight
        color: "transparent"

        ControlButtons {
            id: controlButtonsItem
        }
    }

    SocketServer {
        id: socketServer
        x: 9
        y: 9
    }

    SocketClient {
        id: socketClient
        x: socketServer.width + 15
        y: 9
    }

    function timeOfDay () {
        return Qt.formatTime(new(Date), "hh:mm:ss.zzz")
    }
}
