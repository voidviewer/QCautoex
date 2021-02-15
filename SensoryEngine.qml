// Module generates vehicle, environment and traffic data for dashdoard module.
import QtQuick 2.0
import QtQuick.Window 2.15
import QtWebSockets 1.0

Window {
    property int rpm: 0
    property int speed: 0
    title: qsTr("QCautoex - sensory engine")
    id: sensoryEngine
    //flags: "FramelessWindowHint"
    maximumWidth: 480; maximumHeight: 480; minimumWidth: 480; minimumHeight: 480
    //x: (window.x + window.width) - sensoryEngine.width; y: window.y - 100
    x: 2000; y: 300
    color: "#323232"

    WebSocket {     // activity when socket message received
        id: socket
        url: socketServer.serverUrl
        active: true
//        onTextMessageReceived: {
//            console.log(qsTr(timeOfDay() + " Client received message: " + message))
//        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Client error: " + socket.errorString)
                         }
    }

    Timer {
        id: rpmTimer
        property int maxRpm: 8000
        property bool increasing: true
        repeat: true
        interval: 1
        onTriggered: {
            if (increasing) {
                if (rpm < maxRpm) {
                    rpm += 15
                } else {
                    increasing = false
                }
            } else {
                if (rpm > 0) {
                    rpm -= 15
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("R" + rpm)
        }
    }

    Timer {
        id: speedTimer
        property int maxSpeed: 360
        property bool increasing: true
        repeat: true
        interval: 50
        onTriggered: {
            if (increasing) {
                if (speed < maxSpeed) {
                    speed += 15
                } else {
                    increasing = false
                }
            } else {
                if (speed > 0) {
                    speed -= 15
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("S" + speed)
        }
    }

    Rectangle {     // control buttons
        id: controlbuttons
        anchors.bottom: parent.bottom
        anchors.margins: 8
        height: controlButtonsItem.buttonHeight
        color: "transparent"

        ControlButtons {
            id: controlButtonsItem
        }
    }
}
