import QtQuick 2.0

Item {
    property int buttonHeight: 24
    property int buttonSpacing: 8

    DefaultButton {
        id: startStopButton
        buttonText: "Start/Stop"
        anchors.left: parent.left
        anchors.leftMargin: buttonSpacing
        onClicked: {
            rpmTimer.running = !rpmTimer.running
            speedTimer.running = !speedTimer.running
            turnSignals.running = !turnSignals.running
            gearTimer.running = !gearTimer.running
        }
    }
    DefaultButton {
        id: resetButton
        buttonText: "Reset"
        anchors.left: startStopButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            rpmTimer.running = false
            revMeter.needleRotation = 0
            sensoryEngine.rpm = 0
            speedTimer.running = false
            speedoMeter.needleRotation = 0
            sensoryEngine.speed = 0
            turnSignals.running = false
            turnSignalsItem.resetTurnSignals()
        }
    }
    DefaultButton {
        id: frameModeButton
        buttonText: "Toggle frame"
        anchors.left: resetButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            if (window.flags !== 2048) {
                window.flags = "FramelessWindowHint"
            } else {
                window.flags = 1
            }
            console.log("window.flags: " + window.flags);
        }
    }
    DefaultButton {
        id: quitButton
        buttonText: "Quit"
        anchors.left: frameModeButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            Qt.quit()
        }
    }
}
