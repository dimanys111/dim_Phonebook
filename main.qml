import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.1

import MyModule 1.0

Window {
    id: window
    width: 640
    height: 480
    visible: true

    MessageDialog {
        id: message_open_Dialog
        title: "Warning"
        text: "Файл не загружен"
    }

    MessageDialog {
        id: message_save_Dialog
        title: "Warning"
        text: "Файл не сохранен"
    }

    FileDialog {
        id: file_openDialog
        nameFilters :[ "База (*.baz)" ]
        defaultSuffix: "baz"
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            if(phone_model.open(file_openDialog.fileUrl)){
                list_view.currentIndex = 0
            }
            else{
                message_open_Dialog.visible=true
            }
        }
        onRejected: {
            message_open_Dialog.visible=true
        }
    }

    FileDialog {
        id: file_saveDialog
        nameFilters :[ "База (*.baz)" ]
        defaultSuffix: "baz"
        title: "Please choose a file"
        folder: shortcuts.home
        selectExisting: false
        onAccepted: {
            if(file_saveDialog.fileUrls.length>0){
                if(!phone_model.save(file_saveDialog.fileUrls[0])){
                     message_save_Dialog.visible=true
                }
            } else {
                message_save_Dialog.visible=true
            }
        }
        onRejected: {
            message_save_Dialog.visible=true
        }
    }

    PhoneModel{
        id: phone_model
    }

    ToolBar {
        id: toolBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Row{
            Column{
                ToolButton {
                    id: open_tool_button
                    icon.source: "open.png"
                    text: "Загрузить из файла"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        file_openDialog.visible = true
                    }
                }
                ToolButton {
                    id: save_tool_button
                    icon.source: "save.png"
                    text: "Сохранить в файл"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        file_saveDialog.visible = true
                    }
                }
            }
            ToolSeparator {}
            Column{
                ToolButton {
                    id: add_tool_button
                    icon.source: "add.ico"
                    text: "Добавить запись"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        scroll_list_view.anchors.bottom = rectangle_add_save.top
                        rectangle_add_save.visible = true
                        but_add.visible=true
                        but_save.visible=false
                    }
                }
                ToolButton {
                    id: delete_tool_button
                    icon.source: "delete.png"
                    text: "Удалить запись"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        if(list_view.currentIndex>-1){
                            phone_model.remove_person(list_view.currentIndex)
                            phone_model.update()
                        }
                    }
                }
            }
            Column{
                ToolButton {
                    id: red_tool_button
                    icon.source: "red.png"
                    text: "Редактировать запись"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        if(list_view.currentIndex>-1){
                            text_input_FIO.text=phone_model.get_person_name(list_view.currentIndex)
                            text_input_phone.text=phone_model.get_person_phone(list_view.currentIndex)
                            text_input_address.text=phone_model.get_person_address(list_view.currentIndex)

                            scroll_list_view.anchors.bottom = rectangle_add_save.top
                            rectangle_add_save.visible = true
                            but_add.visible=false
                            but_save.visible=true
                        }
                    }
                }

                ToolButton {
                    id: clear_tool_button
                    icon.source: "clear.png"
                    text: "Очистить"
                    font.family: "Helvetica"
                    font.bold: true
                    antialiasing: true
                    onClicked: {
                        phone_model.clear()
                    }
                }
            }

            Column{

                ToolButton {
                    id: sort_tool_button
                    CheckBox {
                        width: 150
                        icon.source: "red.png"
                        text: "Сортировка"
                        font.family: "Helvetica"
                        font.bold: true
                        antialiasing: true

                        onCheckedChanged: {
                             phone_model.set_sort(checked)
                        }
                    }
                }
            }
        }
    }

    Item {
        id: item_header
        height: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rectangle_search.bottom
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        Row {
            Rectangle {
                width: 50
                height: 20
                border.width: 1
                border.color: "#808080"
                Text {
                    font.bold: true
                    text: 'Номер:'
                }
            }
            Rectangle {
                width: 180
                height: 20
                border.width: 1
                border.color: "#808080"
                Text {
                    font.bold: true
                    text: 'Ф.И.О.:'
                }
            }
            Rectangle {
                width: 180
                height: 20
                border.width: 1
                border.color: "#808080"
                Text {
                    font.bold: true
                    text: 'Телефон:'
                }
            }
            Rectangle {
                width: 500
                height: 20
                border.width: 1
                border.color: "#808080"
                Text {
                    font.bold: true
                    text: 'Адрес:'
                }
            }
        }

    }

    ScrollView {
        id: scroll_list_view
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: item_header.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        property int scrollSpeed: 20
        focus: true

        ListView {
            id: list_view
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            clip: true
            model: phone_model.proxy_model_property
            focus: true

            delegate: Item {
                id: item_delegate
                width: 1000
                height: 20

                required property int index
                required property string name
                required property string phone
                required property string address

                Row {
                    Rectangle {
                        width: 50
                        height: 20
                        border.width: 1
                        border.color: "#808080"
                        color:  "#00ffffff"
                        Text {
                            text: index+1
                        }
                    }
                    Rectangle {
                        width: 180
                        height: 20
                        border.width: 1
                        border.color: "#808080"
                        color:  "#00ffffff"
                        Text {
                            text: name
                        }
                    }
                    Rectangle {
                        width: 180
                        height: 20
                        border.width: 1
                        border.color: "#808080"
                        color:  "#00ffffff"
                        Text {
                            text: phone
                        }
                    }
                    Rectangle {
                        width: 500
                        height: 20
                        border.width: 1
                        border.color: "#808080"
                        color:  "#00ffffff"
                        Text {
                            text: address
                        }
                    }
                }

                MouseArea {
                    id: mouse_area_delegate
                    anchors.fill: parent
                    onClicked: {
                        scroll_list_view.focus = true
                        list_view.focus = true
                        list_view.currentIndex = index

                        if(rectangle_add_save.visible){
                            text_input_FIO.text=phone_model.get_person_name(list_view.currentIndex)
                            text_input_phone.text=phone_model.get_person_phone(list_view.currentIndex)
                            text_input_address.text=phone_model.get_person_address(list_view.currentIndex)
                        }
                    }
                    onWheel: {
                        if (wheel.angleDelta.y > 0) {
                            list_view.contentY -= scroll_list_view.scrollSpeed
                            if (list_view.contentY < 0) {
                                list_view.contentY = 0;
                            }
                        } else {
                            if(list_view.contentHeight>scroll_list_view.height){
                                list_view.contentY += scroll_list_view.scrollSpeed;
                                if (list_view.contentY + scroll_list_view.height > list_view.contentHeight) {
                                    list_view.contentY = list_view.contentHeight -  scroll_list_view.height;
                                }
                            }
                        }
                    }
                }
            }

            highlightMoveDuration : 200
            highlightMoveVelocity : 1000
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        }
    }

    Rectangle {
        id: rectangle_search
        height: 24
        visible: true
        color: "#ffffff"
        border.width: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: toolBar.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        border.color: "#000000"

        Text {
            id: text_search
            width: 46
            font.bold: true
            text: 'Поиск:'
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 12
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0
        }

        TextInput {
            id: text_input_search
            anchors.left: text_search.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 12
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            focus: true
            selectByMouse: true
            onTextChanged: {
                phone_model.proxy_model_property.setTextFilter(text_input_search.text)
            }
        }
    }

    Rectangle {
        id: rectangle_add_save
        height: 200
        visible: false
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        border.width: 2
        border.color: "#000000"

        Column{
            x: 10
            y: 10
            spacing: 10
            Grid {
                id: grid
                columns: 2
                spacing: 2

                Text {
                    id: text_FIO
                    height: text_input_FIO.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Ф.И.О.:")
                    font.pixelSize: 12
                }

                TextField  {
                    id: text_input_FIO
                    text: qsTr("Иванов Иван Иванович")
                    font.pixelSize: 12
                    focus: true
                    selectByMouse: true
                }

                Text {
                    id: text_phone
                    height: text_input_phone.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Телефон:")
                    font.pixelSize: 12
                }

                TextField {
                    id: text_input_phone
                    text: qsTr("+79111234567")
                    font.pixelSize: 12
                    focus: true
                    selectByMouse: true
                }

                Text {
                    id: text_address
                    height: text_input_address.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Адрес:")
                    font.pixelSize: 12
                }

                TextField  {
                    id: text_input_address
                    text: qsTr("ул. Маяковского")
                    font.pixelSize: 12
                    focus: true
                    selectByMouse: true
                }
            }
            Row{
                spacing: 5
                Button{
                    id: but_add
                    text: "&Добавить"
                    font.bold: true
                    onClicked: {
                        phone_model.addPerson(text_input_FIO.text,text_input_phone.text,text_input_address.text)
                        phone_model.update()
                        list_view.currentIndex=phone_model.get_last_index()
                    }
                }
                Button{
                    id: but_save
                    text: "&Сохранить"
                    font.bold: true
                    onClicked: {
                        phone_model.setPerson(list_view.currentIndex,text_input_FIO.text,text_input_phone.text,text_input_address.text)
                        list_view.currentIndex=phone_model.curent_index_property
                    }
                }
                Button{
                    text: "Отмена"
                    font.bold: true
                    onClicked: {
                        rectangle_add_save.visible = false
                        scroll_list_view.anchors.bottom = scroll_list_view.parent.bottom
                    }
                }
            }
        }
    }

}








