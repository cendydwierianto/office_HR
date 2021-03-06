
import React, { Component } from 'react';

import {
    ScrollView, Text, View, StatusBar, ActivityIndicator, Image,
    BackHandler, AsyncStorage, TextInput, TouchableOpacity,
    ToastAndroid, Platform, KeyboardAvoidingView, NetInfo
} from 'react-native';


import {
    DailyAttendanceCombo, TasksCombo,
    LeavesCombo, FinanceCombo,
    ReportsCombo, NoticeCombo, SettingsCombo,
    drawerSelectedOption
} from '../../MenuDrawer/DrawerContent';

import { Actions } from 'react-native-router-flux';
import { EmployeeList } from '../../../services/EmployeeTrackService';
import { NoticeStyle } from '../notice/NoticeStyle'
import Modal from 'react-native-modalbox';
import moment from "moment";
import { CommonStyles } from '../../../common/CommonStyles';
import DateTimePicker from 'react-native-modal-datetime-picker';
// import {


//     Feather,
//     Ionicons,
//     MaterialCommunityIcons
// } from '@expo/vector-icons'

import Feather from 'react-native-vector-icons/Feather'
import Ionicons from 'react-native-vector-icons/Ionicons'
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons'

import _ from "lodash";

import { TaskStyle } from './TaskStyle';
import * as actions from '../../../common/actions';
import { SaveTask, PriorityList } from '../../../services/TaskService';


const refreshOnBack = () => {
    if( global.userType=="admin"){
        Actions.TabnavigationInTasks();
        Actions.TaskListScreen();
    }else{
        Actions.userTask();
        Actions.CreateByMe();
    }
    
}



const STATUS_BAR_HEIGHT = Platform.OS === 'ios' ? 20 : StatusBar.currentHeight;
function StatusBarPlaceHolder() {
    return (
        <View style={{
            width: "100%",
            height: STATUS_BAR_HEIGHT,
            backgroundColor: '#F3F3F3',
        }}>
            <StatusBar />
        </View>
    );
}

export default class CreateTask extends Component {
    constructor(props) {
        super(props);
        this.state = {
            userId: "",
            companyId: "",
            date: '',
            taskTitle: "",
            taskDescription: "",
            EmployeeList: [],
            priorityList: [],
            isDateTimePickerVisible: false,
            PriorityId: null,
            PriorityName: null,
            touchabledisableForsaveTask: false,
            EmpName: null,
            EmpValue: null,
            TaskGroupId: 0,
        }
    }

    goBackToTasks() {
        TasksCombo();
    }
    goBack() {
        Actions.pop();
    }
    returnPage() {
        actions.push("TaskListScreen");
    }


    _showDateTimePicker = () => this.setState({ isDateTimePickerVisible: true });
    _hideDateTimePicker = () => this.setState({ isDateTimePickerVisible: false });

    _handleDatePicked = (date) => {
        this.setState({ date: date })

        this._hideDateTimePicker();
    }

    async componentDidMount() {
        const uId = await AsyncStorage.getItem("userId");
        const cId = await AsyncStorage.getItem("companyId");
        this.setState({ userId: uId, companyId: cId });
        this.getEmployeeList(cId);
        this.getPriorityList();
        this.setState({ TaskGroupId: this.props.BoardId })
        BackHandler.addEventListener('hardwareBackPress', this.handleBackButton);
    }

    async saveTask() {
        if (await NetInfo.isConnected.fetch()) {
            if (this.state.taskTitle !== "") {
                this.setState({ touchabledisableForsaveTask: true })
                try {
                    let taskModel = {
                        CreatedById: this.state.userId,
                        CompanyId: this.state.companyId,
                        Title: this.state.taskTitle,
                        Description: this.state.taskDescription,
                        AssignToName: this.state.EmpName,
                        AssignedToId: this.state.EmpValue,
                        TaskGroupId: this.state.TaskGroupId,
                        PriorityId: this.state.PriorityId,
                        DueDate: moment(this.state.date).format("YYYYY-MM-DD")
                    };
                    this.setState({ progressVisible: true });
                    await SaveTask(taskModel)
                        .then(res => {
                            this.setState({ progressVisible: false });
                            ToastAndroid.show('Task saved successfully', ToastAndroid.TOP);
                            refreshOnBack();
                           // this.setState({ touchabledisableForsaveTask: false })


                        })
                        .catch(() => {
                            this.setState({ progressVisible: false });
                            console.log("error occured");
                            this.setState({ touchabledisableForsaveTask: false })

                        });

                } catch (error) {
                    this.setState({ progressVisible: false });
                    console.log(error);

                }
            } else {
                ToastAndroid.show('Title Can not be Empty ', ToastAndroid.TOP);

            }
        } else {
            ToastAndroid.show('Please connect to Internet', ToastAndroid.TOP);
        }

        
    }

    getEmployeeList = async (companyId) => {
        try {
            await EmployeeList(companyId)
                .then(res => {
                    this.setState({ EmployeeList: res.result, progressVisible: false });
                })
                .catch(() => {
                    this.setState({ progressVisible: false });
                });

        } catch (error) {
            this.setState({ progressVisible: false });
        }
    }

    getPriorityList = async () => {
        try {
            await PriorityList()
                .then(res => {
                    this.setState({ priorityList: res.result, progressVisible: false });
                })
                .catch(() => {
                    this.setState({ progressVisible: false });
                });

        } catch (error) {
            this.setState({ progressVisible: false });
        }
    }

    async  setAssignTo(v, t) {
        this.setState({ EmpName: t })
        this.setState({ EmpValue: v })
        this.refs.modal1.close()
    }

    renderEmpList() {
        let content = this.state.EmployeeList.map((empName, i) => {
            return (
                <TouchableOpacity style={{ paddingVertical: 7, borderBottomColor: '#D5D5D5', borderBottomWidth: 2 }} key={i}
                    onPress={() => { this.setAssignTo(empName.Value, empName.Text) }}>
                    <Text style={[{ textAlign: 'center' }, TaskStyle.dbblModalText]} key={empName.Value}>{empName.Text}</Text>
                </TouchableOpacity>
            )
        });
        return content;
    }

    async  setPriority(id, name) {
        this.setState({ PriorityId: id })
        this.setState({ PriorityName: name })
        this.refs.modalPriority.close()
    }

    renderPriorityList() {
        let content = this.state.priorityList.map((x, i) => {
            return (
                <TouchableOpacity style={{ paddingVertical: 7, borderBottomColor: '#D5D5D5', borderBottomWidth: 2 }} key={i}
                    onPress={() => { this.setPriority(x.Id, x.Name) }}>
                    <Text style={[{ textAlign: 'center' }, TaskStyle.dbblModalText]} key={x.Id}>{x.Name}</Text>
                </TouchableOpacity>
            )
        });
        return content;
    }

    handleBackButton = () => {
        this.goBack();
        return true;
    }

    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackButton);
    }

    render() {
        return (
            <View
                style={{
                    flex: 1, backgroundColor: '#ffffff', flexDirection: 'column',
                }}>
              <StatusBarPlaceHolder />
                <View
                    style={CommonStyles.HeaderContent}>
                    <View
                        style={CommonStyles.HeaderFirstView}>
                        <TouchableOpacity
                            style={CommonStyles.HeaderMenuicon}
                            onPress={() => { this.goBack() }}>
                            <Image resizeMode="contain" style={CommonStyles.HeaderMenuiconstyle}
                                source={require('../../../assets/images/left_arrow.png')}>
                            </Image>
                        </TouchableOpacity>
                        <View
                            style={CommonStyles.HeaderTextView}>
                            <Text
                                style={CommonStyles.HeaderTextstyle}>
                                Create Task
                            </Text>
                        </View>
                    </View>
                    <View
                        style={CommonStyles.createTaskButtonContainer}>
                        <TouchableOpacity
                            disabled={this.state.touchabledisableForsaveTask}
                            onPress={() => this.saveTask()}
                            style={CommonStyles.createTaskButtonTouch}>
                            <View style={CommonStyles.plusButton}>
                                <MaterialCommunityIcons name="content-save" size={17.5} color="#ffffff" />
                            </View>
                            <View style={CommonStyles.ApplyTextButton}>
                                <Text style={CommonStyles.ApplyButtonText}>
                                    POST
                                </Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>

                <View style={{ flex: 1 }}>
               
                    <ScrollView showsVerticalScrollIndicator={false}
                        keyboardDismissMode="on-drag"
                        style={{ flex: 1, }}>
                        <View
                            style={TaskStyle.titleInputRow}>
                            <Text
                                style={TaskStyle.createTaskTitleLabel1}>
                                Title:
                                </Text>
                            <TextInput
                                style={TaskStyle.createTaskTitleTextBox1}
                                placeholder="write a task name here"
                                placeholderTextColor="#dee1e5"
                                autoCapitalize="none"
                                onChangeText={text => this.setState({ taskTitle: text })}
                            >
                            </TextInput>
                        </View>
                        <View
                            style={TaskStyle.descriptionInputRow}>
                            <Text
                                style={TaskStyle.createTaskTitleLabel11}>
                                Description:
                                    </Text>
                            <TextInput
                                style={TaskStyle.createTaskDescriptionTextBox}
                                multiline={true}
                                placeholder="write details here"
                                placeholderTextColor="#dee1e5"
                                autoCorrect={false}
                                autoCapitalize="none"
                                onChangeText={text => this.setState({ taskDescription: text })}
                            >
                            </TextInput>
                        </View>
                        <TouchableOpacity onPress={() => this.refs.modal1.open()}>
                            <View

                                style={TaskStyle.assignePeopleContainer}>
                                <Ionicons name="md-people" size={20} style={{ marginRight: 4, }} color="#4a535b" />
                                <TextInput
                                    style={TaskStyle.assigneePeopleTextBox}
                                    placeholder="Assign People"
                                    placeholderTextColor="#dee1e5"
                                    editable={false}
                                    autoCapitalize="none"
                                    value={this.state.EmpName}
                                >
                                </TextInput>
                            </View>
                        </TouchableOpacity>
                        <View style={TaskStyle.assigneePeopleTextBoxDivider}>
                            {/* horizontal line dummy view */}
                        </View>
                        <TouchableOpacity onPress={() => this.refs.modalPriority.open()}>
                            <View
                                style={TaskStyle.assignePeopleContainer}>
                                <Ionicons name="ios-stats" size={18} style={{ marginHorizontal: 5, }}
                                    color="#4a535b" />
                                <TextInput
                                    style={TaskStyle.assigneePeopleTextBox}
                                    placeholder="Priority"
                                    placeholderTextColor="#dee1e5"
                                    editable={false}
                                    autoCapitalize="none"
                                    value={this.state.PriorityName}
                                >
                                </TextInput>
                            </View>
                        </TouchableOpacity>
                        <View style={TaskStyle.assigneePeopleTextBoxDivider}>
                            {/* horizontal line dummy view */}
                        </View>
                        <View
                            style={TaskStyle.createTaskAttachmentContainer}>

                            <View style={TaskStyle.createTaskDueDateContainer}>
                                <TouchableOpacity onPress={this._showDateTimePicker}
                                    style={TaskStyle.createTaskDueDateIcon}>
                                    <MaterialCommunityIcons name="clock-outline" size={18} color="#4a535b"
                                        style={{ marginHorizontal: 5, }} />
                                    {this.state.date === "" ?
                                        <Text
                                            style={TaskStyle.createTaskDueDateText}>
                                            Due Date:
                                       </Text> :
                                        <Text
                                            style={TaskStyle.createTaskDueDateText}>
                                            {moment(this.state.date).format("DD MMMM YYYYY")}
                                        </Text>
                                    }

                                </TouchableOpacity>
                                <DateTimePicker
                                    isVisible={this.state.isDateTimePickerVisible}
                                    onConfirm={this._handleDatePicked}
                                    onCancel={this._hideDateTimePicker}
                                    mode={'date'}
                                />
                                <View
                                    style={TaskStyle.Viewforavoid}>
                                </View>
                            </View>

                        </View>
                    </ScrollView>
               </View>

                {/* <View style={{ justifyContent: 'flex-end', }}>
                        <View
                            style={{ height: 50, }}>
                        </View>
                        <TouchableOpacity onPress={() => this.saveTask()}
                            style={TaskStyle.createTaskSaveButtonContainer}>
                            <Feather name="edit" size={14}
                                style={{ marginHorizontal: 3, }}
                                color="#ffffff">
                            </Feather>
                            <Text style={TaskStyle.createTaskSaveButtonText}>
                                POST
                            </Text>
                        </TouchableOpacity>
                    </View> */}
                {/* </View> */}
                <Modal style={[TaskStyle.modalforCreateCompany1]} position={"center"} ref={"modal1"} isDisabled={this.state.isDisabled}
                    backdropPressToClose={false}
                    swipeToClose={false}
                >
                    <View style={{ justifyContent: "space-between", flexDirection: "row" }}>
                        <View style={{ alignItems: "flex-start" }}>
                        </View>
                        <View style={{ alignItems: "flex-end" }}>
                            <TouchableOpacity onPress={() => this.refs.modal1.close()} style={{
                                marginLeft: 0, marginTop: 0,
                            }}>
                                <Image resizeMode="contain" style={{ width: 15, height: 15, marginRight: 17, marginTop: 15 }} source={require('../../../assets/images/close.png')}>
                                </Image>
                            </TouchableOpacity>
                        </View>
                    </View>
                    <View style={TaskStyle.dblModelContent}>
                        <ScrollView showsVerticalScrollIndicator={false} style={{ height: "80%" }}>
                            <View style={{}} >
                                {this.renderEmpList()}
                            </View>
                        </ScrollView>
                    </View>
                </Modal>
                <Modal style={[TaskStyle.modalforCreateCompany1]} position={"center"} ref={"modalPriority"}
                    backdropPressToClose={false}
                    swipeToClose={false}
                >
                    <View style={{ justifyContent: "space-between", flexDirection: "row" }}>
                        <View style={{ alignItems: "flex-start" }}>
                        </View>
                        <View style={{ alignItems: "flex-end" }}>
                            <TouchableOpacity onPress={() => this.refs.modalPriority.close()} style={{
                                marginLeft: 0, marginTop: 0,
                            }}>
                                <Image resizeMode="contain" style={{ width: 15, height: 15, marginRight: 17, marginTop: 15 }} source={require('../../../assets/images/close.png')}>
                                </Image>
                            </TouchableOpacity>
                        </View>
                    </View>
                    <View style={TaskStyle.dblModelContent}>
                        <ScrollView showsVerticalScrollIndicator={false} style={{ height: "80%" }}>
                            <View style={{}} >
                                {this.renderPriorityList()}
                            </View>
                        </ScrollView>
                    </View>
                </Modal>

            </View >
        )
    }
}
