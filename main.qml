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
    visible: true
    onWidthChanged: {
        x = (Screen.width / 2) - (width / 2)
    }
    onHeightChanged: {
        y = (Screen.height / 2) - (height / 2)
    }

    property real mirrorOpacity: 0.0
    property real rpmValue: 0
    property int revLabelSize: 7
    property int speedLabelSize: 14
    property int temperatureLabelSize: 5
    property real revLabelCenterMultiplierX: 0.0
    property real revLabelCenterMultiplierY: 0.0
    property real speedLabelCenterMultiplierX: 0.0
    property real speedLabelCenterMultiplierY: 0.065
    property bool engineRunning: false

    Image {
        source: "images/background.png"
        anchors.fill: parent
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

//    Rectangle {     // dashboard decoration
//        id: upperDecorationBar
//        width: window.width * 0.95
//        height: window.height * 0.15
//        color: "#646464"
//        border.width: window.height * 0.01
//        border.color: "#323232"
//        anchors.centerIn: parent
//        anchors.verticalCenterOffset: window.height * -0.25
//    }

    Rectangle {     // left side gadgets
        property int defaultMargin : window.height / 6.5
        anchors.top: windowBorder.top
        anchors.left: windowBorder.left
        anchors.right: mainGauges.left
        anchors.bottom: windowBorder.bottom
        anchors.margins: defaultMargin
        anchors.rightMargin: defaultMargin / 2
        color: "transparent"
        border.width: 1
        border.color: "#484848"

        Rectangle {     // transmission gauges
            id: gaugeGroupLeft
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height
            width: parent.height * 0.5
            color: "transparent"
            border.width: 1
            border.color: "#323232"
            Rectangle {
                id: engineGaugesTextLeft
                anchors.top: parent.top
                width: parent.width
                height: width / 6
                color: "transparent"
                Text {
                    text: qsTr("TRANSMISSION")
                    anchors.centerIn: parent
                    font.pixelSize: {
                        if ((parent.height * 0.65) > 0) {
                            parent.height * 0.65
                        } else {
                            1
                        }
                    }
                    font.bold: true
                    //font.letterSpacing: parent.width / 20
                    color: "#fb4f14"
                    opacity: 0.65
                }
            }

            RectangularGauge {      // oil temperature gauge
                id: transmissionOilTemperatureGauge
                anchors.top: engineGaugesTextLeft.bottom
                gaugeName: "OIL TEMP"
                gaugeMin: 50; gaugeMax: 130
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: transmissionOilTemperatureGaugeRepeater
                    model: 5
                    delegate: RectangularGaugeLabels {
                        labelNumber: parent.gaugeMin + (index * 20)      // left side gauge
                        //labelNumber: parent.gaugeMax - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / temperatureLabelSize
                        labelIndex: index
                        labelCount: transmissionOilTemperatureGaugeRepeater.model
                    }
                }
            }

            RectangularGauge {      // oil pressure gauge
                id: transmissionOilPressureGauge
                anchors.top: transmissionOilTemperatureGauge.bottom
                anchors.topMargin: parent.height * 0.02
                gaugeName: "OIL PRESSURE"
                gaugeMin: 0; gaugeMax: 7
                gaugeDirection: "right"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: transmissionOilPressureGaugeRepeater
                    model: 7
                    delegate: RectangularGaugeLabels {
                        //labelNumber: parent.gaugeMin + index      // left side gauge
                        labelNumber: 1 + index      // left side gauge
                        //labelNumber: parent.gaugeMax - index       // right side gauge
                        labelNumberSize: parent.height / temperatureLabelSize
                        labelIndex: index
                        labelCount: transmissionOilPressureGaugeRepeater.model
                    }
                }
            }

//            RectangularGauge {      // water temperature gauge
//                id: engineWaterTemperatureGauge
//                anchors.top: engineOilTemperatureGauge.bottom
//                anchors.topMargin: parent.height * 0.02
//                gaugeName: "WATER TEMP"
//                gaugeMin: 50; gaugeMax: 130
//                width: parent.width
//                height: width / 2

//                Repeater {          // gauge labels
//                    model: 5
//                    delegate: RectangularGaugeLabels {
//                        labelNumber: 50 + (index * 20)
//                        labelNumberSize: parent.height / temperatureLabelSize
//                        labelIndex: index
//                    }
//                }
//            }
        }
    }

    RearViewMirror {    // floating rear-view mirror
        width: window.width * 0.31
        height: width * 0.3
        visible: true
    }

    Rectangle {     // main gauges
        id: mainGauges
        height: window.height
        width: window.height * 1.7
        color: "transparent"
        anchors.centerIn: windowBorder
        anchors.margins: 2
        border.width: 1
        border.color: "#484848"

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

            SpeedDisplay {   // speed display
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
        property int defaultMargin : window.height / 6.5
        anchors.top: windowBorder.top
        anchors.left: mainGauges.right
        anchors.right: windowBorder.right
        anchors.bottom: windowBorder.bottom
        anchors.margins: defaultMargin
        anchors.leftMargin: defaultMargin / 2
        color: "transparent"
        border.width: 1
        border.color: "#484848"

        Rectangle {     // engine gauges
            id: engineGaugesRight
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height
            width: parent.height * 0.5
            color: "transparent"
            border.width: 1
            border.color: "#323232"
            Rectangle {
                id: engineGaugesTextRight
                anchors.top: parent.top
                width: parent.width
                height: width / 6
                color: "transparent"
                Text {
                    text: qsTr("ENGINE")
                    anchors.centerIn: parent
                    font.pixelSize: {
                        if ((parent.height * 0.65) > 0) {
                            parent.height * 0.65
                        } else {
                            1
                        }
                    }
                    font.bold: true
                    font.letterSpacing: parent.width / 20
                    color: "#fb4f14"
                    opacity: 0.65
                }
            }

            RectangularGauge {      // oil temperature gauge
                id: engineOilTemperatureGauge
                anchors.top: engineGaugesTextRight.bottom
                gaugeName: "OIL TEMP"
                gaugeMin: 50; gaugeMax: 130
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineOilTemperatureGaugeRepeater
                    model: 5
                    delegate: RectangularGaugeLabels {
                        //labelNumber: parent.gaugeMin + (index * 20)      // left side gauge
                        labelNumber: parent.gaugeMax - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / temperatureLabelSize
                        labelIndex: index
                        labelCount: engineOilTemperatureGaugeRepeater.model
                    }
                }
            }

            RectangularGauge {      // oil pressure gauge
                id: engineOilPressureGauge
                anchors.top: engineOilTemperatureGauge.bottom
                anchors.topMargin: parent.height * 0.02
                gaugeName: "OIL PRESSURE"
                gaugeMin: 0; gaugeMax: 7
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineOilPressureGaugeRepeater
                    model: 7
                    delegate: RectangularGaugeLabels {
                        //labelNumber: parent.gaugeMin + index      // left side gauge
                        labelNumber: parent.gaugeMax - index       // right side gauge
                        labelNumberSize: parent.height / temperatureLabelSize
                        labelIndex: index
                        labelCount: engineOilPressureGaugeRepeater.model
                    }
                }
            }

            RectangularGauge {      // water temperature gauge
                id: engineWaterTemperatureGauge
                anchors.top: engineOilPressureGauge.bottom
                anchors.topMargin: parent.height * 0.02
                gaugeName: "WATER TEMP"
                gaugeMin: 50; gaugeMax: 130
                gaugeDirection: "left"
                width: parent.width
                height: width / 2

                Repeater {          // gauge labels
                    id: engineWaterTemperatureGaugeRepeater
                    model: 5
                    delegate: RectangularGaugeLabels {
                        //labelNumber: parent.gaugeMin + (index * 20)      // left side gauge
                        labelNumber: parent.gaugeMax - (index * 20)     // right side gauge
                        labelNumberSize: parent.height / temperatureLabelSize
                        labelIndex: index
                        labelCount: engineWaterTemperatureGaugeRepeater.model
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

    SocketServer {
        id: socketServer
    }

    function timeOfDay () {
        return Qt.formatTime(new(Date), "hh:mm:ss.zzz")
    }

    ControlEngine {
        visible: true
    }

//    Component.onCompleted: {
//        console.log("Component.onCompleted")
//    }
}
