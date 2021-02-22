//
// Module receives dashboard data from client,
// parses the data and applies it to dashboard gadgets.
//
import QtQuick 2.0
import QtWebSockets 1.0

Item {
    property string serverUrl: server.url

    function setGauge(gaugeIn) {
        var gaugeType = gaugeIn.substring(0,2)
        var gaugeValue = gaugeIn.substring(2)

        switch(gaugeType) {
        case "Ar":  // engine stop
            engineRunning = false
            break;
        case "Wb":
            switch(gaugeValue) {
            case "1":
                window.flags = "FramelessWindowHint"
                break;
            case "0":
                window.flags = 1
                break;
            default:
                break;
            }
            break;
        case "Ws":
            window.height = gaugeValue;
            window.width = gaugeValue * 4;
            break;
        case "R ":
            gaugeValue = gaugeValue * (270 / 9000)
            revMeter.needleRotation = gaugeValue;
            break;
        case "S ":
            speedDisplay.speed = gaugeValue
            gaugeValue = gaugeValue * (270 / 360)
            speedoMeter.needleRotation = gaugeValue;
            break;
        case "T ":
            turnSignalsItem.signalValue = gaugeValue
            break;
        case "G ":
            gearDisplay.gear = gaugeValue
            break;
        case "Eo":
            engineOilTempGauge.gaugeValue = gaugeValue
            break;
        case "Ep":
            engineOilPressureGauge.gaugeValue = gaugeValue
            break;
        case "Et":
            engineWaterTempGauge.gaugeValue = gaugeValue
            break;
        case "Gt":
            transOilTempGauge.gaugeValue = gaugeValue
            break;
        case "Gp":
            transOilPressureGauge.gaugeValue = gaugeValue
            break;
        case "Fa":
            fuelAmountGauge.gaugeValue = gaugeValue
            break;
        case "Fp":
            fuelPressureGauge.gaugeValue = gaugeValue
            break;
        case "Dm":
            clockGauge.gaugeValue = gaugeValue
            break;
        default:
            break;
        }
    }

    WebSocketServer {
        id: server
        listen: true
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(gaugeIn) {
                setGauge(qsTr("%1").arg(gaugeIn));
                //webSocket.sendTextMessage(qsTr("Hello Client!"));
            });
        }
        onErrorStringChanged: {
            console.log(qsTr(timeOfDay() + " Server error: %1").arg(errorString));
        }
    }

    WebSocket {
        id: socket
        url: server.url
        active: true
//        onTextMessageReceived: {
//            sendTextMessage(qsTr("Hello Server!"));
//            console.log(timeOfDay() + " Server received message: " + socket.textMessageReceived())
//        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log(timeOfDay() + " Server received message: " + socket.errorString)
            } else if (socket.status == WebSocket.Closed) {
                console.log(qsTr("Server socket closed."));
            }
        }
    }
}
