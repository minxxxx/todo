import React, { Component } from 'react';
import axios from 'axios';
import EditSetting from './edit';
import {Button, Divider, Layout, Col, Row, Card, Avatar, Spin, message} from 'antd';

const DZ = window.DZ;
const {Content, Footer, Header} = Layout;

class Setting extends Component {
	constructor(props) {
		super(props);
		this.state = {
			user: props.state.user,
			error: {},
			loading: false,
		};
	}
	componentWillMount = () => {
		this.getUser();
	}

	getUser = () => {
		axios.get(process.env.REACT_APP_API_URL + '/user/me', 
		{'headers':{'Authorization':'Bearer '+ localStorage.getItem('token')}})
			.then((resp) => { this.setState({user:resp.data, loading:true}); })
			.catch((err) => { this.setState({error: err}) });
	}

	loginDeezer = () => {
		const that = this;
		DZ.init({
		    appId  		: '310224',
		    channelUrl 	: process.env.REACT_APP_FRONT_URL,
		  });
        DZ.login(function(response) {
          if (response.authResponse && response.authResponse.accessToken !== null) {
			console.log(response.authResponse);
			axios.put(process.env.REACT_APP_API_URL + '/user/login/deezer?access_token=' + localStorage.getItem("token") + '&deezerToken=' + response.authResponse.accessToken)
			.then(() => {
				message.success("Successfully linked to deezer")
				that.getUser()
			})
			.catch(err => { console.log(err); })
          } else console.log('User cancelled login or did not fully authorize.');
        }, {perms: 'basic_access,email,offline_access,manage_library,delete_library'});
    }
    logoutDeezer = () => {
    	axios.delete(process.env.REACT_APP_API_URL + '/user/login/deezer', {'headers':{'Authorization' : 'Bearer ' + localStorage.getItem('token')}})
    	.then(() => {
			message.success("Successfully unlinked to deezer")
			this.getUser()
    	})
    	.catch(err => { console.log(err); })
	}
	updateState = data => {
		this.setState({user:data.user})
	}
	render() {
		let token = null;
		if (this.state.user && this.state.user.deezerToken)
			token = this.state.user.deezerToken
		if (!this.state.loading)
			return <Spin tip=" Waiting user information ..." size="large" > </Spin>
		if (this.props.state.currentComponent === 'editSetting')
			return (<EditSetting state={this.props.state} updateState={this.updateState} updateParent={this.props.updateParent} logout={this.props.logout}/>)
		else
		{
			let userPicture = this.state.user.picture.indexOf("https://") !== -1 ?  this.state.user.picture : process.env.REACT_APP_API_URL + "/userPicture/" + this.state.user.picture
			return (
				<Layout>
					<Header> <h1>Profil : </h1></Header>
					<Content>
						<Row style={{height:50}}/>
						<Row>
							<Col span={8}/>
							<Col>
								{ !token ? (<Button onClick={this.loginDeezer.bind(this)}>Link Deezer</Button>): (<Button onClick={this.logoutDeezer.bind(this)}>Unlink Deezer</Button>) }
							</Col>
						</Row>
						<Divider />
						<Row>
							<Col span={4} offset={4}>
								<Card.Meta avatar={<Avatar size={116} src={userPicture}/>} />
							</Col>
							<Col>
								<Button onClick={this.props.updateParent.bind(this,{'currentComponent': 'editSetting'})}>Edit</Button>
							</Col>
						</Row>
						<Divider />
						<Row>
							<Col span={3} offset={4}>
								<p style={{float:'right'}}>Adresse électronique :</p>
							</Col>
							<Col span={6} offset={1}>
								<b> {this.state.user.email}</b>
							</Col>
						</Row>
						<Row>
							<Col span={3} offset={4}>
								<p style={{float:'right'}}> Login :</p>
							</Col>
							<Col span={6} offset={1}>
								<b> { this.state.user.login }</b>
							</Col>
						</Row>
						<Row>
							<Col span={3} offset={4}>
								<p style={{float:'right'}}> Instruit depuis le : </p>
							</Col>
							<Col span={6} offset={1}>
								<b> { new Date(this.state.user.creationDate).toLocaleDateString('fr-FR')}</b>
							</Col>
						</Row>
						<Divider />
					</Content>
					<Footer>
					</Footer>
				</Layout>
		);
		}
  }
}

export default Setting;

