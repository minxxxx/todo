import React, { Component } from 'react';
import axios from 'axios';
import { Icon, Button, Input, Upload, message, Divider, Layout, Col, Row} from 'antd';
import Error from '../../../other/errorController'
import './styles.css'

const {Content, Footer, Header} = Layout

export default class EditSetting extends Component {
	constructor(props) {
		super(props);
		console.log(props);
		this.state = {
			login: props.state.user.login,
			password: null,
			cpypassword: null,
			picture: this.props.state.user.picture.indexOf("https://") !== -1 ? this.props.state.user.picture: process.env.REACT_APP_API_URL + "/userPicture/" + this.props.state.user.picture,
			newPicture: '',
			loading:false,
			infoFile: '',
		};
		this.currentUser = props.state.user;
	}

	updateChange(e) {
		this.setState({[e.target.name]: e.target.value});
	}

	checkInput = () => {
		let err = 0;
		if (this.state.login) {
			if (this.state.login.length < 3) {
				err++;
				message.info("Password to short")
			}
			else
				this.currentUser.login = this.state.login
		}
		if (this.state.password && this.state.cpypassword) {
			if (this.state.password.length < 8) {
				err++;
				message.info("Password to short")
			}
			else if (this.state.password !== this.state.cpypassword) {
				err++;
				message.info("Pasword != Copy password")
			}
			else
				this.currentUser.password = this.state.password
		}
		return (err)
	}

	updateSave() {
		let data = new FormData();

		if (this.checkInput() === 0) {
			if (this.state.infoFile && this.state.infoFile.file && this.state.infoFile.file.originFileObj)
				data.append('file', this.state.infoFile.file.originFileObj);
			let user = {
				picture : this.currentUser.picture,
				login : this.currentUser.login,
				password: this.currentUser.password
			}
			data.append('body', JSON.stringify(user));
			axios.put(process.env.REACT_APP_API_URL + '/user/me', data, {'headers' : {'Authorization': 'Bearer '+ localStorage.getItem('token')}})
				.then(resp => {
					message.success("Account successfully updated !")
					this.props.updateState({user:resp.data})
					this.props.updateParent({currentComponent: 'setting', user:resp.data})
				})
				.catch(err => { 
					Error.display_error(err);
					console.log(err); 
				})
		}
	}
	
	handlePicture = info => {
		this.setState({infoFile: info})
		if (info.file.status === 'uploading') {
			this.setState({loading:true});
			return;
		} 
		if (info.file.originFileObj)
			this.getBase64(info.file.originFileObj, newPicture => this.setState({ newPicture, loading: false}));
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

	deleteUser = () => {
		axios.delete(process.env.REACT_APP_API_URL + "/user/me",
		{'headers' : {'Authorization': 'Bearer '+ localStorage.getItem('token')}})
		.then(resp => {
				message.success("Account successfully deleted");
				this.props.logout();
		})
		.catch(err => {
			Error.display_error(err);
		})
	}

	render() {
		this.uploadButton = (
            <div>
              <Icon type={this.state.loading ? 'loading' : 'plus'} />
              <div className="ant-upload-text">Upload</div>
            </div>
		  );
	return (
		<Layout>
			<Header> <h1>Modifier le profil : : </h1></Header>
			<Content>
				<Row style={{height:30}}/>
				<Row>
					<Col span={4} offset={1}>
						<a 
							href="#!" 
							className="btn waves-effect waves-teal" 
							onClick={() => this.props.updateParent({'currentComponent': 'setting'})}>Back
						</a>
					</Col>
					<Col span={4} offset={15}>
						<a 
							href="#!" 
							className="btn waves-effect waves-red"
							style={{'backgroundColor':'red'}}
							onClick={this.deleteUser}>Delete Account
						</a>
					</Col>
				</Row>
				<Row>
					<Col span={4} offset={4}>
						<div style={{'margin': '0 0 0 25% '}}>
							<Upload
									name="file"
									listType="picture-card"
									className="avatar-uploader"
									showUploadList={false}
									beforeUpload={this.beforeUpload}
									onChange={this.handlePicture}
								>
								<img className="avatar-uploader" src={this.state.newPicture ? this.state.newPicture : this.state.picture} alt="avatar" />
								{this.state.newPicture ? null : this.uploadButton}
							</Upload>
                        </div>
					</Col>
				</Row>
				<Divider />
				<Row>
					<Col span={3} offset={4}>
						<p> Login :</p>
					</Col>
					<Col span={6} offset={1}>
						<Input name="login" placeholder="Enter your login" style={{ width: 200 }} value={this.state.login} onChange={this.updateChange.bind(this)}/>
					</Col>
				</Row>
				<Row>
					<Col span={3} offset={4}>
						<p> Mot de passe : </p>
					</Col>
					<Col span={6} offset={1}>
						<Input 
							name="password" 
							type="password" 
							placeholder="Enter your password" 
							style={{ width: 200 }} 
							value={this.state.password} 
							onChange={this.updateChange.bind(this)}/>
					</Col>
				</Row>
				<Row>
					<Col span={3} offset={4}>
						<p> Confirmer le mot de passe : </p>
					</Col>
					<Col span={6} offset={1}>
						<Input name="cpypassword" type="password" placeholder="Enter your password" style={{ width: 200 }} value={this.state.cpypassword} onChange={this.updateChange.bind(this)}/>
					</Col>
				</Row>
				<Divider />
				<Row>
					<Col span={6} offset={8}>
						<Button onClick={this.updateSave.bind(this)}>Save</Button>
					</Col>
				</Row>
				
			</Content>
			<Footer>
			</Footer>
		</Layout>
	);
  }
}


