//
//  Module contains dashdoard and its gadgets.
//
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    flags: "FramelessWindowHint"
    maximumWidth: 1920; maximumHeight: 480;
    minimumWidth: 720; minimumHeight: 180
    color: "#000000"
    visible: true
    onWidthChanged: {
        x = (Screen.width / 2) - (width / 2)
    }
    onHeightChanged: {
        y = (Screen.height / 2) - (height / 2)
    }

    property bool appDebug: false
    property real mirrorOpacity: 0.0
    property real rpmValue: 0
    property int revLabelSize: 7
    property int speedLabelSize: 14
    property int sideGaugeLabelSize: 5
    property real revLabelCenterMultiplierX: 0.0
    property real revLabelCenterMultiplierY: 0.0
    property real speedLabelCenterMultiplierX: 0.0
    property real speedLabelCenterMultiplierY: 0.04
    property bool engineRunning: false
    property bool showGadgetDecor: false

    Image {
        source: "images/background.png"
        anchors.fill: parent
        //opacity: 1
    }

    Rectangle {     // window border
        id: windowBorder
        anchors.centerIn: parent
        width: window.width
        height: window.height
        color: "transparent"
        border.width: window.height * 0.01
        border.color: "#808080"
        Rectangle {
            anchors.centerIn: parent
            width: window.width - (window.height * 0.025)
            height: window.height - (window.height * 0.025)
            color: "transparent"
            border.width: window.height * 0.01
            border.color: "#484848"
        }
    }

    Rectangle {     // left side gadgets
        property int defaultMargin : window.height / 6.5
        anchors.top: windowBorder.top
        anchors.left: windowBorder.left
        anchors.right: mainGauges.left
        anchors.bottom: windowBorder.bottom
        anchors.margins: defaultMargin
        anchors.rightMargin: defaultMargin / 2
        color: "transparent"
        border.width: appDebug ? 1 : 0
        border.color: appDebug ? "#484848" : "transparent"

        Rectangle {     // clock
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width / 3.5
            height: parent.height / 6
            color: "transparent"
            ClockDisplay {
                id: clockGauge
                anchors.right: parent.right
            }
        }

        Rectangle {   // Start/stop button.
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width * 0.2; height: width
            radius: width / 2
            color: "#646464"
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.96; height: width;
                radius: width / 2
                color: "transparent"
                border.width: 1.5
                border.color: "#000000"
                DashboardButton {
                    anchors.centerIn: parent
                    onClicked: {
                        engineRunning = !engineRunning
                        controlEngine.engineStarted = !controlEngine.engineStarted
                    }
                    buttonText: engineRunning ? "STOP" : "START"
                }
            }
        }

        Rectangle {     // transmission gauges
            id: gaugeGroupLeft
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height
            width: parent.height * 0.5
            color: "transparent"
            border.width: appDebug ? 1 : 0
            border.color: appDebug ? "#323232" : "transparent"
            Rectangle {
                id: engineGaugesTextLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 10
                height: parent.height * 0.75
                color: "transparent"
                opacity: 0.75
                Repeater {          // gauge labels
                    id: transmissionLabelRep
                    model: gaugeGroupLists.transmissionTextList.count
                    delegate: GaugeGroupLabel {
                        labelLetter: gaugeGroupLists.transmissionTextList.get(index).le
                        letterIndex: index
                        letterCount: transmissionLabelRep.model
                    }
                }
            }

            RectangularGauge {      // oil Temp gauge
                id: transOilTempGauge
                anchors.left: engineGaugesTextLeft.right
                anchors.bottom: transOilPressureGauge.top
                gaugeName: "OIL TEMP"
                gaugeMin: 50; gaugeMax: 130
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: transOilTempGaugeRptr
                    model: 5
                    delegate: RectangularGaugeLabels {
                        labelNumber: 50 + (index * 20)      // left side gauge
                        //labelNumber: 130 - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: transOilTempGaugeRptr.model
                    }
                }
            }

            RectangularGauge {      // oil pressure gauge
                id: transOilPressureGauge
                anchors.left: engineGaugesTextLeft.right
                //anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.verticalCenter
                gaugeName: "OIL PRESSURE"
                gaugeMin: 1; gaugeMax: 7
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: transOilPressureGaugeRptr
                    model: 7
                    delegate: RectangularGaugeLabels {
                        labelNumber: 1 + index      // left side gauge
                        //labelNumber: 130 - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: transOilPressureGaugeRptr.model
                    }
                }
            }
        }
    }

//    RearViewMirror {    // floating rear-view mirror
//        width: window.width * 0.31
//        height: width * 0.3
//        visible: true
//    }

    Rectangle {     // main gauges
        id: mainGauges
        height: window.height
        width: window.height * 1.7
        color: "transparent"
        anchors.centerIn: windowBorder
        anchors.margins: 2
        border.width: appDebug ? 1 : 0
        border.color: appDebug ? "#484848" : "transparent"

        CircularGauge {     // revolutions gauge
            id: revMeter
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: mainGauges.left
            anchors.leftMargin: 0
            gaugeName: "r/min\nx1000"
            height: mainGauges.height * 0.8
            width: height

            Repeater {      // revolution value labels
                model: 9
                delegate: CircularGaugeLabels {
                    labelNumber: index + 1
                    labelNumberSize: parent.height / revLabelSize
                    labelRotation: (index + 1) * 30
                    gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                    gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
                }
            }

            SpeedDisplay {
                id: speedDisplay
            }
        }

        CircularGauge {     // speed gauge
            id: speedoMeter
            anchors.right: mainGauges.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            gaugeName: "km/h"
            height: mainGauges.height * 0.8
            width: height

            Repeater {      // speed value labels
                model: 13
                delegate: CircularGaugeLabels {
                    labelNumber: index * 30
                    labelNumberSize: parent.height / speedLabelSize
                    labelRotation: index * 22.5
                    gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                    gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
                }
            }

            GearDisplay {   // gear display
                id: gearDisplay
            }
        }
    }

    Rectangle {     // right side gadgets
        id: engineGauges
        property int defaultMargin : window.height / 6.5
        anchors.top: windowBorder.top
        anchors.left: mainGauges.right
        anchors.right: windowBorder.right
        anchors.bottom: windowBorder.bottom
        anchors.margins: defaultMargin
        anchors.leftMargin: defaultMargin / 2
        color: "transparent"
        border.width: appDebug ? 1 : 0
        border.color: appDebug ? "#484848" : "transparent"

        Rectangle {     // engine gauges
            id: engineGaugesRight
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: parent.height * 0.5
            color: "transparent"
            border.width: appDebug ? 1 : 0
            border.color: appDebug ? "#323232" : "transparent"
            Rectangle {
                id: engineGaugesTextRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 10
                height: parent.height * 0.75
                color: "transparent"
                opacity: 0.75
                Repeater {          // gauge labels
                    id: engineLabelRep
                    model: gaugeGroupLists.engineTextList.count
                    delegate: GaugeGroupLabel {
                        labelLetter: gaugeGroupLists.engineTextList.get(index).le
                        letterIndex: index
                        letterCount: transmissionLabelRep.model
                    }
                }
            }

            RectangularGauge {      // oil Temp gauge
                id: engineOilTempGauge
                anchors.right: engineGaugesTextRight.left
                anchors.bottom: engineOilPressureGauge.top
                gaugeName: "OIL TEMP"
                gaugeMin: 50; gaugeMax: 130
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineOilTempGaugeRptr
                    model: 5
                    delegate: RectangularGaugeLabels {
                        //labelNumber: 50 + (index * 20)      // left side gauge
                        labelNumber: 130 - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: engineOilTempGaugeRptr.model
                    }
                }
            }

            RectangularGauge {      // oil pressure gauge
                id: engineOilPressureGauge
                anchors.right: engineGaugesTextRight.left
                anchors.verticalCenter: parent.verticalCenter
                gaugeName: "OIL PRESSURE"
                gaugeMin: 1; gaugeMax: 7
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineOilPressureGaugeRptr
                    model: 7
                    delegate: RectangularGaugeLabels {
                        //labelNumber: 1 + index      // left side gauge
                        labelNumber: 7 - index     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: engineOilPressureGaugeRptr.model
                    }
                }
            }

            RectangularGauge {      // water Temp gauge
                id: engineWaterTempGauge
                anchors.right: engineGaugesTextRight.left
                anchors.top: engineOilPressureGauge.bottom
                anchors.topMargin: parent.height * 0.02
                gaugeName: "WATER TEMP"
                gaugeMin: 50; gaugeMax: 130
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineWaterTempGaugeRprt
                    model: 5
                    delegate: RectangularGaugeLabels {
                        //labelNumber: 50 + (index * 20)      // left side gauge
                        labelNumber: 130 - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: engineWaterTempGaugeRprt.model
                    }
                }
            }
        }

        Rectangle {     // range gauges
            id: rangeGaugesRight
            anchors.top: parent.top
            anchors.left: engineGaugesRight.right
            anchors.leftMargin: width * 0.2
            height: parent.height
            width: parent.height * 0.5
            color: "transparent"
            border.width: appDebug ? 1 : 0
            border.color: appDebug ? "#323232" : "transparent"
            Rectangle {
                id: fuelGaugesTextRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 10
                height: parent.height * 0.75
                color: "transparent"
                opacity: 0.75
                Repeater {          // gauge labels
                    id: fuelLabelRep
                    model: gaugeGroupLists.fuelTextList.count
                    delegate: GaugeGroupLabel {
                        labelLetter: gaugeGroupLists.fuelTextList.get(index).le
                        letterIndex: index
                        letterCount: transmissionLabelRep.model
                    }
                }
            }

            RectangularGauge {      // fuel gauge
                id: fuelAmountGauge
                anchors.right: fuelGaugesTextRight.left
                anchors.bottom: fuelPressureGauge.top
                gaugeName: "LITRES"
                gaugeMin: 0; gaugeMax: 100
                gaugeDirection: "right"
                gradientDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: fuelGaugeRptr
                    model: 6
                    delegate: RectangularGaugeLabels {
                        //labelNumber: 50 + (index * 20)      // left side gauge
                        labelNumber: fuelAmountGauge.gaugeMax - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: fuelGaugeRptr.model - index - 1
                        labelCount: fuelGaugeRptr.model
                    }
                }
            }

            RectangularGauge {      // fuel pressure gauge
                id: fuelPressureGauge
                anchors.right: fuelGaugesTextRight.left
                //anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.verticalCenter
                gaugeName: "FUEL PRESSURE"
                gaugeMin: 1; gaugeMax: 7
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: fuelPressureGaugeRptr
                    model: 7
                    delegate: RectangularGaugeLabels {
                        //labelNumber: 1 + index      // left side gauge
                        labelNumber: 7 - index     // right side gauge
                        labelNumberSize: parent.height / sideGaugeLabelSize
                        labelIndex: index
                        labelCount: fuelPressureGaugeRptr.model
                    }
                }
            }
        }
    }

    Rectangle {     // turn signals
        id: turnSignals
        anchors.horizontalCenter: mainGauges.horizontalCenter
        y: window.height * 0.15
        width: window.height * 0.25; height: window.height * 0.21
        color: "transparent"

        TurnSignals {
            id: turnSignalsItem
        }
    }

    ControlEngine {
        id: controlEngine
        visible: true
    }

    SocketServer {
        id: socketServer
    }

    function timeOfDay () {
        return Qt.formatTime(new(Date), "hh:mm:ss.zzz")
    }

    GaugeGroupLabel {

    }

    GaugeGroupLists {
        id: gaugeGroupLists
    }
}
