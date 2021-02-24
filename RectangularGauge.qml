//
// Module provides base item for rectangular gauges.
//
import QtQuick 2.7
import QtQuick.Shapes 1.15

Item {
    property real gaugeValue: 500   // has to be bigger than any max gauge value
    property int gaugeMin: 0
    property int gaugeMax: 1
    property string gaugeName: "*"
    property string gaugeDirection: "right"
    property string gradientDirection: "right"

    Rectangle {
        id: gaugeRectangle  // gauge border
        width: parent.width
        height: parent.height
        color: "transparent"
        //border.color: showGadgetDecor ? "#969696" : "transparent"
        //border.width: showGadgetDecor ? parent.height * 0.045 : 0

//        Rectangle {         // gauge background
//            visible: showGadgetDecor
//            anchors.centerIn: parent
//            width: parent.width * 0.98
//            height: parent.height * 0.96
//            color: "#000000"
//            opacity: 0.5
//        }

        Rectangle {     // slider background
            id: gaugeNeedle
            width: parent.height * 0.225
            height: parent.width * 0.9
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height * -0.3
            //color: "#00cccc"
            opacity: 0.9
            rotation: {
                if (gaugeDirection == "right") {
                    -90
                } else {
                    90
                }
            }
            radius: gaugeNeedle.height / 30

            Gradient {
                id: gaugeGradientRight
                GradientStop { position: 0.0; color: "#1e90ff" }
                GradientStop { position: 0.35; color: "#0bda51" }
                GradientStop { position: 0.65; color: "#0bda51" }
                GradientStop { position: 1.0; color: "#ff0000" }
            }
            Gradient {
                id: gaugeGradientLeft
                GradientStop { position: 1.0; color: "#1e90ff" }
                GradientStop { position: 0.65; color: "#0bda51" }
                GradientStop { position: 0.35; color: "#0bda51" }
                GradientStop { position: 0.0; color: "#ff0000" }
            }
            gradient: {
                if (gradientDirection == "right") {
                    gaugeGradientRight
                } else {
                    gaugeGradientLeft
                }
            }

            Rectangle {     // slider
                id: gaugeSlider
                width: parent.width
                height: parent.height - (parent.height - ((parent.height / (gaugeMax - gaugeMin)) * (gaugeMax - gaugeValue)))
                anchors.bottom: parent.bottom
                color: "#161616"
                opacity: 0.8
            }
        }
        Text {      // gauge description text
            anchors.centerIn: parent
            transform: Scale { yScale: 0.6 }
            anchors.verticalCenterOffset: parent.height * 0.3
            text: gaugeName
            font.pixelSize: {
                if ((parent.height * 0.225) > 0) {
                    parent.height * 0.225
                } else {
                    1
                }
            }
            //font.weight: Font.Thin
            //color: "#fb4f14"
            //color: "#ffffff"
            color: descriptionColor
            //opacity: 0.65
        }
    }
}
