import React, { Component } from 'react';
import { Checkbox, Divider, Card, Avatar, Modal, Icon, Col, Row, InputNumber} from 'antd';
import { updateEvent} from '../../../../other/sockets';

export default class CreatorProfil extends Component {
    constructor(props) {
        super(props);
        this.state = {
            iconPrivacy:'',
            visible:false,
            userPicture: ''
        };
    }
    componentWillMount = () =>{
        this.setState({iconPrivacy:this.props.state.data.event.public ? 'unlock' : 'lock'});
        this.setState({
            userPicture:this.props.state.data.event.creator.picture.indexOf("https://") !== -1 ?
                this.props.state.data.event.creator.picture  
                :  
                process.env.REACT_APP_API_URL + "/userPicture/" + this.props.state.data.event.creator.picture
        });
    }
    handleChangePrivacy = () => {
        if (!this.props.right.isCreator && !this.props.right.isAdmin)
            return ;
        this.props.state.data.event.public = !this.props.state.data.event.public;
        this.setState({iconPrivacy: this.props.state.data.event.public ? 'unlock' : 'lock'});
        updateEvent(this.props.state.data.event._id, this.props.state.data.event);
    }
    handleChangeDistanceRequired = () => {
        if (!this.props.right.isCreator && !this.props.right.isAdmin)
            return ;
        this.props.state.data.event.distance_required = !this.props.state.data.event.distance_required;
        updateEvent(this.props.state.data.event._id, this.props.state.data.event);
    }
    handleChangeDistance = (val) => {
       if  (val > 1 && val < 9999 && (this.props.right.isCreator || this.props.right.isAdmin))
       {
            this.props.state.data.event.distance_max = val;
            updateEvent(this.props.state.data.event._id, this.props.state.data.event);
       }
    }
    showModal = () => {
        console.log("Je suis ici")
        this.setState({visible: true});
    }
    handleOk = () => {
        if (this.props.right.isCreator || this.props.right.isAdmin)
            updateEvent(this.props.state.data.event._id, this.props.state.data.event);
        this.setState({visible: false});
    }
    handleCancel = () => {
        this.setState({visible: false});
    }
	render() {
        return (
            <div>
            <Row >
                <Col span={9} offset={4}>
                    <Card.Meta
                        avatar={<Avatar size={116} src={this.state.userPicture}/>}
                        title= { this.props.state.data.event.creator && this.props.state.data.event.creator.login ? 
                                    this.props.state.data.event.creator.login 
                                    : 
                                    "Inconnue" 
                                }
                        description= { this.props.state.data.event.creator.email }
                    />
                    <Icon 
                        style= {{fontSize : '30px'}}  
                        onClick= {this.handleChangePrivacy.bind(this)} 
                        type= { this.state.iconPrivacy } 
                        theme="outlined" 
                    />
                        <b  style={{padding:'0 3% 0 0'}} onClick={this.handleChangePrivacy.bind(this)} > 
                        {
                            this.props.state.data.event.public ?
                                " Public" 
                                : 
                                " Privé" 
                        }
                        </b>
                    <Icon 
                        style={{fontSize : '30px'}}
                        onClick={this.showModal} 
                        type="user" 
                        theme="outlined"
                    />
                        <b style={{padding: '0 3% 0 0'}} onClick={this.showModal}> 
                        { 
                            this.props.state.data.event.members.length || this.props.state.data.event.adminMembers.length ?
                                this.props.state.data.event.members.length + this.props.state.data.event.adminMembers.length + " participants" 
                                :
                                "0 participant" 
                        }
                        </b>
                </Col>
                { 
                    this.props.state.data.event.public ? 
                        null 
                        :
                        <Col span={10}>
                            <Row style={{margin:'17% 0 0 0'}} >
                                <Col span={1}>
                                    <Checkbox name="public"  checked={this.props.state.data.event.distance_required} onChange={this.handleChangeDistanceRequired}/>
                                </Col>
                                <Col span={9} >
                                <b> Distance maximum pour participer ? </b>
                                </Col>
                                {
                                    this.props.state.data.event.distance_required ?
                                    <Col span={4}>
                                        <InputNumber  disabled={(!this.props.right.isAdmin && !this.props.right.isCreator) } size="small" min={0} max={999}  name="distance_max" value={this.props.state.data.event.distance_max} onChange={(this.handleChangeDistance)}/> <b> km </b>
                                    </Col>
                                    :
                                    null
                                }
                            </Row>
                        </Col>
                      
                }
            </Row>
            <Modal
                title="Liste des participants : "
                visible={this.state.visible}
                onOk={this.handleOk.bind(this, "modTitle")}
                onCancel={this.handleCancel}
            >
                <b>  Admin Members ({this.props.state.data.event.adminMembers.length}) : </b>
                {
                    this.props.state.data.event.adminMembers.map((member, key) => {
                        let userPicture = member.picture.indexOf("https://") !== -1 ?
                                            member.picture 
                                            : 
                                            process.env.REACT_APP_API_URL + "/userPicture/" + member.picture
                        return (
                            <div style={{margin: '3% 0 0 0'}} key={key}>
                                <Card.Meta avatar={<Avatar src={userPicture} />} />
                                <div style={{margin: '3% 0 0 0'}}>
                                    <p> {member.login}</p>
                                </div>
                            </div>
                        )
                    })
                }
                <Divider />
                <b> Members ({this.props.state.data.event.members.length}) : </b>
                {
                    this.props.state.data.event.members.map((member, key) => {
                        let userPicture = member.picture.indexOf("https://") !== -1 ?
                                            member.picture 
                                            : 
                                            process.env.REACT_APP_API_URL + "/userPicture/" + member.picture
                        return (
                            <div className="previewMember" key={key}>
                                <Card.Meta avatar={<Avatar src={userPicture} />} />
                                <div className="previewMemberLogin">
                                    <p> {member.login}</p>
                                </div>
                            </div>
                        );
                    })
                }   
                </Modal>
            <Divider />
           </div>
        );
    }
}
