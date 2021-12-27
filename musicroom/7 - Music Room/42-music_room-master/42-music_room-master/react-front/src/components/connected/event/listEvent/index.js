import React, { Component } from 'react';
import PreviewCard from '../previewCardEvent'
import { Layout, Spin, message } from 'antd';
import axios from 'axios'
import Error from '../../../other/errorController'

export default class ListEvent extends Component {
	constructor(props) {
        super(props);
        this.state = {
			loading		:true,
			myEvents	: [],
			friendEvents: [],
			allEvents	: []
		};		
	}
	componentDidMount = () => {
		this.getEvents(ret => {
			if (ret.myEvents && ret.myEvents.length > 0)
				ret.myEvents.sort((a, b) 		=> { return a.event_date > b.event_date });
			if (ret.friendEvents && ret.friendEvents.length > 0)
				ret.friendEvents.sort((a, b) 	=> { return a.event_date > b.event_date });
			if (ret.allEvents && ret.allEvents.length > 0)
				ret.allEvents.sort((a, b) 		=> { return a.event_date > b.event_date });
			this.setState({
				myEvents	: ret.myEvents, 
				friendEvents: ret.friendEvents, 
				allEvents	: ret.allEvents, 
				loading		: false
			})
		});
	}
	getEvents = callback => {
		axios.get(process.env.REACT_APP_API_URL + '/event', {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
		.then(resp => {
			if (resp.data.myEvents.length < 1 && resp.data.friendEvents.length < 1 && resp.data.allEvents.length < 1) {
				this.props.changeView('createEvent');
				message.error("Aucun évènenements disponible.")
				callback([])
			}
			else if (callback) {
				callback(resp.data);
			}
			else
			{
				this.setState({
					myEvents	: resp.data.myEvents, 
					friendEvents: resp.data.friendEvents, 
					allEvents	: resp.data.allEvents, 
					loading		: false
				});
			}
		})
		.catch(err => {
			console.log("DISPLAY ERRO R:", err)
			Error.display_error(err);
			this.setState({
				myEvents	: [], 
				friendEvents: [], 
				allEvents	: [], 
				loading		: false
			});
		});
	}
	render() {
		if (this.state.loading)
			return <Spin tip=" Waiting events ..." size="large" > </Spin>
		else {
			return (
				<Layout>
					<Layout.Content style={{width:'82%', margin: '0 8% 0 10%'}}>
						<div style={{padding:'1% 0 1% 0'}}>
						{ this.state.myEvents.length > 0 ? 
							<h1 style={{fontSize:'36px'}}> Mes événements : </h1> 
							: 
							null 
						}
						{
							this.state.myEvents.map((event, key) => {
								return ( 
									<PreviewCard 
											key={key} 
											event={event} 
											state={this.props.state} 
											updateParent={this.props.updateParent} 
											getEvents={this.getEvents } 
											openCardEvent={this.props.openCardEvent}
										/> 
									);
							})
						}
						</div>
						<div style={{padding:'1% 0 1% 0'}}>
						{ 
							this.state.friendEvents.length > 0 ? 
								<h1 style={{fontSize:'36px'}}>  Evénement ou je participe : </h1> 
								: 
								null 
						}
						{
							this.state.friendEvents.map((event, key) => {
								return ( 
									<PreviewCard 
										key={key} 
										event={event} 
										state={this.props.state} 
										updateParent={this.props.updateParent}
										getEvents={this.getEvents }
										openCardEvent={this.props.openCardEvent}
									/> 
								);
							})
						}
						</div>
						<div style={{padding:'1% 0 1% 0'}}>
						{ 
							this.state.allEvents.length > 0 ? 
								<h1 style={{fontSize:'36px'}}> Tous les évenements : </h1> 
								: 
								null 
						}
						{
							this.state.allEvents.map((event, key) => {
								return ( 
									<PreviewCard 
										key={key} 
										event={event} 
										state={this.props.state} 
										updateParent={this.props.updateParent} 
										getEvents={this.getEvents } 
										openCardEvent={this.props.openCardEvent}
									/> 
								);
							})
						}
						</div>
					</Layout.Content>
				</Layout>
			);
		}
	}
}

