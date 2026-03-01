import QtQuick
import Quickshell
// import Quickshell.Services.System

ShellRoot {
    // This automatically handles the bar for each connected monitor
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var screenModel: modelData
            screen: screenModel
            
            // Anchors the bar to the top and spans the width
            anchors {
                top: true
                left: true
                right: true
            }
            
            height: 32
            color: "#1e1e2e" // Catppuccin Mocha base

            Row {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 20

                Text {
                    text: "❄️ NixOS"
                    color: "#cdd6f4"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                }

                Text {
                    text: screenModel.name
                    color: "#89b4fa"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Spacer to push clock to the right
                Item {
                    width: parent.width - childrenRect.width - 150 
                    height: parent.height
                }

                Text {
                    // Simple clock using Quickshell's built-in timer logic if needed, 
                    // or just a static placeholder for now
                    text: Qt.formatDateTime(new Date(), "hh:mm:ss")
                    color: "#a6adc8"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
