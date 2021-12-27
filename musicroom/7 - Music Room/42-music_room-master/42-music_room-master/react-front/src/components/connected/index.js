import React, { Component } from 'react';
import { Layout, Spin } from 'antd';
import Event from './event'
import Playlist from './playlist'
import Setting from './setting'
import axios from 'axios'

const { DZ } = window;

export default class Connected extends Component {
	constructor(props){
		super(props);
		this.state = {
			collapsed: true,
			height: props.height,
			loading: true,
		};
	}
	componentWillMount = () => {
		DZ.player.seek(0);
		DZ.player.pause()
		this.getGeolocalisation();
	}
	getGeolocalisation = () => {
		if (!this.props.state.data.userCoord) 
		{
			this.props.state.data.userCoord = {};
			/* Default Paris coord */
			this.props.state.data.userCoord.lat = 2.3522219;
			this.props.state.data.userCoord.lng = 48.856614;
			/* Get user ip */
			axios.get('https://api.ipify.org?format=json')
				.then(ip => {
					/* Transform user ip to coord */
					axios.get('https://geo.ipify.org/api/v1?apiKey=at_a4068uhAAope5JSeZRIwg1wRZ0UIQ&ipAddress=' + ip.data.ip)
						.then(resp => {
							this.props.state.data.userCoord.lat = resp.data.location.lat
							this.props.state.data.userCoord.lng = resp.data.location.lng
							if (navigator.geolocation) {
								navigator.geolocation.getCurrentPosition(
									(position) =>  {
										this.props.state.data.userCoord.lat = position.coords.latitude
										this.props.state.data.userCoord.lng = position.coords.longitude
										this.props.updateParent({'data': this.props.state.data})
										this.setState({loading:false})
									},
									() =>  {
										console.log("getGeolocalisation -> cant more accuracy")
										this.props.updateParent({'data': this.props.state.data})
										this.setState({loading:false})
									},
									{ maximumAge:Infinity, timeout:5000 }
								);
							}
						
					})
				})
		}
		this.setState({height: window.innerHeight + 'px', loading:false});
	}

	toggle = () => {
		this.setState({ collapsed: !this.state.collapsed});
	}
	render() {
		if (this.state.loading)
			return <Spin tip=" Waiting location ..." size="large" > </Spin>
		else {
			return (	
				<Layout> 
					<Layout.Content style={{ margin: '24px 16px', padding: 24, background: '#fff', minHeight: this.state.height }}>
						{ 
							this.props.state.data.userCoord.lat && this.props.state.data.userCoord.lng && 
							(this.props.state.currentComponent === 'event' || this.props.state.currentComponent === 'createEvent' || this.props.state.currentComponent === 'liveEvent' || this.props.state.currentComponent === 'cardEvent') ? 
								<Event state={this.props.state} updateParent={this.props.updateParent}/> 
								: 
								null
						}
						{
							this.props.state.currentComponent === 'playlist' || this.props.state.currentComponent === 'createPlaylist' || this.props.state.currentComponent === 'tracks' || this.props.state.currentComponent === 'editPlaylist' ? 
								<Playlist state={this.props.state} updateParent={this.props.updateParent}/> 
								: 
								null
						}
						{
							this.props.state.currentComponent === 'setting' || this.props.state.currentComponent === 'editSetting'? 
								<Setting state={this.props.state} updateParent={this.props.updateParent} logout={this.props.logout}/> 
								: 
								null
						}
					</Layout.Content>
				</Layout>
			);
		}
  	}
}
