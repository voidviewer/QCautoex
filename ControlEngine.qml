//
// Module generates vehicle, environment and traffic data for dashdoard module.
//
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.0
import QtQml.Models 2.15

Window {
    property int rpm: 0
    property int speed: 0
    property int transmissionOilTemp: 50
    property real transmissionOilPressure: 0.0
    property int engineOilTemp: 50
    property real engineOilPressure: 0.0
    property int engineWaterTemp: 50

    id: sensoryEngine
    title: qsTr("QCautoex - control")
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

        Rectangle {     // dashboard window frame toggle
            id: windowFrameToggleRectangle
            color: "transparent"
            anchors.topMargin: 4
            anchors.top: parent.top
            width: parent.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            height: 22
            Text {
                id: windowFrameToggleText
                anchors.verticalCenter: parent.verticalCenter
                text: "Show window frame "
                color: "#ffffff"
            }
            CheckBox {
                id: windowFrameToggle
                checked: false
                anchors.left: windowFrameToggleText.right
                transform: Scale { xScale: 0.55; yScale: 0.55 }

                onCheckStateChanged: {
                    if (checked) {
                        socket.sendTextMessage("Wb0");
                    } else {
                        socket.sendTextMessage("Wb1");
                    }
                }
            }
        }

        Rectangle {     // dashboard window size adjustment
            anchors.top: windowFrameToggleRectangle.bottom
            anchors.topMargin: 2
            width: parent.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: windowSizeSliderText
                height: 22
                text: "Dashboard size:"
                color: "#ffffff"
            }
            Slider {
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
                    socket.sendTextMessage("Ws" + value);
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
        anchors.bottomMargin: 8
        width: parent.width
        border.width: 1
        border.color: "grey"

        ListView {
            id: logView
            anchors.fill: logRectangle
            anchors.topMargin: 20
            anchors.bottomMargin: 8
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            model: logModel
            verticalLayoutDirection: ListView.BottomToTop
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

    Timer {     // transmission oil temperature
        id: transmissionOilTemperatureTimer
        property int minTransmissionOilTemp: 50
        property int maxTransmissionOilTemp: 130
        property bool increasing: true
        repeat: true
        interval: 2000
        onTriggered: {
            if (increasing) {
                if (transmissionOilTemp < maxTransmissionOilTemp) {
                    transmissionOilTemp += 5
                } else {
                    increasing = false
                }
            } else {
                if (transmissionOilTemp > minTransmissionOilTemp) {
                    transmissionOilTemp -= 5
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("To" + transmissionOilTemp)
            logModel.append({"timeStamp": timeOfDay(), "logEntry": "transmission oil temperature " + transmissionOilTemp})
        }
    }

    Timer {     // engine oil temperature
        id: engineOilTemperatureTimer
        property int minEngineOilTemp: 50
        property int maxEngineOilTemp: 130
        property bool increasing: true
        repeat: true
        interval: 2000
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

    Timer {     // engine oil pressure
        id: engineOilPressureTimer
        property int minEngineOilPressure: 0
        property int maxEngineOilPressure: 7
        property bool increasing: true
        repeat: true
        interval: 30
        onTriggered: {
            if (increasing) {
                if (engineOilPressure < maxEngineOilPressure) {
                    engineOilPressure += 0.025
                } else {
                    increasing = false
                }
            } else {
                //if (engineOilPressure > minEngineOilPressure) {
                if (engineOilPressure > 1.0) {
                    engineOilPressure -= 0.025
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Ep" + engineOilPressure)
        }
    }

    Timer {     // transmission oil pressure
        id: transmissionOilPressureTimer
        property int minTransmissionOilPressure: 0
        property int maxTransmissionOilPressure: 7
        property bool increasing: true
        repeat: true
        interval: 30
        onTriggered: {
            if (increasing) {
                if (transmissionOilPressure < maxTransmissionOilPressure) {
                    transmissionOilPressure += 0.025
                } else {
                    increasing = false
                }
            } else {
                if (transmissionOilPressure > 1.0) {
                    transmissionOilPressure -= 0.025
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Tp" + transmissionOilPressure)
        }
    }

    Timer {     // engine water temperature
        id: engineWaterTemperatureTimer
        property int minEngineWaterTemp: 50
        property int maxEngineWaterTemp: 130
        property bool increasing: true
        repeat: true
        interval: 2000
        onTriggered: {
            if (increasing) {
                if (engineWaterTemp < maxEngineWaterTemp) {
                    engineWaterTemp += 5
                } else {
                    increasing = false
                }
            } else {
                if (engineWaterTemp > minEngineWaterTemp) {
                    engineWaterTemp -= 5
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Et" + engineWaterTemp)
            logModel.append({"timeStamp": timeOfDay(), "logEntry": "engine water temperature " + engineWaterTemp})
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
