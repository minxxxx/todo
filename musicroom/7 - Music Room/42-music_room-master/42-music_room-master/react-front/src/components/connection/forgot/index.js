import React, { Component } from 'react';
import {Input, Button, Layout, Col, Row, Divider, message} from 'antd';
import axios from 'axios'
import Error from '../../other/errorController'

class Forgot extends Component {
	constructor(props) {
		super(props);
		this.state = {
			email: "",
		}
	}
	handleChange = event => {
		this.setState({
			[event.target.name]: event.target.value
		});
	}
	handleSubmit = () => {
        console.log("submit forgot")
        axios.post(process.env.REACT_APP_API_URL + '/user/forgotPassword', {
            'email': this.state.email
        })
        .then((resp) => {
            console.log(resp)
            console.log("ici");
            message.success("Mail Send !")
			this.props.changeCurrent('login')
        })
        .catch(err => {
            Error.display_error(err);
        })
	}
	render() {
        console.log("on est bien dans le forgot component");
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
					<Button 
					style={{'width':'100%'}} 
					size="large" 
					onClick={this.handleSubmit.bind(this)}>
					 Send
					</Button>
				</Col>
			</Row>
			<Divider />
			</Content>
		);
	}
}

export default Forgot;
