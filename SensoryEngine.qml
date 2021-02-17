// Module generates vehicle, environment and traffic data for dashdoard module.
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.0
import QtQml.Models 2.15

Window {
    property int rpm: 0
    property int speed: 0
    title: qsTr("QCautoex - sensory engine")
    id: sensoryEngine
    //flags: "FramelessWindowHint"
    maximumWidth: 280; maximumHeight: 480; minimumWidth: 280; minimumHeight: 480
    x: 2000; y: 300
    color: "#323232"

    ListModel {
        id: logModel
        ListElement {
            timeStamp: ""
            logEntry: ""
        }
    }
    Component {
        id: logDelegate
        Item {
            width: sensoryEngine.width; height: 16
            Column {
                id: column0
                anchors.margins: 4
                Text { text: timeStamp; color: "white" }
            }
            Column {
                anchors.left: column0.right
                anchors.margins: 4
                Text { text: ' ' + logEntry; color: "white" }
            }
        }
    }

    Rectangle {
        id: logRectangle
        color: "transparent"
        anchors.fill: parent
        //height: sensoryEngine.height - controlButtons.top

        ListView {
            id: logView
            anchors.fill: logRectangle
            model: logModel
            delegate: logDelegate
            //highlight: Rectangle { color: "lightsteelblue" }
            focus: true
        }
    }

    Rectangle {     // control buttons
        id: controlButtons
        anchors.bottom: parent.bottom
        anchors.margins: 8
        height: controlButtonsItem.buttonHeight
        //color: "#484848"
        //color: "transparent"

        ControlButtons {
            id: controlButtonsItem
        }
    }

    WebSocket {     // interface to dashboard
        id: socket
        url: socketServer.serverUrl
        active: true
        //onTextMessageReceived: {
        //    console.log(qsTr(timeOfDay() + " Client received message: " + message))
        //}
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Client error: " + socket.errorString)
            }
        }
    }

    Timer {     // gears
        id: gearTimer
        repeat: true
        interval: 1500
        onTriggered: {
            var gearList = ["P", "R", "N", "D", "1", "2"]
            var selectedGear = gearList[Math.floor(Math.random() * gearList.length)];

            switch(selectedGear) {
            case "P":
                socket.sendTextMessage("GP");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear parking"})
                break;
            case "R":
                socket.sendTextMessage("GR");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear reverse"})
                break;
            case "N":
                socket.sendTextMessage("GN");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear neutral"})
                break;
            case "D":
                socket.sendTextMessage("GD");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear drive"})
                break;
            case "1":
                socket.sendTextMessage("G1");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear 1"})
                break;
            case "2":
                socket.sendTextMessage("G2");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear 2"})
                break;
            default:
                break;
            }
        }
    }

    Timer {     // turn signals
        id: turnSignals
        repeat: true
        interval: 2500
        onTriggered: {
            var randomStatus = Math.random();

            if (randomStatus < 0.34) {
                socket.sendTextMessage("Tl");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "left turn"})
            } else if (randomStatus < 0.67) {
                socket.sendTextMessage("To");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "turn signal off"})
            } else {
                socket.sendTextMessage("Tr");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "right turn"})
            }
        }
    }

    Timer {     // engine revolutions
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
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "R" + rpm})
        }
    }

    Timer {     // speed
        id: speedTimer
        property int maxSpeed: 360
        property bool increasing: true
        repeat: true
        interval: 50
        onTriggered: {
            if (increasing) {
                if (speed < maxSpeed) {
                    speed += 2
                } else {
                    increasing = false
                }
            } else {
                if (speed > 0) {
                    speed -= 2
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("S" + speed)
        }
    }
}
