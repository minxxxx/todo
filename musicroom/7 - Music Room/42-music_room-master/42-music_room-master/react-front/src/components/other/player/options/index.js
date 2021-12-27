import React, { Component } from 'react';
import {Row, Col,Progress} from 'antd';
import {socket, updatePlayer, updateStatus} from '../../sockets'

const { DZ } = window

export default class Options extends Component {
	constructor(props) {
        super(props);
		this.state = {
            volume: 50,
            mute:false
        }
    }
    componentDidMount = () => {
        if (!this.props.isCreator)
            DZ.player.setVolume(0)
        socket.on('updatePlayer', (event, data) => {
            switch (event){
                case "volume":
                    this.setVolume(data);
                    break;
                default:
                    break;
            }     
        });
    }
    playerUpdate = (event, data) => {
        if (this.props.isCreator || this.props.isAdmin) {
            if (this.props.roomID)
                updatePlayer(this.props.roomID, event, data);
            else
            {
                switch (event) {
                    case "volume":
                        this.setVolume(data);
                        break;
                    default:
                        break;
                } 
            }
        }
    }
    changeVolume = ({ target, clientX }) => {
        const { x, width } = target.getBoundingClientRect()
        const volume = (clientX - x) / width * 100
        this.setState({percent:volume}, () => {
            this.playerUpdate("volume", volume)
        })
    }
    muteVolume = () => {
        this.setState({mute:!this.state.mute})
    }
    setVolume = (value) => {
        if (value && value >= 0 && value <= 100 && this.props.isCreator) {
            DZ.player.setVolume(value)
        }
        this.setState({volume:value})
    }
	render() {
        return (
            <Row style={{padding:'20% 0 0 0'}}>
                <Col span={1}>
                    <i className="fas fa-bars"></i>
                </Col>
                <Col span={2}></Col>
                <Col span={1}>
                    <i onClick={this.muteVolume} className={this.state.mute ? "fas fa-volume-mute" : "fas fa-volume-up" }></i>
                </Col>
                <Col span={2}></Col>
                <Col span={16}>
                    <Progress strokeColor={this.props.stokeColor ? this.props.stokeColor : '#bdbdbd'} onClick={this.changeVolume.bind(this)} percent={this.state.volume}  showInfo={false}/>
                </Col>
            </Row>
        )
    }
}
