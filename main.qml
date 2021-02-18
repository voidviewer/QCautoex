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

            Rectangle {     // gear display
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

            Repeater {      // revolution value labels
                model: 9
                delegate: GaugeLabel {
                    labelNumber: index + 1
                    labelNumberSize: revMeter.height / revLabelSize
                    labelRotation: (index + 1) * 30
                    gaugeLabelCenterMultiplierX: revLabelCenterMultiplierX
                    gaugeLabelCenterMultiplierY: revLabelCenterMultiplierY
                }
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

            Repeater {      // speed value labels
                model: 13
                delegate: GaugeLabel {
                    labelNumber: index * 30
                    labelNumberSize: speedoMeter.height / speedLabelSize
                    labelRotation: index * 22.5
                    gaugeLabelCenterMultiplierX: speedLabelCenterMultiplierX
                    gaugeLabelCenterMultiplierY: speedLabelCenterMultiplierY
                }
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
