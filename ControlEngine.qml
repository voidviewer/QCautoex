//
// Module generates vehicle, environment and traffic data for dashdoard module.
//
import QtQuick 2.0
import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.0
import QtQml.Models 2.15

Window {
    property int rpm: 0
    property int speed: 0
    property int engineOilTemp: 50

    id: sensoryEngine
    title: qsTr("QCautoex - sensory engine")
    maximumWidth: 280; maximumHeight: 480; minimumWidth: 280; minimumHeight: 480
    x: screen.width - 280
    y: (screen.height / 2) - (height / 2)
    color: "#323232"

    Rectangle {
        id: controls
        color: "transparent"
        border.width: 1
        border.color: "grey"
        width: parent.width
        height: parent.height / 2

//        Rectangle {
//            id: windowFrameToggleRectangle
//            color: "transparent"
//            anchors.topMargin: 4
//            anchors.top: parent.top
//            width: parent.width * 0.95
//            anchors.horizontalCenter: parent.horizontalCenter
//            height: 22
//            Text {
//                id: windowFrameToggleText
//                anchors.verticalCenter: parent.verticalCenter
//                text: "Show window border "
//                color: "#ffffff"
//            }
//            CheckBox {
//                id: windowFrameToggle
//                anchors.left: windowFrameToggleText.right
//                transform: Scale { xScale: 0.55; yScale: 0.55 }
//                //anchors.verticalCenter: parent.verticalCenter

//                onCheckStateChanged: {
//                    if (checked) {
//                        window.flags = "FramelessWindowHint"
//                    } else {
//                        window.flags = 1
//                    }
//                }
//            }
//        }

        Rectangle {
            //anchors.top: windowFrameToggleRectangle.bottom
            anchors.top: parent.top
            anchors.topMargin: 8
            width: parent.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: windowSizeSliderText
                //anchors.top: controls.bottom
                height: 22
                text: "Dashboard size:"
                color: "#ffffff"
            }
            Slider {    // dashboard window size adjustment
                id: windowSizeSlider
                width: parent.width * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                height: 16
                transform: Scale { yScale: 0.75 }
                anchors.top: windowSizeSliderText.bottom
                anchors.topMargin: 1
                from: 180
                value: 180
                to: 480
                onValueChanged: {
                    window.height = value;
                    window.width = value * 4;
                }
            }
        }
    }

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
        anchors.top: controls.bottom
        anchors.bottom: controlButtons.top
        anchors.margins: 3
        //anchors.bottomMargin: 28
        width: parent.width
        border.width: 1
        border.color: "grey"

        ListView {
            id: logView
            anchors.fill: logRectangle
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            model: logModel
            delegate: logDelegate
            //highlight: Rectangle { color: "lightsteelblue" }
            focus: true
            onCountChanged: positionViewAtEnd()
        }
    }

    Rectangle {     // control buttons
        id: controlButtons
        anchors.bottom: parent.bottom
        anchors.margins: 8
        height: controlButtonsItem.buttonHeight

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
                socket.sendTextMessage("G P");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear parking"})
                break;
            case "R":
                socket.sendTextMessage("G R");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear reverse"})
                break;
            case "N":
                socket.sendTextMessage("G N");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear neutral"})
                break;
            case "D":
                socket.sendTextMessage("G D");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear drive"})
                break;
            case "1":
                socket.sendTextMessage("G 1");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear 1"})
                break;
            case "2":
                socket.sendTextMessage("G 2");
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
                socket.sendTextMessage("T l");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "turn left"})
            } else if (randomStatus < 0.67) {
                socket.sendTextMessage("T o");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "turn signal off"})
            } else {
                socket.sendTextMessage("T r");
                logModel.append({"timeStamp": timeOfDay(), "logEntry": "turn right"})
            }
        }
    }

    Timer {     // engine oil temperature
        id: engineOilTemperatureTimer
        property int minEngineOilTemp: 50
        property int maxEngineOilTemp: 130
        property bool increasing: true
        repeat: true
        interval: 2500
        onTriggered: {
            if (increasing) {
                if (engineOilTemp < maxEngineOilTemp) {
                    engineOilTemp += 5
                } else {
                    increasing = false
                }
            } else {
                if (engineOilTemp > minEngineOilTemp) {
                    engineOilTemp -= 5
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Eo" + engineOilTemp)
            logModel.append({"timeStamp": timeOfDay(), "logEntry": "engine oil temperature " + engineOilTemp})
        }
    }

    Timer {     // engine revolutions
        id: rpmTimer
        property int maxRpm: 9000
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
                if (rpm > 750) {
                    rpm -= 15
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("R " + rpm)
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
            socket.sendTextMessage("S " + speed)
        }
    }
}
