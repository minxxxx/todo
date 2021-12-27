import React, { Component } from 'react';
import axios from 'axios'
import { AutoComplete, Card, Avatar} from 'antd';
import './styles.css';
import Error from '../errorController'

export default class SearchBar extends Component {
	constructor(props) {
		super(props);
		this.state = {
			value: '',
			list: [],
			glbUserList: [],
			position: 0
		}
		this.fetchListController = this.fetchListController.bind(this);
	}
	fetchListController = value => {
		if (this.props.type === '')
			this.setState({'value': value, 'list': []})
		else if (this.props.type === 'member' || this.props.type === 'admin')
			this.fetchListUser(value);
		else if (this.props.type === 'tracks')
			this.fetchTracks(value);
		else
			this.fetchListPlaylist(value);
	}
	fetchTracks = value => {
		this.setState({value:value}, () => {
			axios.get(process.env.REACT_APP_API_URL + '/search/track?q='+ value, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
				.then((resp) => { this.setState({'list': resp.data || []}); })
				.catch((err) => { Error.display_error(err); })
		});
	}
	fetchListPlaylist = value => {
		this.setState({value:value})
		axios.get(process.env.REACT_APP_API_URL + '/search/playlist?all=on&q='+ value, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
			.then((resp) => {
				let myPlaylist = []
				if (resp.data) {
					resp.data.forEach(playlist => {
						if (!playlist.id)
							playlist.id = playlist._id
						myPlaylist.push(playlist)
					});
				}
				this.setState({'list': myPlaylist});
			})
			.catch((err) => { Error.display_error(err); })
	}
	fetchListUser = value => {
		this.setState({value:value}, () => {
			axios.get(process.env.REACT_APP_API_URL + "/user?criteria=" + value, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
				.then((resp) => {
					console.log(resp.data);
					this.setState({list: resp.data || []});

				})
				.catch((err) => { Error.display_error(err); })
		});
	}
	removeMember = (global, sub) => {
		for (let i = 0; i < global.length; i++) {
			for (let j = 0; j < sub.length; j++) {
				if (global[i].login === sub[j].login)
					global.splice(i, 1);
			}
		}
		return global;
	}
	updateEventMember = item => {
		this.props.updateEventMember(item, this.props.type);
	}
	addTrack = item => {
		this.setState({
			value: '',
			list: [],
			glbUserList: [],
			position: 0
		}, () => {
			this.props.addTrack(item);
		});		
	}
	render() {
		const { list } = this.state;
		const children = list.map((item, key) => {
			return (
				this.props.type === 'member' || this.props.type === 'admin' ? 
					<AutoComplete.Option  onClick={(e) => this.updateEventMember(item)}  key={key}> 
						<Card.Meta 
							className= "cardMemberList" 
							avatar= { 
								<Avatar src=  { item.picture = item.picture.indexOf("https://") !== -1 ? item.picture  : process.env.REACT_APP_API_URL + "/userPicture/" + item.picture} /> } 
										title=  {item.login } 
								/> 
					</AutoComplete.Option>
					: 
					this.props.type === 'playlist' ?
						<AutoComplete.Option  onClick={(e) => this.props.updateEventPlaylist(item)} key={item.id}>{item.title}</AutoComplete.Option>
						: 
						this.props.type === 'tracks' ?
							<AutoComplete.Option onClick={(e) => this.addTrack(item)} key={item.id}> {item.artist.name} - {item.title}</AutoComplete.Option>
							:
							<AutoComplete.Option onClick={(e) => this.props.updateParent({'currentComponent': 'tracks', 'id': item._id || item.id})} key={item.id}>{item.title}</AutoComplete.Option>
			);
		});
		return (
			<AutoComplete
				allowClear={true}
				style={{ width: 200 }}
				value={this.state.value}
				onSelect={this.onSelect}
				onSearch={this.fetchListController.bind(this)}>
					{children}	
			</AutoComplete>
		);
  	}
}
