//
// Module provides base item for circular gauges.
//
import QtQuick 2.0
import QtQuick.Shapes 1.15

Item {
    property int needleRotation: 0
    property string gaugeName: "*"

    id: root

    Rectangle {
        id: gaugeCircle     // gauge border
        width: parent.width
        height: parent.height
        color: "transparent"
        //border.color: showGadgetDecor ? "white" : "transparent"
        //border.width: showGadgetDecor ? parent.height * 0.0175 : 0
        radius: width * 0.5
        //opacity: 0.5
        Rectangle {         // gauge background
            visible: showGadgetDecor
            anchors.centerIn: parent
            width: parent.width * 0.99
            height: parent.height * 0.99
            radius: width * 0.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#323232" }
                GradientStop { position: 0.5; color: "#000000" }
            }
            opacity: 0.45
        }
        Image {     // gauge needle
            id: gaugeNeedle
            source: "images/needle.svg"
            height: (gaugeCircle.height / 2) * 0.75
            width: {
                if (height / 8 >= 1) {
                    height / 8
                } else {
                    1
                }
            }
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 2
            transform: Rotation {
                origin.x: gaugeNeedle.width / 2;
                origin.y: gaugeCircle.y;
                angle: engineRunning ? 45 + needleRotation : 45
            }
        }
    }
    Text {      // gauge description text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: (parent.height / 2) + (parent.height * 0.05)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        text: gaugeName
        font.pixelSize: {
            if ((parent.height * 0.05) > 0) {
                parent.height * 0.05
            } else {
                1
            }
        }
        color: "#fb4f14"
        opacity: 1
    }
}
