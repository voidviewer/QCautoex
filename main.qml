import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.1

Window {
    title: qsTr("QCautoex - dashboard")
    id: window
    //flags: "FramelessWindowHint"
    maximumWidth: 1920; maximumHeight: 480;
    minimumWidth: 720; minimumHeight: 180
    visible: true
    property real mirrorOpacity: 0.0
    property real rpmValue: 0
    property int revLabelSize: 7
    property int speedLabelSize: 14
    property real revLabelCenterMultiplierX: 0.015
    property real revLabelCenterMultiplierY: 0.013
    property real speedLabelCenterMultiplierX: 0.02
    property real speedLabelCenterMultiplierY: 0.065

    Image {
        source: "images/background.png"
        anchors.fill: parent
    }

    Rectangle {     // window border
        id: windowBorder
        width: window.width
        height: window.height
        color: "transparent"
        border.width: 3
        border.color: "Sienna"
    }

    RearViewMirror {    // floating rear-view mirror
        width: window.width * 0.31
        height: width * 0.3
        visible: true
    }

    Rectangle {     // main gauges
        id: mainMeters
        height: window.height
        width: window.height * 1.7
        color: "transparent"
        anchors.centerIn: windowBorder

        CircularGauge {     // revolutions gauge
            id: revMeter
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 0
//            anchors.leftMargin: window.height * 0.0375
            gaugeName: "rpm"
            height: mainMeters.height * 0.8
            width: height
            Rectangle {
                id: gearDisplay
                width: revMeter.width / 7
                height: revMeter.height / 5
                anchors.bottom: revMeter.bottom
                anchors.bottomMargin: window.height * 0.07
                anchors.horizontalCenter: revMeter.horizontalCenter
                anchors.leftMargin: 0
                color: "transparent"
                border.width: 1
                border.color: "#484848"
                Text {      // gear display
                    id: gear
                    text: qsTr("P")
                    anchors.centerIn: parent
                    color: "#00cccc"
                    opacity: 0.75
                    font.pixelSize: {
                        if ((parent.height * 0.9) > 0) {
                            parent.height * 0.9
                        } else {
                            1
                        }
                    }
                }
            }

            GaugeLabel {
                labelNumber: 9
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 270
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 8
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 240
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 7
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 210
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 6
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 180
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 5
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 150
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 4
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 120
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 3
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 90
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 2
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 60
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 1
                labelNumberSize: revMeter.height / revLabelSize
                labelRotation: 30
                gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
            }
        }

        CircularGauge {     // speed gauge
            id: speedoMeter
            anchors.right: mainMeters.right
            anchors.rightMargin: window.height * 0.0375
            anchors.verticalCenter: revMeter.verticalCenter
            gaugeName: "km/h"
            height: mainMeters.height * 0.8
            width: height

            GaugeLabel {
                labelNumber: 360
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 270
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 330
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 247.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 300
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 225
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 270
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 202.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 240
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 180
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 210
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 157.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 180
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 135
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 150
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 112.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 120
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 90
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 90
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 67.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 60
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 45
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 30
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 22.5
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
            GaugeLabel {
                labelNumber: 0
                labelNumberSize: speedoMeter.height / speedLabelSize
                labelRotation: 0
                gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
            }
        }
    }

    Rectangle {     // left side gadgets
        x: 3; y: 3
        width: (window.width - mainMeters.width) / 2
        height: window.height - 6
        color: "transparent"
        border.width: 1
        border.color: "#484848"
    }

    Rectangle {     // turn signals
        id: turnSignals
        anchors.horizontalCenter: mainMeters.horizontalCenter
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

    SensoryEngine {
        visible: true
    }
}
