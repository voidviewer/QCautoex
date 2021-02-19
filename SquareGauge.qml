//
// Module provides base item for circular gauges.
//
import QtQuick 2.7
import QtQuick.Shapes 1.15

Item {
    property int gaugeValue: 0
    property string gaugeName: "*"

    Rectangle {
        id: gaugeRectangle     // gauge border
        width: parent.width
        height: parent.height
        color: "transparent"
        border.color: "#969696"
        border.width: parent.height * 0.07

        Rectangle {         // gauge background
            anchors.centerIn: parent
            width: parent.width * 0.98
            height: parent.height * 0.96
            color: "#000000"
            opacity: 0.5
        }
        Rectangle {     // slider background
            id: gaugeNeedle
            width: parent.height * 0.45
            height: parent.width * 0.9
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height * -0.17
            color: "#00cccc"
            rotation: -90
            gradient: Gradient {
                GradientStop { position: 0.0; color: "blue" }
                GradientStop { position: 1.0; color: "red" }
            }

            //opacity: 0.4
            Rectangle {     // slider
                id: gaugeSlider
                width: parent.width
                height: parent.height - ((parent.height / 100) * gaugeValue)
                anchors.bottom: parent.bottom
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                color: "#161616"
                opacity: 1
            }
        }
        Text {      // gauge description text
            anchors.centerIn: parent
            transform: Scale { yScale: 0.75 }
            anchors.verticalCenterOffset: parent.height * 0.28
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
