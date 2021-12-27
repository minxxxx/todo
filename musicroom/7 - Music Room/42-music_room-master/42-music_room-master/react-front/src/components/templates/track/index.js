import React, { Component } from 'react';
import './styles.css';
import { Layout, Row, Col, List, Skeleton, Avatar, message} from 'antd';
import axios from 'axios'
import { updateScore } from '../../other/sockets';
import  Error  from '../../other/errorController';


const {Content}  = Layout

export default  class liveEvent extends Component {

    like = () => {
        axios.put(process.env.REACT_APP_API_URL + '/track/' + this.props.event._id + "/like",
		{'trackId': this.props.track._id, 'userCoord': this.props.state.data.userCoord},
		{'headers': {'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then((resp) => {
            message.success("Successfully liked music")
            console.log("event -> ")
			updateScore(resp.data._id, this.props.state.data.userCoord)
		})
		.catch(err => { Error.display_error(err) })
    }
	render() {
        const picture   = this.props.track.album.cover_medium ? this.props.track.album.cover_medium : this.props.track.album.cover_large ? this.props.track.album.cover_large : this.props.track.album.cover_small;
        const title     = this.props.track.title
        const artist    = this.props.track.artist.name;
        let layoutStyle = {
            border: '0.3em solid #bdbdbd',
            backgroundColor: '#e0e0e0',
            marginBottom: '2%',
            height:'inherit'

        };
        const is_playing = this.props.track._id.toString() === this.props.currentTrack.toString() ? true : false
        if (this.props.userID) {
            layoutStyle = {
                border: '0.3em solid' +  (is_playing ?  '#ff8f00' : this.props.track.like > 0 ? '#00c853' : this.props.track.like < 0 ? '#dd2c00 ' : '#bdbdbd'),
                backgroundColor: is_playing ?  '#ffb300 ' : this.props.track.like > 0 ? '#c8e6c9' : this.props.track.like < 0 ? '#ffccbc' : '#e0e0e0',
                marginBottom: '2%',
                height:'inherit'
            };
        }
        const orderStyle = {
            margin: this.props.order + 1 < 10 ? '25% 0 0 30%' : this.props.order + 1 < 100 ? '25% 0 0 0%' : '25% 0 0 0'
        }
        const rest      = this.props.track.duration % 60;
        const min       = (this.props.track.duration - rest) / 60
        const duration  = min + ":" + rest + 'min';

        let isLike      = {display:'block'};
        let isUnLike    = {display:'none', margin:'0 1% 0 0'};

        if ( this.props.userID && this.props.track.likes.indexOf(this.props.userID) !== -1) {
            isUnLike = {display:'block'}
            isLike = {display:'none'}
        }
        else {
            isLike = {display:'block'}
            isUnLike = {display:'none'}
        }
        return (
            <Layout style={layoutStyle}>
                <Content>
                    <Row>
                        <Col span={4}>
                            <div style={orderStyle}><b style={{fontSize:'4em'}}> {this.props.order + 1}.</b></div>
                        </Col>
                        <Col span={20}>
                            
                            <List.Item actions={
                                this.props.callSocket ?
                                [
                                    <i  onClick={this.like}  
                                        style={isLike} 
                                        className="far fa-thumbs-up HoverLike"
                                    />,
                                    <i  onClick={this.like} 
                                        style={isUnLike} 
                                        className="far fa-thumbs-down HoverUnlike"
                                    />
                                ] : []}>
                            <Skeleton avatar title={false} loading={false} active>
                                <List.Item.Meta
                                    avatar={<Avatar size={118} src={picture} />}
                                    title={<p className="Ffamily" style={{fontSize:'2vh'}}> {title} </p>}
                                    description={artist}
                                />
                                {
                                    this.props.track.likes ? 
                                    <div>
                                        <b> Score : { this.props.track.likes.length} </b>
                                        <br/>
                                        <b >Duration : {duration}</b>
                                    </div>
                                    :
                                    null
                                }
                            </Skeleton>
                            </List.Item>
                        </Col>
                    </Row>
                </Content>
            </Layout>
        );
	}
};

