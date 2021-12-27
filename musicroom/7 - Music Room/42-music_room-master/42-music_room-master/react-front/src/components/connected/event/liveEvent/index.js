import React, { Component } from 'react';
import './styles.css';
import Track from '../../../templates/track'
import { Col, Row, message} from 'antd'
import { DragDropContext, Droppable, Draggable } from 'react-beautiful-dnd';
import Player from '../../../other/player'
import {socket, getRoomPlaylist, updateScore, updateTracks, updateTrack, blockSocketEvent} from '../../../other/sockets';

const reorder = (list, startIndex, endIndex) => {
	const result = Array.from(list);
	const [removed] = result.splice(startIndex, 1);
	result.splice(endIndex, 0, removed);
  
	return result;
  };

export default class LiveEvent extends Component {
    constructor(props){
        super(props);
        this.state = {
            playlist    : [],
            isBlocked   : false,
            rotate      : {
                    active: false,
                    id: 0
                },
            isCreator   : false,
            isAdmin     : false,
        };
        this.roomID = this.props.roomID;
    }
    componentWillMount = () => {
        socket.on('getRoomPlaylist', (tracks, trackID) => {
            this.savePlaylist(tracks);

        });

        socket.on('updateStatus', (currentTrack) => { 
            console.log("updateStatus")
            this.props.state.data.event.currentTrack = currentTrack
            this.props.updateParent({data:this.props.state.data})
            // this.savePlaylist(tracks);
        });

        socket.on('updateTracks', (tracks) => {
            console.log("updateStatus")
            console.log(tracks)
            console.log("updateTrakc event recv");
            this.savePlaylist(tracks);
        });

        socket.on('updateScore', (tracks) => {
            console.log('Update score -> ')
            console.log(tracks)
            this.savePlaylist(tracks);
            this.setState({rotate: {active:false, id:0, liked: false}})
        });
        if (this.props.state.data.event.creator.email === this.props.state.user.email)
            this.setState({isCreator:true});
        else  {
            this.setState({isAdmin:this.isUser(this.props.state.data.event.adminMembers) });
        }
        this.setState({ playlist : this.props.playlist }, () => {
            getRoomPlaylist(this.props.roomID);
        });
    }
    savePlaylist = tracks => {
        let playlist            = this.state.playlist;
        playlist.tracks.data    = tracks;
        console.log("New order : ", playlist.tracks.data)
        this.setState({playlist:playlist});
    }
    isUser = tab => {
        let ret = false;
        tab.forEach(user => { 
            if (user._id === this.props.state.user._id)
            {
                ret = true
                return ;
            }
        });
        return ret;
    }
    callSocket = (type, OldTrack, value) => {
        let me          = this.props.state.user;
        let index       = -1;

        if (OldTrack.userLike && (index = OldTrack.userLike.indexOf(me._id)) !== -1)   
            OldTrack.userLike.splice(0, index);
        else if (OldTrack.userUnLike && (index = OldTrack.userUnLike.indexOf(me._id)) !== -1) 
            OldTrack.userUnLike.splice(0, index);
        updateTrack(this.roomID,  OldTrack);
        this.setState({rotate: {active:true, id:OldTrack._id, liked: value > 0 ? true : false}}, () => {
            updateScore(this.roomID, this.props.state.data.userCoord);
        })
    }
    onDragStart = () => {
        blockSocketEvent(this.roomID);
	}
	onDragEnd = (result) => {
        if (!result.destination) 
            return;
		let state = this.state;
		const items = reorder( this.state.playlist.tracks.data, result.source.index, result.destination.index );
        state.playlist.tracks.data = items;
        updateTracks(this.roomID, items);
    }

    render() {
        return (
            <div>
                <Row>
                    <Col span={8}> 
                        <a href="#!" className="btn waves-effect waves-teal" onClick={this.props.openCardEvent.bind(this, this.props.state.data.event)}> Back </a> 
                    </Col> 
                </Row>
                <Row>
                    <Col span={24}>
                        { this.state.playlist.tracks.data.length > 0 && <Player currentTrack={this.props.state.data.event.currentTrack.toString()} isCreator={this.state.isCreator} isAdmin={this.state.isAdmin} tracks={this.state.playlist.tracks.data} roomID={this.props.roomID} isPlay={this.props.state.data.event.is_play}/> }
                    </Col>
                </Row>
                <br/>
                <br/>
                <br/>
                <br/>
                <Row>
                    <Col span={12} offset={6}>
                        <DragDropContext onDragEnd={this.onDragEnd}>
                            <Droppable 
                                droppableId="droppable" 
                                isDragDisabled={!(this.state.isAdmin || this.state.isCreator)} 
                                isDropDisabled={!(this.state.isAdmin || this.state.isCreator)}
                            >
                            {
                                (provided, snapshot) =>  (
                                    <Row>
                                        <div ref={provided.innerRef} className="collection">
                                        {
                                            this.state.playlist.tracks.data.map((item, index) =>  (
                                                <Col span={24} key={index}>
                                                    <Draggable key={item.id} draggableId={item.id} index={index} >
                                                    {
                                                        (provided, snapshot) => (
                                                            <div ref={provided.innerRef} {...provided.draggableProps} {...provided.dragHandleProps} >
                                                                <Track 
                                                                    userID={this.props.state.user._id} 
                                                                    rotate={this.state.rotate} 
                                                                    order={index} 
                                                                    track={item}
                                                                    state={this.props.state}
                                                                    event={this.props.state.data.event}
                                                                    callSocket={this.callSocket}
                                                                    currentTrack={this.props.state.data.event.currentTrack}
                                                                />
                                                            </div>
                                                        )
                                                    }
                                                    </Draggable>
                                                </Col>
                                            ))
                                        }
                                        {provided.placeholder}
                                        </div>
                                    </Row>
                                )
                            }
                            </Droppable>
                        </DragDropContext>
                    </Col>
                </Row>
            </div>
        )
    }
}
