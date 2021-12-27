import React, { Component } from 'react';
import './styles.css';
import { Row, Col, Icon} from 'antd';



export default class TrackInformation extends Component {

	constructor(props) {
        super(props);
		this.state = {
            currentTracksID:0,
        }

    }
    updateState = (value) =>  {
        this.setState({value})
        this.setState(value, () =>{
            console.log("Personal player new state : ", this.state)
        })
    }
	render() {
        const {artist, album} = this.props.track
        return (
            <Row style={{padding: '12% 0 0 0', height:'inherit'}}>
                <Col span={1}></Col>
                <Col span={8}>
                    <img alt="playlist" src={album.cover_small} />
                </Col>
                <Col span={9}>
                    <div style={{float:'left', padding: '3% 0 0 0'}}>
                        <b> {this.props.track.title_short ?this.props.track.title_short : this.props.track.title_medium}</b>
                        <br/>
                        <p style={{ display:'inline'}}> {artist.name} </p>
                    </div>
                </Col>
                <Col span={4}>
                    <Icon style={{float:'left', margin: '40% 0 0 0'}} className="playerLike" type="heart" />
                </Col>
            </Row>
        )
    }
}
