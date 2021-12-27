import React, { Component } from 'react';
import axios from 'axios'
import { Input, Button, Col, Row, List, Icon, Card, Avatar, message, Checkbox, Divider } from 'antd'
import SearchBar from '../../../other/searchbar'
import Error from '../../../other/errorController'

export default class EditPlaylist extends Component {
	constructor(props){
		super(props);
		this.state = {
			playlist: {title:'', members:[],public:true, tracks:{data:[]}},
			isloading: false
		};
	}
	componentDidMount = () => {
		this.getPlaylist((ret) => {this.setState({playlist:ret.data, isloading:false})});
	}
	getPlaylist = callback => {
		this.setState({isloading: true});
		axios.get(process.env.REACT_APP_API_URL + '/playlist/' + this.props.state.id, {'headers':{'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then((resp) => {
			if (callback)
				callback(resp)
			else
				this.setState({playlist:resp.data, isloading:false})
		})
		.catch((err) => {
			this.setState({playlist:{title:'', members:[],public:true, tracks:{data:[]}}, isloading:false})
			Error.display_error(err);
		})
	}
	handleChange = e =>{
		var tmp = this.state.playlist;
		tmp.title = e.target.value;
		this.setState({playlist: tmp});
	}
	save = () =>{
		axios.put(process.env.REACT_APP_API_URL + '/playlist/' + this.state.playlist._id || this.state.playlist.id, 
		this.state.playlist,
		{'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then(() => {
			message.success("Successfully saved playlist")
			this.props.updateParent({'currentComponent':'tracks'})
		})
		.catch(err => { Error.display_error(err) })
	}
	delete = () => {
		axios.delete(process.env.REACT_APP_API_URL + '/playlist/' + this.state.playlist._id || this.state.playlist.id,
			{'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}}
		)
		.then(() => { 
			message.success("Successfully deleted playlist")
			this.props.updateParent({'currentComponent':'playlist', id:null}) })
		.catch(err => { Error.display_error(err) })
	}
	addTrack = item => {
    	this.setState({ tracks: [...this.state.tracks, item] })
	}
	updatePlaylistMember = item => {
		let isMember = this.state.playlist.members.filter( elem => elem['_id'] === item._id )
		if (isMember.length > 0) {
			message.error("member already in playlist")
			return;
		}
		let state = this.state;
		state.playlist.members.push(item);
		axios.put(process.env.REACT_APP_API_URL + '/playlist/' + this.state.playlist._id || this.state.playlist.id, 
		state.playlist,
		{'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then(() => {
			message.success("Successfully added member")
			this.getPlaylist()
		})
		.catch(err => { Error.display_error(err) })
	}
	removeMember = item => {
		let state = this.state
		let newMembers = this.state.playlist.members.filter( (elem) => {
			if (elem['_id'] !== item._id)
				return elem;
			return null
		});
		state.playlist.members = newMembers;
		axios.put(process.env.REACT_APP_API_URL + '/playlist/' + this.state.playlist._id || this.state.playlist.id, 
		state.playlist,
		{'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then(() => { 
			message.success("Successfully deleted member")
			this.getPlaylist()
		 })
		.catch(err => { Error.display_error(err) })
	}
	setPublic = () => {
		let state = this.state;
		state.playlist.public = !state.playlist.public
		this.setState(state);
	}
	render() {
		if (this.state.isloading === true) {
			return (
				<div>
					<a 
						href="#!" 
						className="btn waves-effect waves-teal" 
						onClick={this.props.updateParent.bind(this,{'currentComponent': 'tracks'})}>Back
					</a>
					<div>
						No tracks
					</div>
				</div>
			);
		}
		return (
			<div>
				<Row type="flex" justify="space-between">
					<Col>
						<a 
							href="#!" 
							className="btn waves-effect waves-teal" 
							onClick={this.props.updateParent.bind(this,{'currentComponent': 'tracks'})}>Back
						</a>
					</Col>
					<Col>
						<a 
							href="#!" 
							className="btn waves-effect" 
							style={{'backgroundColor': 'red'}} 
							onClick={this.delete}>Delete
						</a>
					</Col>
				</Row>
				<Row>
					<Col span={8} offset={8}>
						<b> Modifier le titre : </b>
						<Input 
							value={this.state.playlist.title} 
							onChange={(e) => this.handleChange(e)}>
						</Input>
					</Col>
				</Row>
				{
					this.state.playlist.idUser === this.props.state.user._id ?
						<Row>
							<Col span={1} offset={10}>
								<h1> Playlist : </h1>
							</Col>
							<Col span={2}>
								<div style={{'margin': '0 0 0 12% '}}>
									<Checkbox name="public" checked={this.state.playlist.public} onChange={() => {this.setPublic()}}> {this.state.playlist.public ? "Public" : "Privé" }</Checkbox>
								</div>
							</Col>
						</Row> 
						: 
						null
				}
				<Divider/>
				<Row style={{height:'80px'}}>
					<Col span={3} offset={7} > 
						<b style={{display:'inline-block'}} > ({this.state.playlist.members.length}) </b>
						<b> Ajouter des membres : </b>
					</Col>
                    <Col span={3}>
                        <SearchBar state={this.props.state}  updateEventMember={this.updatePlaylistMember} type="member"/> 
                    </Col>
                </Row>
				{ this.state.playlist.members.length > 0 ?
                    <Row style={{height:'130px'}}>
                        <Col span={16} offset={5}>
                            <List
                                grid={{ gutter: 16, column: 3 }}
                                dataSource={this.state.playlist.members}
                                renderItem={item =>  {
									item.picture = item.picture.indexOf("https://") !== -1 ?
									item.picture 
									: 
									process.env.REACT_APP_API_URL + "/userPicture/" + item.picture
									return (
										<List.Item>
                                        <Card.Meta
                                            avatar={ <Avatar 
                                                        size={116} 
                                                        src={item.picture} 
                                                        />
                                                    }
                                            title={item.login}
                                        />
                                        <div 
                                            className="zoomCard" 
                                            style={{width:'5%', margin:'-10% 0 0 40%'}}
                                            onClick={() => this.removeMember(item)}
                                        >
                                            <Icon style={{color:'#B71C1C'}}  type="close" theme="outlined"/>
                                        </div>
                                    </List.Item>  
									)
								}}
                            />
                        </Col>
                    </Row>
                    : 
                    null
				}
				<Divider/>
				<Row>
					<Col span ={3} offset={10}>
						<Button 
							onClick={this.save}>Save
						</Button>
					</Col>
				</Row>
			</div>
		);
  	}
}
