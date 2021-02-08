import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    flags: "FramelessWindowHint"
    maximumWidth: 1920
    maximumHeight: 480
    minimumWidth: 1920
    minimumHeight: 480
    visible: true

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

//    Rectangle {   // rear-view mirror in dashboard
//        id: mirrorRectangle
//        width: 500
//        height: 150
//        //anchors.right: window.right
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

    Rectangle {
        property int buttonSpacing: 8
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 8
        height: startStopButton.height
        width: startStopButton.width + quitButton.width + buttonSpacing
        color: "transparent"

        DefaultButton {
            id: startStopButton
            buttonText: "Start/Stop"
            onClicked: {
                rpmTimer.running = !rpmTimer.running
                speedTimer.running = !speedTimer.running
            }
        }
        DefaultButton {
            id: resetButton
            buttonText: "Reset"
            anchors.left: startStopButton.right
            anchors.leftMargin: parent.buttonSpacing
            onClicked: {
                revMeter.needleRotation = 45
                rpmTimer.running = false
                speedoMeter.needleRotation = 45
                speedTimer.running = false
            }
        }
        DefaultButton {
            id: frameModeButton
            buttonText: "Toggle frame"
            anchors.left: resetButton.right
            anchors.leftMargin: parent.buttonSpacing
            onClicked: {
                if (window.flags != 2048) {
                    window.flags = "FramelessWindowHint"
                } else {
                    window.flags = 1
                }
                console.log("window.flags: " + window.flags);
            }
        }
        DefaultButton {
            id: quitButton
            buttonText: "Quit"
            anchors.left: frameModeButton.right
            anchors.leftMargin: parent.buttonSpacing
            onClicked: {
                Qt.quit()
            }
        }
    }

    RearViewMirror {    // floating rear-view mirror
        visible: true
    }
}
