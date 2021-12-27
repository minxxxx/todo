import React, { Component } from 'react';
import './styles.css';
import {Row, Col} from 'antd';
import {socket, updatePlayer, updateStatus} from '../../sockets'

const { DZ } = window

export default class Player extends Component {

	constructor(props) {
        super(props);
		this.state = {
            isPlaying : this.props.isPlay || false,
            repeat: false,
            random: false,
            currentTracksID: 0,
            tracksID: [],
            tracks: [],
        };
    }
    componentWillMount = () => {
        let tracksID = []
        let getPlay     = 0;
        this.props.tracks.forEach(track => {
            if (track._id.toString() === this.props.currentTrack) {
                getPlay = tracksID.length;
            } 
            tracksID.push(track.id) 
        });
        this.props.updateParentState({currentTracksID:getPlay})
        this.setState({tracksID:tracksID, tracks:this.props.tracks, currentTracksID:getPlay}, () => {
            DZ.player.playTracks(tracksID, getPlay)
            this.setState({isPlaying:true})
            console.log("[BEFORE]")
            console.log("------------------------------------")
            console.log("List : ", DZ.player.getTrackList())
            console.log("Current Track :  : ", DZ.player.getCurrentTrack())
            console.log("Current Track Index : ", DZ.player.getCurrentIndex())
            console.log("------------------------------------")

            DZ.player.setVolume(50)
        });
    }

    componentDidMount = () => {
        socket.on('updatePlayer', (event) => {
            console.log("Socket : updatePlayer receive data : ", event, this.props)
            switch (event){
                case "next":
                    this.nextTrack();
                    break;
                case "suiv":
                    this.nextTrackSuiv();
                    break;
                case "prev":
                    this.prevTrack();
                    break;
                case "play":
                    this.playTrack();
                    break;
                case "pause":
                    this.pauseTrack();
                    break;
                case "changePosition":
                    this.setState({isPlaying:true});
                    DZ.player.play();
                    break;
                default:
                    break;
            }     
        })
        socket.on('getRoomPlaylist', (tracks, trackID) => {
            let index = 0;
            console.log("ici", tracks);
            for (var i = 0; i < tracks.length; i++) {
                if (tracks[i]._id.toString() === this.props.currentTrack) {
                    index = i;
                    break;
                }
            }
            this.setState({currentTracksID:index, tracks:tracks})
            this.props.updateParentState({currentTracksID:index})
            DZ.player.playTracks(tracks, index)
            DZ.player.play()
        });

        socket.on('updateStatus', (currentTrack) => {
            let index = 0;
            for (var i = 0; i < this.state.tracks.length; i++) {
                if (this.state.tracks[i]._id.toString() === currentTrack) {
                    index = i;
                    break;
                }
            }
            this.setState({currentTracksID:index})
            this.props.updateParentState({currentTracksID:index})
        });
        socket.on('updateScore', (tracksNew) => {
            // console.log("Socket : updateScore receive data : ", tracksNew)

            // console.log("[BEFORE]")
            // console.log("------------------------------------")
            // console.log("List : ", DZ.player.getTrackList())
            // console.log("Current Track :  : ", DZ.player.getCurrentTrack())
            // console.log("Current Track Index : ", DZ.player.getCurrentIndex())
            // console.log("------------------------------------")

            // let oldArray = this.state.tracks.map((track) => {
            //     return track.id
            // })
            let indexArray = tracksNew.map((track) => {
                return track.id
            })
            // console.log("INDEX ARRAY  :", indexArray, oldArray)
            
            this.setState({tracks:tracksNew})
            // this.setState({tracksID:indexArray})
            // console.log(DZ.player);
            // DZ.player.playTracks(indexArray, this.state.currentTracksID)
            DZ.player.changeTrackOrder(indexArray)
            
            // console.log("[AFTER]")
            // console.log(DZ.player);
            // console.log("------------------------------------")
            // console.log("List : ", DZ.player.getTrackList())
            // console.log("Current Track :  : ", DZ.player.getCurrentTrack())
            // console.log("Current Track Index : ", DZ.player.getCurrentIndex())
            // console.log("------------------------------------")
        });
    }
    updateState = value =>
    {
        if (value === 'repeat' && this.state.random && (this.props.isAdmin || this.props.isCreator)) this.setState({repeat:true, random:false})
        else if (value === 'random' && this.state.repeat && (this.props.isAdmin || this.props.isCreator)) this.setState({random:true, repeat:false})
        else this.setState({[value]:!this.state[value]})
    }
    playTrack = () => {
        console.log("Player : play")
        this.setState({isPlaying:true}, () => {
            DZ.player.play()
        });
    }
    pauseTrack = () => {
        console.log("Player : pause")
        this.setState({isPlaying:false}, () => {
            DZ.player.pause()
        });
    }
    nextTrack = () => {
        let index = this.state.currentTracksID + 1;
        if (index >= this.state.tracks.length)
            return ;     
        if (index - 1 >= 0 && this.props.roomID)
            updateStatus(this.props.roomID, this.state.tracks[index]._id)
        this.setState({currentTracksID:index});
        this.props.updateParentState({currentTracksID:index});
        console.log(this.state.tracks)
        DZ.player.playTracks(this.state.tracks, this.state.currentTracksID)
        DZ.player.next();
            // 

        console.log(this.state.currentTracksID)
        // DZ.player.next();
        // DZ.player.seek(0);
    }
    nextTrackSuiv = () => {
        let index = this.state.currentTracksID + 1;
        if (index >= this.state.tracks.length)
            return ;     
        if (index - 1 >= 0 && this.props.roomID) {
            updateStatus(this.props.roomID, this.state.tracks[index]._id)
        }
        this.setState({currentTracksID:index});
        this.props.updateParentState({currentTracksID:index});
        DZ.Event.subscribe('tracklist_changed', e => {
            console.log("itoto keke")
            DZ.player.playTracks(this.state.tracks, this.state.currentTracksID)
            // DZ.player.next();
            // DZ.player.seek(0);
        })
    }
    prevTrack = () => {
        let index = this.state.currentTracksID - 1;
        if (index < 0)
            return ;
        if (index + 1 < this.state.tracks.length  && this.props.roomID)
           updateStatus(this.props.roomID, this.state.tracks[index]._id)
        this.setState({currentTracksID:index})
        this.props.updateParentState({currentTracksID:index})
        DZ.player.prev();
        DZ.player.seek(0);
    }

    playerUpdate = (event) => {
        console.log("PLayer update : ", this.props)
        if (this.props.isCreator || this.props.isAdmin) {
            if (this.props.roomID)
                updatePlayer(this.props.roomID, event);
            else
            {
                switch (event){
                    case "next":
                        this.nextTrack();
                        break;
                    case "prev":
                        this.prevTrack();
                        break;
                    case "play":
                        this.playTrack();
                        break;
                    case "pause":
                        this.pauseTrack();
                        break;
                    default:
                        break;
                } 
            }
        }
    }

	render() {
        return (
            <Row style={{height:'inherit', margin:'3% 0 0 0'}}>
                <Col span={3}/>
                <Col span={3}>
                    <i onClick={this.updateState.bind(this, 'random')} style={this.state.random ? {color:"#4caf50"} : {color:"#424242"}} className="fas fa-random playerSubAction"></i>
                </Col>
                <Col span={1}/>
                <Col span={3}>
                    <i onClick={() => {this.playerUpdate("prev")}} className="fas fa-backward playerAction"></i>
                </Col>
                <Col span={1}/>
                <Col span={3}>
                    <i onClick={() => {this.playerUpdate((this.state.isPlaying ? "pause" : "play") )}} className={this.state.isPlaying ? "fas fa-pause-circle playerAction" : "fas fa-play-circle playerAction"}></i>  
                </Col>
                <Col span={1}/>
                <Col span={3}>
                    <i onClick={() => {this.playerUpdate("next")}} className="fas fa-forward playerAction"></i>
                </Col>
                <Col span={1}/>
                <Col span={3}>
                    <i onClick={this.updateState.bind(this, 'repeat')} style={this.state.repeat ? {color:"#4caf50"} : {color:'#424242'}} className="fas fa-redo-alt playerSubAction"></i>
                </Col>
            </Row>
        )
    }
}
