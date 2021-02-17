import QtQuick 2.0
import QtQuick.Shapes 1.15

Item {
    property int needleRotation: 0
    property string gaugeName: "*"

    id: root
    width: 400
    height: 400

    Rectangle {
        id: gaugeCircle     // gauge border
        width: parent.width - (window.height * 0.025)
        height: parent.height - (window.height * 0.025)
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.color: "white"
        border.width: window.height * 0.015
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
            height: (gaugeCircle.height / 2) * 0.94
            width: height / 40
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height / 2
            color: "#fb4f14"
            transform: Rotation {
                origin.x: gaugeNeedle.width / 2;
                origin.y: (gaugeCircle.y);
                angle: 45 + needleRotation
            }
            Shape {     // needle center
                ShapePath {
                    strokeWidth: 1
                    strokeColor: "#fb4f14"
                    fillColor: "#fafafa"
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
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 2.6
        text: gaugeName
        font.pixelSize: {
            if ((window.height * 0.0375) > 0) {
                window.height * 0.0375
            } else {
                1
            }
        }
        color: "white"
        opacity: 0.65
    }
}
