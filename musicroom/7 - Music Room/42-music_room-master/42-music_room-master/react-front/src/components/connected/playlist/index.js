import React, { Component } from 'react';
import List from './list'
import Tracks from './tracks'
import CreatePlaylist from './createPlaylist'
import EditPlaylist from './editPlaylist'

// TO DEL
// import { addInPlaylist } from '../sockets'

export default class Playlist extends Component {
	render() {
		return (
			<div>
				{ this.props.state.currentComponent === 'playlist'			? 	<List 										updateParent={this.props.updateParent}/> 	: null }
				{ this.props.state.currentComponent === 'tracks'			? 	<Tracks 		state={this.props.state} 	updateParent={this.props.updateParent}/> 	: null }
				{ this.props.state.currentComponent === 'createPlaylist'	? 	<CreatePlaylist state={this.props.state} 	updateParent={this.props.updateParent}/> 	: null }
				{ this.props.state.currentComponent === 'editPlaylist'		? 	<EditPlaylist 	state={this.props.state} 	updateParent={this.props.updateParent}/> 	: null }
			</div>
		);
  	}
}