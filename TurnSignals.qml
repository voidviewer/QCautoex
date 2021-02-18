//
// Module contains turn lights.
//
import QtQuick 2.0
import QtQuick.Shapes 1.15

Item {
    //property int turnSignalSize: 32
    property int turnSignalSize: window.height * 0.067
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
        //id: signalShapeLeft
        width: turnSignalSize; height: turnSignalSize
        x: 1
        transform: Rotation {
            origin.x: turnSignalSize / 2;
            origin.y: turnSignalSize / 2;
            angle: 90
        }
        ShapePath {
            id: leftShapePath
            strokeWidth: 2
            strokeColor: "grey"
            fillColor: "darkgreen"
            startX: 0; startY: 0
            PathLine { x: turnSignalSize; y: 0 }
            PathLine { x: (turnSignalSize / 2) - 1; y: turnSignalSize }
            PathLine { x: 0.1; y: 0.1 }
        }
    }

    Shape {     // right
        //id: signalShapeRight
        width: turnSignalSize; height: turnSignalSize
        x: turnSignals.width - (2 * turnSignalSize)
        transform: Rotation {
            origin.x: turnSignalSize / 2;
            origin.y: turnSignalSize / 2 - 0.5;
            angle: -90
        }
        ShapePath {
            id: rightShapePath
            strokeWidth: 2
            strokeColor: "grey"
            fillColor: "darkgreen"
            startX: 0; startY: 0
            PathLine { x: turnSignalSize; y: 0 }
            PathLine { x: (turnSignalSize / 2) - 1; y: turnSignalSize }
            PathLine { x: 0.1; y: 0.1 }
        }
    }
}
