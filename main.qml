import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    //flags: "FramelessWindowHint"
    maximumWidth: 1920
    maximumHeight: 480
    minimumWidth: 1920
    minimumHeight: 480
    visible: true
    title: qsTr("QCautoex")

    Image {
        source: "images/background.png"
        anchors.fill: parent
    }

    Rectangle {     // window border
        width: window.width
        height: window.height
        color: "transparent"
        border.width: 3
        border.color: "Sienna"
    }

    Rectangle {     // main gadgets
        id: mainMeters
        height: parent.height
        width: revMeter.width + speedoMeter.width + 24
        color: "transparent"
        anchors.centerIn: parent

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
                //revMeter.needleRotation = 45
                rpmTimer.running = !rpmTimer.running
                //speedoMeter.needleRotation = 45
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
            id: quitButton
            buttonText: "Quit"
            anchors.left: resetButton.right
            anchors.leftMargin: parent.buttonSpacing
            onClicked: {
                Qt.quit()
            }
        }
    }

    RearViewMirror {
        visible: true
    }
}
