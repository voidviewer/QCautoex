import QtQuick 2.0

Item {
    id: controlButtons
    property int buttonHeight: 24
    property int buttonSpacing: 4

    DefaultButton {
        id: startStopButton
        buttonText: "Start/Stop"
        anchors.left: parent.left
        anchors.leftMargin: buttonSpacing
        onClicked: {
            toggleEngine()
        }
    }
    DefaultButton {
        id: resetButton
        buttonText: "Reset"
        anchors.left: startStopButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            resetEngine()
        }
    }
    DefaultButton {
        id: quitButton
        buttonText: "Quit"
        anchors.left: resetButton.right
        anchors.leftMargin: buttonSpacing
        onClicked: {
            Qt.quit()
        }
    }

    function toggleEngine() {
        engineRunning = !engineRunning
        rpmTimer.running = !rpmTimer.running
        speedTimer.running = !speedTimer.running
        turnSignals.running = !turnSignals.running
        gearTimer.running = !gearTimer.running
        engineOilTemperatureTimer.running = !engineOilTemperatureTimer.running
        engineOilPressureTimer.running = !engineOilPressureTimer.running
        engineWaterTemperatureTimer.running = !engineWaterTemperatureTimer.running
        transmissionOilTemperatureTimer.running = !transmissionOilTemperatureTimer.running
        transmissionOilPressureTimer.running = !transmissionOilPressureTimer.running
    }

    function resetEngine() {
        engineRunning = false
        rpmTimer.running = false
        revMeter.needleRotation = 0
        sensoryEngine.rpm = 0
        speedTimer.running = false
        speedoMeter.needleRotation = 0
        sensoryEngine.speed = 0
        turnSignals.running = false
        turnSignalsItem.resetTurnSignals()
        gearTimer.running = false
        gearDisplay.gear = "P"
        speedDisplay.speedValue = "0"
        engineOilTemperatureTimer.running = false
        engineOilTemperatureGauge.gaugeValue = 50
        engineOilPressureTimer.running = false
        engineOilPressureGauge.gaugeValue = 0.0
        engineWaterTemperatureTimer.running = false
        engineWaterTemperatureGauge.gaugeValue = 50
        transmissionOilTemperatureTimer.running = false
        transmissionOilTemperatureGauge.gaugeValue = 50
        transmissionOilPressureTimer.running = false
        transmissionOilPressureGauge.gaugeValue = 0.0
    }
}
