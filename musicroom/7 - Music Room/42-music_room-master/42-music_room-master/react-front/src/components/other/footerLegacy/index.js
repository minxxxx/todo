import React, { Component } from 'react';
import "antd/dist/antd.css";
import Player from '../player'

export default class FooterLegacy extends Component {
	constructor(props) {
		super(props);
		this.state = {
        }
    }
  render() {
    if ( this.props.state.currentPlayerTracks && this.props.state.currentPlayerTracks.tracks.length > 0 && this.props.state.currentComponent !== 'liveEvent') {
      return (
        <Player  isAdmin={true} isCreator={false} tracks={this.props.state.currentPlayerTracks.tracks} isPlay={false}/> 
      )
    }
    else return ( <div></div> );
  }
}
