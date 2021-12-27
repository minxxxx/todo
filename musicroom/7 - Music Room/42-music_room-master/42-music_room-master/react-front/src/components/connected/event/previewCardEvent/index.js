import React, { Component } from 'react';
import { Card, Avatar, Divider, message } from 'antd';
import './styles.css';
import axios from 'axios'
import Error from '../../../other/errorController'

export default class PreviewCardEvent extends Component {
	constructor(props) {
        super(props);
        this.state = {
            visible : false,
            distance: 0
        };
    }
    getDistance = (coordA, coordB) =>  {
        let R     = 6371; // km
        let dLat  = this.toRad(coordB.lat - coordA.lat);
        let dLon  = this.toRad(coordB.lng - coordA.lng);
        let lat1  = this.toRad(coordA.lng);
        let lat2  = this.toRad(coordB.lng);

        let a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
        let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
        let d = R * c;
        return d.toFixed(0);
    }
   toRad = value => {
        return value * Math.PI / 180;
    }
    componentDidMount = () => {
        if (!this.props.event.location.coord) {
            this.props.event.location.coord = { lat: 0, lng:0 };
        }
        let distance = this.getDistance(this.props.event.location.coord, this.props.state.data.userCoord);
        this.setState({distance:distance});
        this.date = this.props.event.event_date ? this.formatDateAnnounce(this.props.event.event_date) : 'Inconnue';
    }
    showModal = () => {
        this.setState({visible: true});
    }
    handleOk = () => {
        this.setState({visible: false});
    }
    handleCancel = () => {
        this.setState({visible: false});
    }
    formatDateAnnounce = (date) => {
        let hours = date.split("Z")[0];
        if (hours) {
            hours = hours.split("T")[1];
            hours = hours.split(".")[0];
        }
        let timeEvent           = new Date(date).getTime();
        let curTime             = new Date(new Date()).getTime()
        let timeBeforeEvent     = timeEvent - curTime;
        let dayTimeStamp        = (3600 * 1000) * 24;
        let weekTimeStamp       = dayTimeStamp * 7;
        let options             = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        let ret                 = "Le : " + new Date(date).toLocaleDateString('fr-Fr', options);

        if (timeBeforeEvent < 0.0)
            return "Déja passée"
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
    delete = () => {
        axios.delete(process.env.REACT_APP_API_URL + '/event/'+ this.props.event._id, {headers:{Authorization: 'Bearer ' + localStorage.getItem('token')}})
        .then(resp => { 
            message.success("Event deleted")
            this.props.getEvents(); 
        })
        .catch(err => { Error.display_error(err); })
    }
	render() {
        const userPicture = this.props.event.creator.picture.indexOf("https://") !== -1 ? 
            this.props.event.creator.picture 
            : 
            process.env.REACT_APP_API_URL + "/userPicture/" + this.props.event.creator.picture;
        return (
            <Card
                className="zoomCard"
                style={{ width: 300, display: "inline-block", margin: "1% 2% 0 "}}
                cover={ 
                    <img 
                        onClick={this.props.openCardEvent.bind(this, this.props.event)} 
                        alt="eventPicture" 
                        src={process.env.REACT_APP_API_URL + "/eventPicture/" +  this.props.event.picture} 
                    />
                }
                actions=
                {
                    this.props.event.creator && this.props.event.creator.email && this.props.event.creator.email === this.props.state.user.email ?  [ <i onClick={this.delete} className="fas fa-trash-alt"></i> ]  : [ ]
                }
            >
                <Card.Meta
                    onClick={this.props.openCardEvent.bind(this, this.props.event)}
                    avatar={<Avatar size={116} src={userPicture} />}
                    title= {this.props.event.creator && this.props.event.creator.login ? this.props.event.creator.login : "Aucun" }
                    description=
                    {
                        <div>
                            <p style={{textAlign:'center'}}>{this.date}</p>
                            <Divider />
                            <p style={{textAlign:'center'}}>À {this.state.distance} km</p>
                        </div>
                    }
                />  
            </Card>
        )
	}
}