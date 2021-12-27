import React, { Component } from 'react';
import {Button, Input, message, Layout, Col, Row, Divider} from 'antd';
import axios from 'axios'
import './styles.css';

class Login extends Component {
	constructor(props) {
		super(props);
		this.state = {
			email: "",
			password: ""
		}
	}

	validateForm() {
		return this.state.email.length > 0 && this.state.password.length > 0;
	}
	handleChange = event => {
		this.setState({
			[event.target.name]: event.target.value
		});
	}
	handleSubmit = event => {
		event.preventDefault();
		axios.post(process.env.REACT_APP_API_URL + '/user/login', {
				'email': this.state.email,
				'password': this.state.password
		})
		.then((resp) => {
			localStorage.setItem('token', resp.data.token)
			this.props.updateParent(
				{
					'token':resp.data.token,
					'currentComponent': 'event',
					'user': resp.data.user
				});
		})
		.catch((err) => { 
			message.error("Invalid credentials")
		})
	}
	render() {
		const {Content} = Layout;
		return (
			<Content>
			<Divider/>
			<Row>
				<Col span={4} offset={10}>
					<Input 
					placeholder="Email" 
					name= "email" 
					value={this.state.email} 
					onChange={this.handleChange}/>
				</Col>
			</Row>
			<Row>
				<Col span={4} offset={10}>
					<Input 
					placeholder="Password" 
					type="password" 
					name= "password" 
					value={this.state.password} 
					onChange={this.handleChange}/>
				</Col>
			</Row>
			<Row>
				<Col span={4} offset={10}>
					<Button 
					style={{'width':'100%'}} 
					size="large" 
					onClick={this.handleSubmit.bind(this)}>
					 Login 
					</Button>
				</Col>
			</Row>
			<Divider />
			</Content>
		);
	}
}

export default Login;
