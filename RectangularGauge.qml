//
// Module provides base item for rectangular gauges.
//
import QtQuick 2.7
import QtQuick.Shapes 1.15
import QtQuick.Controls 1.4

Item {
    property real gaugeValue: 0.0
    property int gaugeMin: 0
    property int gaugeMax: 1
    property string gaugeName: "*"
    property string gaugeDirection: "right"

    Rectangle {
        id: gaugeRectangle     // gauge border
        width: parent.width
        height: parent.height
        color: "transparent"
        border.color: "#969696"
        border.width: parent.height * 0.045

        Rectangle {         // gauge background
            anchors.centerIn: parent
            width: parent.width * 0.98
            height: parent.height * 0.96
            color: "#000000"
            opacity: 0.5
        }
        Rectangle {     // slider background
            id: gaugeSliderBackground
            width: parent.height * 0.225
            height: parent.width * 0.9
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height * -0.3
            color: "#00cccc"
            opacity: 0.9
            rotation: {
                if (gaugeDirection == "right") {
                    -90
                } else {
                    90
                }
            }
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1e90ff" }
                GradientStop { position: 0.35; color: "#0bda51" }
                GradientStop { position: 0.65; color: "#0bda51" }
                GradientStop { position: 1.0; color: "#ff0000" }
            }

            Rectangle {     // slider
                id: gaugeSlider
                width: parent.width
                //height: parent.height - (parent.height - ((parent.height / (gaugeMax - gaugeMin)) * (gaugeMax - gaugeValue)))
                height: {
                    if (engineRunning && gaugeValue > 0) {
                        parent.height - (parent.height - ((parent.height / (gaugeMax - gaugeMin)) * (gaugeMax - gaugeValue)))
                    } else {
                        height: 0
                    }
                }
                anchors.bottom: parent.bottom
                color: "#161616"
                opacity: 0.8
            }
        }
        Text {      // gauge description text
            anchors.centerIn: parent
            transform: Scale { yScale: 0.75 }
            anchors.verticalCenterOffset: parent.height * 0.3
            text: gaugeName
            font.pixelSize: {
                if ((parent.height * 0.25) > 0) {
                    parent.height * 0.25
                } else {
                    1
                }
            }
            color: "#fb4f14"
            opacity: 0.65
        }
    }
}
