import React, { Component } from 'react';
import { Input, Row, Col, Divider, Button, message } from 'antd'
import axios from 'axios'
import SearchBar from '../../../other/searchbar'
import Track from '../../../templates/track'
import Error from '../../../other/errorController'

export default class CreatePlaylist extends Component {
	constructor(props){
		super(props);
		this.state = {
			title: '',
			tracks: []
		};
	}
	save = () => {
		let body = {
			title: '',
			tracks:{
				data: []
			}
		};
		body.tracks.data 	= this.state.tracks;
		body.title 			= this.state.title;
		axios.post(process.env.REACT_APP_API_URL + '/playlist', body, {'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}} )
			.then(() => { 
				message.success("Successfully created playlist")
				this.props.updateParent({currentComponent:'playlist'}) 
			})
			.catch((err) => { Error.display_error(err); })  
	}
	handleChange = event =>{
    	this.setState({[event.target.name]: event.target.value});
    }
    addTrack = item => {
    	this.setState({tracks: [...this.state.tracks, item]})
	}
    deleteTrack =(index) => {
    	let array = [...this.state.tracks];
    	array.splice(index, 1);
    	this.setState({tracks:array});
    }
	render() {
		return (
			<div>
				<Row>
					<Col span={8}>
						<a 
							href="#!" 
							className="btn waves-effect waves-teal" 
							onClick={() => this.props.updateParent({currentComponent: 'playlist'})}>Back
						</a>
					</Col>
				</Row>
				<Row>
					<Col span={2} offset={8}>
						<div style={{margin:'20% 0 0 0'}}> <b> Titre playlist : </b>  </div>
					</Col>
					<Col span={3} >
						<Input 
							value={this.state.title} 
							name="title" 
							onChange={this.handleChange}/>
					</Col>
				</Row>
				<Divider />
				<Row>
					<Col span={2} offset={8}>
							<div style={{margin:'10% 0 0 0'}}> <b> Ajouter un titre : </b>  </div>
					</Col>
					<Col span={8}>
						<SearchBar 
							updateParent={this.props.updateParent} 
							type="tracks" 
							addTrack={this.addTrack}/>
					</Col>
				</Row>
				<Row>
					<Col span={12} offset={6}>
					{
						this.state.tracks.map((val, i) => {
							return (<Track key={i} order={i} track={val}/>);
						})
					}
					</Col>
				</Row>
				<Divider />
				<Row>
					<Col span={3} offset={11}>
						<Button onClick={this.save.bind(this)}> Save </Button>
					</Col>
				</Row>
			</div>
		);
  }
}
