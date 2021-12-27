import React, { Component } from 'react';
import './styles.css';
import defaultImage from '../../../../assets/playlist.png'
import axios from 'axios'
import {Button, Row, Col} from 'antd'
import SearchBar from '../../../other/searchbar'
import Error from '../../../other/errorController'

export default class List extends Component {
	constructor(props) {
		super(props);
		this.state = {
			playlist: {myPlaylists:[],friendPlaylists:[],allPlaylists:[]},
			loading:true
		};
	}
	componentDidMount() {
		this.setState({loading: true});
		axios.get(process.env.REACT_APP_API_URL + '/playlist', {'headers':{'Authorization': 'Bearer ' + localStorage.getItem('token')}})
		.then((resp) => { this.setState({playlist: resp.data, loading:false}) })
		.catch((err) => {
			this.setState({playlist: {myPlaylists:[],friendPlaylists:[],allPlaylists:[]}, loading:false})
			Error.display_error(err);
		})
	}
	render() {
		if (this.state.isloading === true ) {
			return (
				<div className="preloader-wrapper active loader">
					<div className="spinner-layer spinner-red-only">
					<div className="circle-clipper left">
						<div className="circle"></div>
					</div><div className="gap-patch">
						<div className="circle"></div>
					</div><div className="circle-clipper right">
						<div className="circle"></div>
					</div>
					</div>
				</div>
			);
		}
		else {
			console.log(this.state);
			return (
				<div>
				<Row type="flex" justify="space-between">
					<Col>
						<b> Rechercher une playlist Deezer : </b>
						<SearchBar updateParent={this.props.updateParent}/>
					</Col>
					<Col>
						<Button onClick={this.props.updateParent.bind(this, {'currentComponent': 'createPlaylist'})}>+</Button>
						<b> Créer une playlist</b>
					</Col>
				</Row>
				<ul className="collection">
					<div className="styleCollection">
						<h1 className="listTitle"> Mes Playlists : </h1>
						{
							this.state.playlist.myPlaylists.map((val, i) => {
								console.log('Val : ', val)
								return (
									<div className="listContent" key={i} >
										<li 
											className="collection-item avatar" 
											onClick={this.props.updateParent.bind(this,{'currentComponent': 'tracks', 'id': val._id || val.id})}>
											<img src={val.picture_small || defaultImage} alt="" className="circle"/>
											<span className="title">{<b>Titre : {val.title}</b>}</span>
											<p>{val.description}</p>
										</li>
									</div>
								);
							})
						}
					</div>
				</ul>
				<ul className="collection">
					<div className="styleCollection">
						<h1 className="listTitle"> Playlists de mes amis : </h1>
						{
							this.state.playlist.friendPlaylists.map((val, i) => {
								return (
									<div className="listContent" key={i} >
										<li 
											className="collection-item avatar" 
											onClick={this.props.updateParent.bind(this,{'currentComponent': 'tracks', 'id': val._id || val.id})}>
											<img src={val.picture_small || defaultImage} alt="" className="circle"/>
											<span className="title"> <b>Titre : {val.title}</b></span>
											<p>{val.description}</p>
										</li>
									</div>
								);
							})
						}
					</div>
				</ul>
				<ul className="collection">
					<div className="styleCollection">
					<h1 className="listTitle"> Playlists publiques : </h1>
					{
						this.state.playlist.allPlaylists.map((val, i) => {
							return (
								<div className="listContent" key={i} >
									<li 
										className="collection-item avatar" 
										onClick={this.props.updateParent.bind(this,{'currentComponent': 'tracks', 'id': val._id || val.id})}>
										<img src={val.picture_small || defaultImage} alt="" className="circle"/>
										<span className="title"><b>Titre : {val.title}</b></span>
										<p>{val.description}</p>
									</li>
								</div>
							);
						})
					}
					</div>
				</ul>
				</div>
			);
		}
  	}
}