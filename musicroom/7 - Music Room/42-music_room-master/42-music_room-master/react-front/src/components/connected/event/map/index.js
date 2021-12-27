import {Map, InfoWindow, Marker} from 'google-maps-react';
import { Avatar, Card} from 'antd';
import React, { Component } from 'react';

const {google} = window 

export default class MapContainer extends Component {
       constructor(props) {
        super(props)
        this.state = {
            showingInfoWindow   : false,
            activeMarker        : {},
            selectedPlace       : {},
            bounds              : {},
            eventsMarkers       : []
        };
    }
    componentDidMount = () => {
        const eventsMarkers = [];
        const points        = [];
        this.props.events.forEach((event, key) => {
            const options               = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            const date                  = "Le : " + new Date(event.event_date).toLocaleDateString('fr-Fr', options);
            if (event.location.coord) {
                eventsMarkers.push(
                    <Marker
                        key={key}
                        onClick={this.onMarkerClick}
                        title={event.description}
                        name={event.title}
                        picture= {event.picture ? process.env.REACT_APP_API_URL + "/eventPicture/" + event.picture : process.env.REACT_APP_API_URL + "/eventPicture/default.jpeg"}
                        position={event.location.coord}
                        date={date}
                        data={event}/>
                )
                points.push(event.location.coord)
            }
        })
        eventsMarkers.push( <Marker key={"TOTO"} position={this.props.state.data.userCoord} />)
        points.push(this.props.state.data.userCoord)
        let bounds          = new google.maps.LatLngBounds();
        for (var i = 0; i < points.length; i++) {
          bounds.extend(points[i]);
        }
        this.setState({bounds:bounds, eventsMarkers:eventsMarkers});
    }
    onMarkerClick = (props, marker, e) => {
        this.setState({
            selectedPlace: props,
            activeMarker: marker,
            showingInfoWindow: !this.state.showingInfoWindow
        }, () => {
            this.props.updateCurrentEvent(this.state.selectedPlace.data);
        });
    }
    onMapClicked = (props) => {
        if (this.state.showingInfoWindow) {
            this.setState({
                showingInfoWindow: false,
                activeMarker: null
            });
        }
    }
    render() {
        return (
        <Map 
            google={google}
            initialCenter={this.props.center ? this.props.center : this.props.state.data.userCoord}
            onClick={this.onMapClicked}
            zoom={8}
            bounds={this.state.bounds}>
            { this.state.eventsMarkers }
                <InfoWindow
                    marker={this.state.activeMarker}
                    visible={this.state.showingInfoWindow}
                    >
                    <div style={{height:'120px', padding:'2% 0 0 0'}}>
                        <Card.Meta
                            avatar={<Avatar size={116} src={this.state.selectedPlace.picture} />}
                            title= {this.state.selectedPlace.name}
                            description= {this.state.selectedPlace.date}
                        />
                    </div>
                </InfoWindow>
        </Map>
        )
    }
}