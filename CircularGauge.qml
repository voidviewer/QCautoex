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
        border.color: "white"
        border.width: parent.height * 0.0175
        radius: width * 0.5
        opacity: 0.5
        Rectangle {         // gauge background
            anchors.centerIn: parent
            width: parent.width * 0.99
            height: parent.height * 0.99
            radius: width * 0.5
            color: "#000000"
        }
        Rectangle {     // needle
            id: gaugeNeedle
            height: (gaugeCircle.height / 2) * 0.9
            width: {
                if (height / 30 >= 1) {
                    height / 30
                } else {
                    1
                }
            }
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fb4f14" }    // base
                //GradientStop { position: 1.0; color: "#fcf75e" }
                GradientStop { position: 1.0; color: "#ffffff" }    // tip
            }
            transform: Rotation {
                origin.x: gaugeNeedle.width / 2;
                origin.y: gaugeCircle.y;
                angle: 45 + needleRotation
            }
            Shape {     // needle center
                ShapePath {
                    strokeWidth: 1
                    strokeColor: "#fb4f14"
                    fillColor: "#ffffff"
                    startX: -(gaugeNeedle.height / 20) + (gaugeNeedle.width / 2);
                    startY: -(gaugeNeedle.height / 20)
                    PathLine {
                        x: (gaugeNeedle.height / 20) + (gaugeNeedle.width / 2);
                        y: -(gaugeNeedle.height / 20)
                    }
                    PathLine {
                        x: gaugeNeedle.width / 2;
                        y: gaugeNeedle.height / 20
                    }
                    PathLine {
                        x: -(gaugeNeedle.height / 20) + (gaugeNeedle.width / 2) + 0.001;
                        y: -(gaugeNeedle.height / 20) + 0.001
                    }
                }
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
        opacity: 0.65
    }
}
