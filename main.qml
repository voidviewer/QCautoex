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
    property int oilTempLabelSize: 10
    property real revLabelCenterMultiplierX: 0.0
    property real revLabelCenterMultiplierY: 0.0
    property real speedLabelCenterMultiplierX: 0.0
    property real speedLabelCenterMultiplierY: 0.065

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
        anchors.topMargin: defaultMargin
        anchors.bottomMargin: defaultMargin
        anchors.leftMargin: defaultMargin
        anchors.rightMargin: defaultMargin / 2
        color: "transparent"
        border.width: 1
        border.color: "#484848"

        RectangularGauge {     // oil temperature gauge
            id: engineOilTemperatureGauge
            anchors.top: parent.top
            anchors.right: parent.right
            gaugeName: "OIL TEMP"
            height: window.height * 0.165
            width: height * 2

//            Repeater {      // oil temperature value labels
//                model: 5
//                delegate: CircularGaugeLabels {
//                    labelNumber: 50 + (index * 20)
//                    labelNumberSize: parent.height / oilTempLabelSize
//                    labelRotation: 45 + ((index + 1) * 30)
//                    gaugeLabelCenterMultiplierX: 0
//                    gaugeLabelCenterMultiplierY: 0
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
}
