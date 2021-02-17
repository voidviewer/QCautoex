import QtQuick 2.0
import QtQuick.Shapes 1.15

Item {
    property int signalSize: 32
    property string signalValue: "o"
    property string lightOn: "#90ee90"
    property string lightOff: "#006400"

    onSignalValueChanged: {
        turnSignalTimer.running = true
    }

    Timer {
        id: turnSignalTimer
        repeat: true
        interval: 400
        onTriggered: {
            switch(signalValue) {
            case "l":
                if (leftShapePath.fillColor == lightOn) {
                    leftShapePath.fillColor = lightOff;
                } else {
                    leftShapePath.fillColor = lightOn;
                }
                rightShapePath.fillColor = lightOff;
                break;
            case "r":
                if (rightShapePath.fillColor == lightOn) {
                    rightShapePath.fillColor = lightOff;
                } else {
                    rightShapePath.fillColor = lightOn;
                }
                leftShapePath.fillColor = lightOff;
                break;
            default:
                resetTurnSignals()
                break;
            }
        }
    }

    function resetTurnSignals() {
        leftShapePath.fillColor = lightOff;
        rightShapePath.fillColor = lightOff;
        turnSignalTimer.running = false
    }

    Shape {     // left
        id: signalShapeLeft
        width: signalSize; height: signalSize
        x: 1
        transform: Rotation {
            origin.x: (signalShapeLeft.width / 2) - 1;
            origin.y: (signalShapeLeft.height / 2) - 1;
            angle: 90
        }
        ShapePath {
            id: leftShapePath
            strokeWidth: 2
            strokeColor: "grey"
            fillColor: "darkgreen"
            startX: 0; startY: 0
            PathLine { x: signalShapeLeft.width; y: 0 }
            PathLine { x: (signalShapeLeft.width / 2) - 1; y: signalShapeLeft.height }
            PathLine { x: 0.1; y: 0.1 }
        }
    }

    Shape {     // right
        id: signalShapeRight
        width: signalSize; height: signalSize
        x: turnSignals.width - signalShapeRight.width
        transform: Rotation {
            origin.x: (signalShapeRight.width / 2);
            origin.y: (signalShapeRight.height / 2);
            angle: -90
        }
        ShapePath {
            id: rightShapePath
            strokeWidth: 2
            strokeColor: "grey"
            fillColor: "darkgreen"
            startX: 0; startY: 0
            PathLine { x: signalShapeRight.width; y: 0 }
            PathLine { x: (signalShapeRight.width / 2) - 1; y: signalShapeRight.height }
            PathLine { x: 0.1; y: 0.1 }
        }
    }
}
