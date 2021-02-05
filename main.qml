import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
//    width: 1920
//    height: 480
    maximumWidth: 1920
    maximumHeight: 480
    minimumWidth: 1920
    minimumHeight: 480
    visible: true
    title: qsTr("QCautoex")

    Image {
        id: backgroundImage
        source: "images/background.png"
        anchors.fill: parent
    }

    Rectangle {
        id: mainMeters
        height: parent.height
        width: revCounter.width + speedoMeter.width + 24
        color: "transparent"
        //border.color: "white"
        //border.width: 1
        anchors.centerIn: parent

        RevCounter{
            id: revCounter
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
                        if (revCounter.rpm < maxRpm) {
                            revCounter.rpm += 25
                        } else {
                            increasing = false
                        }
                    } else {
                        if (revCounter.rpm > 0) {
                            revCounter.rpm -= 25
                        } else {
                            increasing = true
                        }
                    }
                }
            }
        }

        RevCounter{
            id: speedoMeter
            anchors.verticalCenter: revCounter.verticalCenter
            anchors.left: revCounter.right

            Timer {
                id: speedTimer
                property int maxRpm: 8000
                property bool increasing: true
                repeat: true
                interval: 1
                onTriggered: {
                    if (increasing) {
                        if (speedoMeter.rpm < maxRpm) {
                            speedoMeter.rpm += 15
                        } else {
                            increasing = false
                        }
                    } else {
                        if (speedoMeter.rpm > 0) {
                            speedoMeter.rpm -= 15
                        } else {
                            increasing = true
                        }
                    }
                }
            }
        }
    }

    Button {
        text: "Start/Stop"
        onClicked: {
            revCounter.rpm = 0
            rpmTimer.running = !rpmTimer.running
            speedoMeter.rpm = 0
            speedTimer.running = !speedTimer.running
        }
    }
}
