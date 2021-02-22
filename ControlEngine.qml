//
// Module generates vehicle and environment for dashdoard module.
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
    property int engineOilTemp: 50
    property real engineOilPressure: 1
    property int engineWaterTemp: 50
    property int transOilTemp: 50
    property real transOilPressure: 1
    property int fuelAmount: 100
    property real fuelPressure: 3.0
    property int selectedGear: 0
    property bool engineStarted: false

    id: sensoryEngine
    title: qsTr("QCautoex - control engine")
    maximumWidth: 280; maximumHeight: 480; minimumWidth: 280; minimumHeight: 480
    x: screen.width - 280
    y: (screen.height / 2) - (height / 2)
    color: "#323232"

    onEngineStartedChanged: {
        controlButtonsItem.startStop = !controlButtonsItem.startStop
        controlButtonsItem.reset = !controlButtonsItem.reset
    }

    Rectangle {     // dashboard window controls
        //visible: false
        id: controls
        color: "transparent"
        border.width: 1
        border.color: "grey"
        width: parent.width
        height: parent.height / 3

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

        Rectangle {     // gauge border toggle
            id: gaugeBorderToggleRectangle
            color: "transparent"
            anchors.topMargin: 2
            anchors.top: windowFrameToggleRectangle.bottom
            width: parent.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            height: 22
            Text {
                id: gaugeBorderToggleText
                anchors.verticalCenter: parent.verticalCenter
                text: "Show gadget decorations "
                color: "#ffffff"
            }
            CheckBox {
                id: gaugeBorderToggle
                checked: false
                anchors.left: gaugeBorderToggleText.right
                transform: Scale { xScale: 0.55; yScale: 0.55 }

                onCheckStateChanged: {
                    if (checked) {
                        socket.sendTextMessage("Gb1");
                    } else {
                        socket.sendTextMessage("Gb0");
                    }
                }
            }
        }

        Rectangle {     // dashboard window size adjustment
            anchors.top: gaugeBorderToggleRectangle.bottom
            anchors.topMargin: 8
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

    Rectangle {     // log entry list
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
        onTextMessageReceived: {
            console.log(qsTr(timeOfDay() + " Client received message: " + message))
        }
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
            switch(selectedGear) {
            case 0:     // parking gear
                selectedGear = 1;
                break;
            case 1:     // reverse gear
                //selectedGear = [0, 2][Math.floor(Math.random() * 2)];
                selectedGear = 2;
                break;
            case 2:     // neutral gear
                //selectedGear = [1, 3][Math.floor(Math.random() * 2)];
                selectedGear = 3;
                break;
            case 3:     // drive gear
                //selectedGear = [2, 4][Math.floor(Math.random() * 2)];
                break;
            case 4:     // first gear
                selectedGear = [3, 5][Math.floor(Math.random() * 2)];
                break;
            case 5:     // second gear
                selectedGear = 4;
                break;
            default:
                break;
            }
            var gearList = ["P", "R", "N", "D", "1", "2"]
            socket.sendTextMessage("G " + gearList[selectedGear]);
            logModel.append({"timeStamp": timeOfDay(), "logEntry": "gear " + gearList[selectedGear]})
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

    Timer {     // transmission oil Temp
        id: transOilTempTimer
        //property int minTransOilTemp: 50
        //property int maxTransOilTemp: 130
        property int minTransOilTemp: 65
        property int maxTransOilTemp: 115
        property bool increasing: true
        repeat: true
        interval: 100
        onTriggered: {
            if (increasing) {
                if (transOilTemp < maxTransOilTemp) {
                    transOilTemp += 1
                } else {
                    increasing = false
                }
            } else {
                if (transOilTemp > minTransOilTemp) {
                    transOilTemp -= 1
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Gt" + transOilTemp)
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "trans oil Temp " + transOilTemp})
        }
    }

    Timer {     // transmission oil pressure
        id: transOilPressureTimer
        //property real minTransOilPressure: 1
        //property real maxTransOilPressure: 7
        property real minTransOilPressure: 2.5
        property real maxTransOilPressure: 5.5
        property bool increasing: true
        repeat: true
        interval: 50
        onTriggered: {
            if (increasing) {
                if (transOilPressure < maxTransOilPressure) {
                    transOilPressure += 0.05
                } else {
                    increasing = false
                }
            } else {
                if (transOilPressure > minTransOilPressure) {
                    transOilPressure -= 0.05
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Gp" + transOilPressure)
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "transmission oil pressure " + transOilPressure})
        }
    }

    Timer {     // engine oil Temp
        id: engineOilTempTimer
        //property int minEngineOilTemp: 50
        //property int maxEngineOilTemp: 130
        property int minEngineOilTemp: 70
        property int maxEngineOilTemp: 105
        property bool increasing: true
        repeat: true
        interval: 100
        onTriggered: {
            if (increasing) {
                if (engineOilTemp < maxEngineOilTemp) {
                    engineOilTemp += 1
                } else {
                    increasing = false
                }
            } else {
                if (engineOilTemp > minEngineOilTemp) {
                    engineOilTemp -= 1
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Eo" + engineOilTemp)
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "engine oil Temp " + engineOilTemp})
        }
    }

    Timer {     // engine oil pressure
        id: engineOilPressureTimer
        //property int minEngineOilPressure: 1
        //property int maxEngineOilPressure: 7
        property real minEngineOilPressure: 2.5
        property real maxEngineOilPressure: 5.5
        property bool increasing: true
        repeat: true
        interval: 50
        onTriggered: {
            if (increasing) {
                if (engineOilPressure < maxEngineOilPressure) {
                    engineOilPressure += 0.05
                } else {
                    increasing = false
                }
            } else {
                if (engineOilPressure > minEngineOilPressure) {
                    engineOilPressure -= 0.05
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Ep" + engineOilPressure)
        }
    }

    Timer {     // engine water Temp
        id: engineWaterTempTimer
        //property int minEngineWaterTemp: 50
        //property int maxEngineWaterTemp: 130
        property int minEngineWaterTemp: 65
        property int maxEngineWaterTemp: 110
        property bool increasing: true
        repeat: true
        interval: 100
        onTriggered: {
            if (increasing) {
                if (engineWaterTemp < maxEngineWaterTemp) {
                    engineWaterTemp += 1
                } else {
                    increasing = false
                }
            } else {
                if (engineWaterTemp > minEngineWaterTemp) {
                    engineWaterTemp -= 1
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Et" + engineWaterTemp)
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "engine water Temp " + engineWaterTemp})
        }
    }

    Timer {     // fuel amount
        id: fuelAmountTimer
        property int minFuelAmount: 1
        property int maxFuelAmount: 100
        property bool increasing: false
        repeat: true
        interval: 100
        onTriggered: {
            if (increasing) {
                if (fuelAmount < maxFuelAmount) {
                    fuelAmount += 1
                } else {
                    increasing = false
                }
            } else {
                if (fuelAmount > minFuelAmount) {
                    fuelAmount -= 1
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Fa" + fuelAmount)
            //logModel.append({"timeStamp": timeOfDay(), "logEntry": "fuel amount " + fuelAmount})
        }
    }

    Timer {     // engine fuel pressure
        id: fuelPressureTimer
        property real minFuelPressure: 2.5
        property real maxFuelPressure: 5.5
        property bool increasing: true
        repeat: true
        interval: 50
        onTriggered: {
            if (increasing) {
                if (fuelPressure < maxFuelPressure) {
                    fuelPressure += 0.05
                } else {
                    increasing = false
                }
            } else {
                if (fuelPressure > minFuelPressure) {
                    fuelPressure -= 0.05
                } else {
                    increasing = true
                }
            }
            socket.sendTextMessage("Fp" + fuelPressure)
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

    Timer {     // time of day
        id: clockTimer
        property int dayMinute: 0
        repeat: true
        interval: 20
        onTriggered: {
            if (dayMinute++ >= 1440) dayMinute = 0
            socket.sendTextMessage("Dm" + dayMinute)
        }
    }
}
