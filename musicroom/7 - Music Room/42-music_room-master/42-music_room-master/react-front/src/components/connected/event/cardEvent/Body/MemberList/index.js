import React, { Component } from 'react';
import SearchBar from '../../../../../other/searchbar';
import { List, Card, Avatar, Icon, Col, Row, Layout } from 'antd';

export default class MemberList extends Component {

    componentWillMount = () => {
        this.props.members.forEach(member => {
            member.picture = member.picture.indexOf("https://") !== -1 ?
            member.picture 
            : 
            process.env.REACT_APP_API_URL + "/userPicture/" + member.picture
        });
    }
	render() {
        return (
            <Layout.Content>
                <Row style={{height:'80px'}}>
                    <Col span={3} offset={5} >
                        <b style={{display:'inline-block'}} > ({this.props.members.length}) </b>
                        <p style={{display:'inline-block'}} > {this.props.name} </p>
                    </Col>
                    <Col span={3}>
                        { 
                            this.props.right.isCreator || this.props.right.isAdmin ?  
                                <SearchBar state={this.props.state} type={this.props.type} updateEventMember={this.props.updateEventMember}/> 
                                : 
                                null 
                        }
                    </Col>
                </Row>
                { this.props.members.length > 0 ?
                    <Row style={{height:'130px'}}>
                        <Col span={16} offset={5}>
                            <List
                                grid={{ gutter: 16, column: 3 }}
                                dataSource={this.props.members}
                                renderItem={item => (
                                    <List.Item>
                                        <Card.Meta
                                            avatar={ <Avatar 
                                                        size={116} 
                                                        src={item.picture} 
                                                        />
                                                    }
                                            title={item.login}
                                        />
                                        <div 
                                            className="zoomCard" 
                                            style={{width:'5%', margin:'-10% 0 0 40%'}}
                                            onClick={this.props.removeMember.bind(this, this.props.type, item)}
                                        >
                                            <Icon style={{color:'#B71C1C'}}  type="close" theme="outlined"/>
                                        </div>
                                    </List.Item>     
                                )}
                            />
                        </Col>
                    </Row>
                    : 
                    null
                }
            </Layout.Content>
        );
    }
}