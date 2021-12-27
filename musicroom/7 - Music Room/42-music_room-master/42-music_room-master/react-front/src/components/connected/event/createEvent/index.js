import React, { Component } from 'react';
import LocationSearchInput from '../locationSearchInput'
import './styles.css';
import axios from 'axios'
import SearchBar from '../../../other/searchbar'
import { Avatar, Card, Icon, Button, Input, DatePicker, Upload, message, Divider, Layout, Col, Row, InputNumber, Switch} from 'antd';
import Error from '../../../other/errorController'
import moment from 'moment';

export default class CreateEvent extends Component {
	constructor(props) {
        super(props);
        this.state = {
            creator          : null,
            members          : [],
            adminMembers     : [],
            title            : '',
            description      : '',
            picture          : '',
            playlist         : null,
            event_date       : new Date(),
            date             : '',
            format_date      : '',
            public           : true,
            location         : {},
            imageUrl         : '',
            infoFile         : '',
            loading          : false,
            distance_max     : 3,
            distance_required:false,
        };
    }
    updateLocation = val => {
        let location = {
                address : {
                    p: val.addressObj.address_components[5]  ? val.addressObj.address_components[5].long_name : 'Inconnue',
                    v: val.addressObj.address_components[2]  ? val.addressObj.address_components[2].long_name : 'Inconnue',
                    cp: val.addressObj.address_components[6] ? val.addressObj.address_components[6].long_name : 'Inconnue',
                    r: val.addressObj.address_components[1]  ? val.addressObj.address_components[1].long_name : 'Inconnue',
                    n: val.addressObj.address_components[0]  ? val.addressObj.address_components[0].long_name : 'Inconnue'
                },
                coord: {
                    lat: val.location.coord ? val.location.coord.lat: 0,
                    lng: val.location.coord ? val.location.coord.lng: 0,
                }
        }
        this.setState({'location':location});
    }
    updateEventPlaylist = playlist => {
        if (!playlist)
            return ;
        else  if (playlist._id && playlist.id === playlist._id )
            this.setState({playlist:playlist});
       else {
            axios.get(process.env.REACT_APP_API_URL + '/playlist/' + playlist.id, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
            .then((resp) => { 
                playlist.tracks         = {};
                playlist.tracks.data    = [];
                playlist.tracks.data    = resp.data.data;
                
                this.setState({playlist:playlist});
            })
            .catch((err) => { Error.display_error(err); })  
        }
    }
    handleSubmit = event => {
        event.preventDefault();
        if (!this.state.description || !this.state.title || !this.state.event_date || !this.state.location.coord) {
            return message.info("Error input invalid")
        }
        let data = new FormData();    
        if (this.state.infoFile && this.state.infoFile.file && this.state.infoFile.file.originFileObj)
            data.append('file', this.state.infoFile.file.originFileObj);
        axios.get(process.env.REACT_APP_API_URL + '/user/me', {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
        .then((resp) => {
            this.event = {
                creator             : resp.data,
                title               : this.state.title,
                description         : this.state.description,
                playlist            : this.state.playlist,
                event_date          : this.state.event_date,
                date                : new Date(),
                public              : this.state.public,
                location            : this.state.location,
                members             : [],
                adminMembers        : [],
                distance_max        : this.state.distance_max,
                distance_required   : this.state.distance_required
            }
            data.append('body', JSON.stringify(this.event));
            axios.post(process.env.REACT_APP_API_URL + '/event/',  data, {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
            .then((resp) => { 
                message.info("Evènement crée");
                this.props.changeView('listEvent')
            })
            .catch((err) => { Error.display_error(err); }) 
        })
        .catch((err) => { Error.display_error(err); }) 
    }
    handleChangeDistance = value => { 
        this.setState({distance_max: value});
    }
    handleChange = event => { 
        this.setState({[event.target.name]: event.target.value});
    }
    handleChangeDate = (value, dateString) => {
        this.setState({'event_date':  dateString});
        this.setState({'format_date':  this.formatDateAnnounce(dateString)});
    }
    /* IMAGE UPLOAD AND DISPLAY PREVIEW IMAGE */
    handlePicture = info => {
        this.setState({infoFile: info});
        if (info.file.status === 'uploading') {
          this.setState({loading:true});
          return;
        }
        if (info.file.originFileObj)
            this.getBase64(info.file.originFileObj, imageUrl => this.setState({ imageUrl, loading: false}));
      }
    getBase64 = (img, callback) => {
        const reader = new FileReader();
        reader.addEventListener('load', () => callback(reader.result));
        reader.readAsDataURL(img);
    }
    beforeUpload = file => {
        const isJPG = file.type === 'image/jpeg';
        if (!isJPG) message.error('You can only upload JPG file!');
        const isLt2M = file.size / 1024 / 1024 < 2;
        if (!isLt2M) message.error('Image must smaller than 2MB!');
        return isJPG && isLt2M;
    }
    resetPicture = () => {
        this.setState({infoFile:null, imageUrl: null, loadind:false});
    }
    /* ******************************************** */
    formatDateAnnounce = date => {
        let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        let ret = "Le : " + new Date(date).toLocaleDateString('fr-Fr', options) + ' à ' + date.split(" ")[1];
        return ret;
    }    
    disabledDate = current => {
        // Can not select days before today and today
        return current && current  <  moment().startOf('day');
    }
	render = () => {
        this.uploadButton = ( <div> <Icon type={this.state.loading ? 'loading' : 'plus'} /> <div className="ant-upload-text">Upload</div> </div> );
        return (
            <Layout >
                <Layout.Content>
                    <Row> 
                        <Col span={8}> 
                            <a href="#!" className="btn waves-effect waves-teal" onClick={() => this.props.changeView('listEvent')}>Back</a> 
                        </Col> 
                    </Row>
                    <Row>
                        <Col span={8} offset={8}>
                            {
                                this.state.imageUrl ? 
                                    <div style={{'textAlign': 'center', 'margin': '0 0 0 12% '}}>
                                        <Card.Meta avatar={ <Avatar  size={448}src={this.state.imageUrl} alt="avatar" />}/>
                                        <i onClick={() => this.resetPicture()} className="zoomCard fas fa-sync-alt"></i>
                                    </div>
                                    :
                                    <div style={{'margin': '0 0 0 25% '}}>
                                        <Upload 
                                            name="file" 
                                            listType="picture-card" 
                                            className="avatar-uploader" 
                                            showUploadList={false} 
                                            beforeUpload={this.beforeUpload} 
                                            onChange={this.handlePicture.bind(this)} 
                                        >
                                            { this.uploadButton }
                                        </Upload>
                                    </div>
                            }
                            <Divider />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={8} offset={8}>
                            <Input 
                                placeholder="Titre de l'évènement : " 
                                name= "title" 
                                value={this.state.title} 
                                onChange={this.handleChange}
                            />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={14} offset={5}>
                            <Input.TextArea  
                                placeholder="Descriptif de l'évènement : " 
                                name= "description" 
                                value={this.state.description} 
                                onChange={this.handleChange}
                            /> 
                            <Divider />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={2} offset={10}>
                            <Switch defaultChecked onChange={() => {this.setState({public:!this.state.public})}} /> {this.state.public ? "Public" : "Privé"}
                            <Divider />
                        </Col>
                        { 
                            this.state.public ? 
                                null 
                                :
                                <Col span={10}>
                                    <Row >
                                        <Col span={2}>
                                        <Switch defaultunChecked onChange={() => {this.setState({distance_required:!this.state.distance_required})}} />
                                        </Col>
                                        <Col span={9} >
                                        <b> Distance maximum pour participer : </b>
                                        </Col>
                                        {
                                            this.state.distance_required ?
                                            <Col span={4}>
                                                <InputNumber size="small" min={0} max={999}  name="distance_max" value={this.state.distance_max} onChange={(this.handleChangeDistance)}/> <b> km </b>
                                            </Col>
    
                                            :
                                            null
                                        }

                                    </Row>
                                </Col>
                        }
                    </Row>
                    <Row>
                        <Col span={9} offset={10}>
                            <Row>
                                <Col span={10} offset={2}>
                                    <DatePicker
                                            name="event_date"
                                            showTime
                                            format="YYYY-MM-DD HH:mm:ss"
                                            placeholder="Select Time"
                                            onChange={this.handleChangeDate}
                                            disabledDate={this.disabledDate}
                                        />
                                </Col>
                                <Col span={12} style={{margin: '3% 0 0 0'}}>
                                    <b> {this.state.format_date} </b>
                                </Col>
                            </Row>
                            <Divider />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={14} offset={5}>
                            <LocationSearchInput 
                                displayMap={false}
                                state={this.props.state} 
                                updateLocation={this.updateLocation} 
                            />
                            <Divider />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={5}  offset={9}>
                            <b> Playlist : </b>
                            <SearchBar 
                                state={this.props.state} 
                                type="playlist" 
                                updateEventPlaylist={this.updateEventPlaylist}
                            />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={13} offset={6}>
                        {this.state.playlist && this.state.playlist.title}
                        <Divider />
                        </Col>
                    </Row>
                    <Row>
                        <Col span={4} offset={10}>
                            <div style={{'margin': '0 0 0 12% '}}> 
                                <Button  onClick={this.handleSubmit.bind(this)}> 
                                    Créer l'évènement
                                </Button> 
                            </div>
                        </Col>
                    </Row>
                </Layout.Content>
        </Layout>
    );
  }
}

