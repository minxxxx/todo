import React, { Component } from 'react';
import {Row, Col } from 'antd';
import Create from './createEvent';
import List from './listEvent';
import ListCloseEvent from './listCloseEvent';
import CardEvent from './cardEvent';
import LiveEvent from './liveEvent';
import './styles.css';

export default class Event extends Component {
	constructor(props) {
		super(props)
		this.state = {
			currentSubView: 'listEvent'
		}
		this.selectedMenu = { backgroundColor:'#00897b', opacity:1, color:'white' };
	}
	changeView = value => {
		this.props.updateParent({currentComponent:'event'})
		this.setState({currentSubView : value})
	}
	openCardEvent = event => {
        window.scrollTo(600, 600);
        this.props.state.data.event = event;
		this.props.updateParent({'currentComponent': 'cardEvent', 'data': this.props.state.data});
	}
	render() {
		if (this.props.state.currentComponent === 'cardEvent' && this.state.currentSubView)
			this.setState({currentSubView:''});
		else if (this.props.state.currentComponent === 'event' && !this.state.currentSubView)
			this.setState({currentSubView: 'listEvent'});
		return (
			<div>
				{
					this.props.state.currentComponent === 'event' ?
						<Row style={{height:'160px'}}>
							<Col 
								span={7} offset={1}  
								style={this.state.currentSubView === 'createEvent' ? this.selectedMenu : null} 
								className="cardStyle"
							>
								<div className="SimpleBgHover">
									<b className="textStyle" onClick={this.changeView.bind(this, 'createEvent')}>
										Nouvelle Évènement 
									</b>
								</div>
							</Col>
							<Col 
								span={7} 
								style={this.state.currentSubView === 'listEvent' ? this.selectedMenu : null}
								className="cardStyle" 
							>
								<div className="SimpleBgHover">
									<b className="textStyle" onClick={this.changeView.bind(this, 'listEvent')}>  
										Liste Évènements 
									</b>
								</div>
							</Col>
							<Col 
								span={7} 
								style={this.state.currentSubView === 'listcloseEvent' ? this.selectedMenu : null} 
								className="cardStyle"
							>
								<div className="SimpleBgHover">
									<b className="textStyle" onClick={this.changeView.bind(this, 'listcloseEvent')}> 
										Évènements à proximités 
									</b>
								</div>
							</Col>						
						</Row>
						:
						null 
				}
				{
					this.props.state.currentComponent 	=== 'cardEvent' 		&& <CardEvent  
																						state={this.props.state} 
																						updateParent={this.props.updateParent} 
																						changeView={this.changeView}
																					/>
				}
				{
					this.state.currentSubView 			=== 'createEvent' 		&& <Create 
																						state={this.props.state} 
																						updateParent={this.props.updateParent} 
																						changeView={this.changeView}
																					/>
				}
				{
					this.state.currentSubView 			=== 'listEvent' 		&& <List 
																						state={this.props.state}
																						changeView={this.changeView}
																						updateParent={this.props.updateParent}
																						openCardEvent={this.openCardEvent}
																					/>
				}
				{
					this.state.currentSubView 			=== 'listcloseEvent' 	&& <ListCloseEvent 
																						state={this.props.state} 
																						changeView={this.changeView}
																						updateParent={this.props.updateParent} 
																						openCardEvent={this.openCardEvent}
																					/>
				}
				{
					this.props.state.currentComponent 	=== 'liveEvent' 		&& <LiveEvent 
																					state={this.props.state} 
																					roomID={this.props.state.data.event._id}
																					updateParent={this.props.updateParent} 
																					openCardEvent={this.openCardEvent} 
																					playlist={this.props.state.data.event.playlist}
																					/>
				}
			</div>
		);
	}
}