import React, { Component } from 'react';
import axios from 'axios'
import { Divider, Icon, Col, Row, Modal, Input, DatePicker, message } from 'antd';
import './styles.css';
import MemberList from './MemberList';
import Error from '../../../../other/errorController'
import SearchBar from '../../../../other/searchbar';
import LocationSearchInput from '../../locationSearchInput'
import { updateEvent, updateTracks } from '../../../../other/sockets';
import moment from 'moment';

export default class Body extends Component {
    constructor(props) {
        super(props);
        this.state = {
            playlistId : this.props.state.data.event.playlist && this.props.state.data.event.playlist.id ? this.props.state.data.event.playlist.id : null,
            isPlaying:false
        };
        this.roomID =  this.props.state.data.event._id;
    }

    componentDidMount = () => {
        if (this.props.state.data.event.playlist 
            && (this.props.state.currentPlayerTracks.id === (this.props.state.data.event.playlist.id ||this.props.state.data.event.playlist._id)))
                this.setState({isPlaying:true})
        this.setState({formatDate: this.formatDateAnnounce(this.props.state.data.event.event_date)})
    }

    updateLocation = val => {
        let location = {
                address : {
                    p: val.addressObj.address_components[5]  ? val.addressObj.address_components[5].long_name : 'Inconnue',
                    v: val.addressObj.address_components[2]  ? val.addressObj.address_components[2].long_name : 'Inconnue',
                    cp: val.addressObj.address_components[6] ? val.addressObj.address_components[6].long_name : 'Inconnue',
                    r: val.addressObj.address_components[1]  ? val.addressObj.address_components[1].long_name : 'Inconnue',
                    n: val.addressObj.address_components[0]  ? val.addressObj.address_components[0].long_name : 'Inconnue'
                },
                coord: {
                    lat: val.location.coord ? val.location.coord.lat: 0,
                    lng: val.location.coord ? val.location.coord.lng: 0,
                }
        }
        this.props.state.data.event.location = location
        this.props.updateParent({'data':this.props.state.data})
    }

    handleChangeDateModal = (value, dateString) => {
        let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        let ret     = "Le : " + new Date(dateString).toLocaleDateString('fr-Fr', options) + ' à ' + dateString.split(" ")[1];
        
        this.props.state.data.event.event_date = new Date(dateString);
        this.props.updateParent({'data':this.props.state.data});
        this.setState({formatDate:ret});
    }

    handleChangeModal = (e) => {
        this.props.state.data.event[e.target.name] = e.target.value;
        this.props.updateParent({'data': this.props.state.data});
    }

    updateEventMember = (value, type) => {
        if (value && type === 'member')
            this.props.state.data.event.members.push(value);
        else if  (value && type === 'admin')
            this.props.state.data.event.adminMembers.push(value);
        this.props.updateParent({'data': this.props.state.data});
        updateEvent(this.roomID, this.props.state.data.event);
    }

    updateEventPlaylist = playlist => {
        if (playlist) {
            axios.get(process.env.REACT_APP_API_URL + '/playlist/' + playlist.id, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
            .then((resp) => { 
                let currentPlayerTracks = {
                    tracks: resp.data.tracks.data || [],
                    id:  resp.data.id ||  resp.data._id
                };
                playlist = resp.data
                this.props.state.data.event.playlist = playlist;
                this.props.updateParent({'currentPlayerTracks': currentPlayerTracks, 'data' : this.props.state.data, 'playlistId':playlist.id})
                updateEvent(this.roomID, this.props.state.data.event)
                updateTracks(this.roomID, this.props.state.data.event.playlist.tracks.data)
                this.setState({playlistId:playlist.id, isPlaying:true})         
            })
            .catch((err) => { Error.display_error(err); })  
        }
    }

    removeMember = (type, item) => {
        let tab = [];
        if ((this.props.right &&  !this.props.right.isAdmin && !this.props.right.isCreator ) && item._id !== this.props.state.user._id)
            return message.error("Vous n'avez pas les bons droits pour cette action.")
        if (type === 'admin')
            tab = this.props.state.data.event.adminMembers;
        else  
            tab = this.props.state.data.event.members;

        for (let i = 0; i < tab.length; i++)
        {
            if (tab[i]._id === item._id) {
                tab.splice(i, 1)
                break;
            }
        }
        if (type === 'admin') 
            this.props.state.data.event.adminMembers = tab;
        else  
            this.props.state.data.event.members = tab;
        this.props.updateParent({'data': this.props.state.data});
        updateEvent(this.roomID, this.props.state.data.event);
    }

    showModal = value => {
        if (this.props.right.isCreator || this.props.right.isAdmin)
            this.setState({[value]: true});
    }

    handleOk = value => {
        updateEvent(this.roomID, this.props.state.data.event);
        this.setState({[value]: false});
    }

    handleCancel = value => {
        this.setState({[value]: false});
    }

    formatDateAnnounce = date => {
        date                    = date.toString()
        let hours               = '';
        let timeEvent           = new Date(date).getTime();
        let curTime             = new Date(new Date()).getTime()
        let timeBeforeEvent     = timeEvent - curTime;
        let dayTimeStamp        = (3600 * 1000) * 24;
        let weekTimeStamp       = dayTimeStamp * 7;
        let options             = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        let ret                 = "Le : " + new Date(date).toLocaleDateString('fr-Fr', options);

        if (date.includes("Z")) {
            hours = date.split("Z")[0];
            if (hours) {
                hours = hours.split("T")[1];
                hours = hours.split(".")[0];
            }
        }
        else
            hours = date.split(' ')[4]
        
        if (timeBeforeEvent < 0.0 && curTime > moment().endOf('day')) {
            return "Déja passée"
        }
        if (timeBeforeEvent > weekTimeStamp)
            return ret
        else if (timeBeforeEvent === weekTimeStamp)
            return ("Dans une semaine")
        else {
           let day = timeBeforeEvent / dayTimeStamp
            if (day < 1)
                return "Aujourd'hui à " + hours
            if (day <= 2)
                return "Demain à " + hours
            if (day > 2) 
                return "Après-demain à " + hours
            else 
                return ("Dans " + day + ' jours')
        }
    }

    playerLoadTracksFromEvent = () => {
        let currentPlayerTracks = {
            tracks: [],
            id: 0
        };
        if (!this.props.state.data.event.playlist.tracks.data || this.props.state.data.event.playlist.tracks.data.length === 0)
            return message.error("Error : aucune playlist charge.")
        if (!this.state.isPlaying)  {
            currentPlayerTracks.tracks = this.props.state.data.event.playlist.tracks.data;
            currentPlayerTracks.id = this.props.state.data.event.playlist.id ||  this.props.state.data.event.playlist._id;
        }
        this.props.updateParent({'currentPlayerTracks' : currentPlayerTracks})
        this.setState({isPlaying:!this.state.isPlaying}, () => {
            window.scrollTo(2000, 2000)
        })
    }

    disabledDate = current => {
        // Can not select days before today and today
        return current && current <= moment().startOf('day');
    }

	render() {
        return (
            <div>
                <Row>
                    <Col span={14} offset={4}>
                        <h1 className="titleBig"  onClick={this.showModal.bind(this, "modTitle")}> {this.props.state.data.event.title || "Aucun"}</h1>
                        <i className="titleBig fas fa-map" style={{color:'#00695c'}}onClick={this.props.updateMap.bind(this)}></i>
                        <Divider />
                    </Col>
                </Row>
                <Row style={{height:'80px'}}>
                    <Col span={5}  offset={5} style={{ borderLeft: '2px solid #00695c'}}>
                        <div style={{margin:'0 0 0 3%'}} onClick={this.showModal.bind(this, "modLocation")}>
                            <Icon className="titleMedium" type="pushpin" theme="outlined" />
                            <b className="titleMedium"> {this.props.state.data.event.location.address.v} </b>
                        </div>
                    </Col>
                    <Col span={5}>
                        <div onClick={this.showModal.bind(this, "modDate")} style={{ borderLeft: '2px solid #00695c'}}>
                            <Icon className="titleMedium"  type="clock-circle" theme="outlined" />
                            <b className="titleMedium"> { this.formatDateAnnounce(this.props.state.data.event.event_date)}</b>
                        </div>
                    </Col>
                </Row>
                <Row>
                    <Col span={2}  offset={5}>
                        <b> Description : </b>
                    </Col>
                    <Col span={8}>
                        <div onClick={this.showModal.bind(this, "modDesc")}>
                            <p> { this.props.state.data.event.description } </p>
                        </div>
                        <Divider />
                    </Col>
                </Row>

                <MemberList 
                    state={this.props.state} name={" Ajouter un membre :"}  
                    members={this.props.state.data.event.members}
                    type={"member"}       
                    removeMember={this.removeMember} 
                    updateEventMember={this.updateEventMember} 
                    right={this.props.right}
                />
                <MemberList 
                    state={this.props.state} 
                    name={" Ajouter un admin :"} 
                    members={this.props.state.data.event.adminMembers}
                    type={"admin"} 
                    removeMember={this.removeMember}
                    updateEventMember={this.updateEventMember}
                    right={this.props.right}
                />
                
                <Divider />
                        <Row style={{height:'70px'}}>
                            <Col span={1} offset={5}>
                                {this.props.state.data.event.playlist ? <i 
                                    onClick={ this.playerLoadTracksFromEvent.bind(this)} 
                                    className={ this.state.isPlaying ? "fas fa-pause-circle playerAction" : "fas fa-play-circle playerAction"}></i> : null }
                            </Col>
                            <Col span={3} >
                                <p  > Ajouter une playlist : </p>
                            </Col>
                            {
                                ((this.props.right.isAdmin || this.props.right.isCreator) && !this.props.state.data.event.is_start) ? 
                                    <Col span={3}>
                                        <SearchBar 
                                            state={this.props.state} 
                                            type="playlist" 
                                            updateEventPlaylist={this.updateEventPlaylist}/>
                                    </Col>
                                    :
                                    <Col span={3}>
                                        {this.props.state.data.event.playlist ? this.props.state.data.event.playlist.title : 'Titre Inconnue'}
                                    </Col>
                            }
                        </Row>
                {/* Modal for description modification  */}
                <Modal 
                    title="Description : "
                    visible={this.state.modDesc}
                    onOk={this.handleOk.bind(this, "modDesc")}
                    onCancel={this.handleCancel.bind(this, "modDesc")}
                >
                    <Input.TextArea  
                        placeholder="Descriptif de l'évènement : " 
                        name= "description" 
                        value={this.props.state.data.event.description} 
                        onChange={this.handleChangeModal}
                    /> 
                </Modal>
                {/* Modal for title modification  */}
                <Modal 
                    title="Title : "
                    visible={this.state.modTitle}
                    onOk={this.handleOk.bind(this, "modTitle")}
                    onCancel={this.handleCancel.bind(this, "modTitle")}
                >
                    <Input  
                        placeholder="Descriptif de l'évènement : " 
                        name= "title" value={this.props.state.data.event.title} 
                        onChange={this.handleChangeModal}
                    /> 
                </Modal>
                {/* Modal for date modification  */}
                <Modal 
                    title="Date : " 
                    visible={this.state.modDate} 
                    onOk={this.handleOk.bind(this, "modDate")} 
                    onCancel={this.handleCancel.bind(this, "modDate")} 
                >
                    <Row>
                        <Col span={8}  offset={8}> 
                            <div style={{textAlign:'center'}}> 
                                <b> {this.state.formatDate} </b> 
                            </div>  
                        </Col>
                    </Row>
                    <Divider />
                    <Row>
                        <Col span={8}  offset={8}>
                            <DatePicker
                                name="event_date"
                                disabledDate={this.disabledDate}
                                showTime
                                format="YYYY-MM-DD HH:mm:ss"
                                placeholder="Select Time"
                                onChange={this.handleChangeDateModal}
                            />
                        </Col>
                    </Row>
                </Modal>
                {/* Modal for location modification  */}
                <Modal 
                    title="Localisation : "
                    visible={this.state.modLocation}
                    onOk={this.handleOk.bind(this, "modLocation")}
                    onCancel={this.handleCancel.bind(this, "modLocation")}
                >
                    <LocationSearchInput state={this.props.state} updateLocation={this.updateLocation} />
                </Modal>
            </div>
        );
  }
}

